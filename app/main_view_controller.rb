class MainViewController < UIViewController
  
  #
  # launch sequence
  #
  
  def loadView
    views = NSBundle.mainBundle.loadNibNamed 'MainView', owner: self, options: nil
    self.view = views.first
  end

  def viewDidLoad
    super
    
    @model      = MainModel.new
    @testing    = false
    @trials     = (1..60).to_a.shuffle
    @trial      = 0
    @time       = nil
    @distance   = 0
    @error      = 0
    @cursor_idx = 0
    
    load_text_field
    load_test_button
    load_tilt_toggle
    load_tilt_label
    load_gyro_reset_button
    load_keyboard_down_button
    load_accelerometer
    
    center = NSNotificationCenter.defaultCenter
    center.addObserver(self, selector: "text_change", name: UITextViewTextDidChangeNotification, object: @text_field)
  end
  
  #
  # load actions
  #
  
  def load_text_field
    @text_field = self.view.viewWithTag 1
    @text_field.text = 'Here is some sample text to play around with.'
    # place cursor when app is launched, error occurs otherwise
    @text_field.becomeFirstResponder
  end
  
  def load_test_button
    @test_button = self.view.viewWithTag 2
    @test_button.addTarget(self, action: 'test_button_press:', forControlEvents: UIControlEventTouchDown)
  end
  
  def load_tilt_toggle
    @tilt_toggle = self.view.viewWithTag 3
  end
  
  def load_tilt_label
    @tilt_label = self.view.viewWithTag 4
  end
  
  def load_gyro_reset_button
    button = self.view.viewWithTag 5
    button.addTarget(self, action: 'reset_button_press:', forControlEvents: UIControlEventTouchDown)
  end
  
  def load_keyboard_down_button
    button = self.view.viewWithTag 6
    button.addTarget(self, action: 'down_button_press:', forControlEvents: UIControlEventTouchDown)
  end
  
  def load_accelerometer
    @motion_manager = CMMotionManager.alloc.init
    @motion_manager.deviceMotionUpdateInterval = @model.sample_rate
    
    if (@motion_manager.isDeviceMotionAvailable)
      queue = NSOperationQueue.currentQueue
      @motion_manager.startDeviceMotionUpdatesToQueue(queue, withHandler: lambda do |motion, error|
        # NSLog "X: %@, Y: %@, Z: %@", "%.3f" % motion.rotationRate.x, "%.3f" % motion.rotationRate.y, "%.3f" % motion.rotationRate.z
        handle_motion(motion.rotationRate)
      end)
    else
      NSLog 'Device Motion is not available.'
    end
  end
  
  #
  # define actions
  #
  
  def handle_motion(rotation_rate)
    # toggle tilt cursor movement
    if @tilt_toggle.isOn
      # update tilt values
      @model.update_movements(rotation_rate)
      # move the cursor in a direction
      move_cursor(@model.cursor_direction)
    end
  end
  
  def move_cursor(dir)
    # calculate old cursor position and new cursor position
    selected  = @text_field.selectedTextRange
    new_pos   = @text_field.positionFromPosition(selected.start, offset: dir)
    new_range = @text_field.textRangeFromPosition(new_pos, toPosition: new_pos)
    
    # distance to the beginning and end of text in relation to cursor
    beginning_offset = @text_field.offsetFromPosition(@text_field.beginningOfDocument, toPosition: selected.start)
    end_offset = @text_field.offsetFromPosition(selected.start, toPosition: @text_field.endOfDocument)
    
    # ensure that cursor will not wrap around inappropriately
    unless (selected.start == @text_field.endOfDocument && dir > 0) ||
           (beginning_offset < -dir && dir < -1) ||
           (end_offset < dir && dir > 1)
      # move the cursor
      @text_field.setSelectedTextRange new_range
    end
  end
  
  def distance_to_target
    # get the target index
    if append_idx.nil?
      target_idx = prepend_idx
    else
      target_idx = append_idx
    end
    # get the distance from the cursor to the target
    distance = (get_cursor_idx - target_idx).abs
    # calculate the number of rows and cols to target from cursor
    rows       = distance / @model.text_field_width
    cols_right = distance % @model.text_field_width
    cols_left  = @model.text_field_width % distance
    # use the smaller number of columns
    cols_right < cols_left ? cols = cols_right : cols = cols_left
    # add rows and columns
    rows + cols
  end
  
  def test_button_press(sender)
    # start and stop testing (begins where left off)
    if @testing
      @testing = false
      sender.setTitle('Begin Test', forState: UIControlStateNormal)
      end_testing
    else
      @testing = true
      sender.setTitle('Cancel Test', forState: UIControlStateNormal)
      begin_trial
    end
  end
  
  def reset_button_press(sender)
    @model.x = 0
    @model.y = 0
  end
  
  def down_button_press(sender)
    @text_field.resignFirstResponder if @text_field.isFirstResponder      
  end
  
  def end_testing
    # display test results in CSV format
    @text_field.setText(@model.format_data)
  end
  
  def begin_trial
    # generate trial text
    @text_field.setText(@model.generate_text(@trials[@trial], trial_type))
    
    # set cursor at last position, reset other values
    reset_cursor
    @distance = distance_to_target
    @error    = 0
    @time     = Time.now
  end
  
  def end_trial
    elapse = Time.now - @time
    # record trial results
    @model.test_data << [@trial, trial_type, elapse, @distance, @error]
    
    @trial += 1
    @cursor_idx = get_cursor_idx
    
    # begin a new trial or end testing
    if @trial < 60
      begin_trial
    else
      end_testing
    end
  end
  
  def trial_type
    type = 'append'  if @trials[@trial] % 3 == 1
    type = 'prepend' if @trials[@trial] % 3 == 2
    type = 'insert'  if @trials[@trial] % 3 == 0
    
    type
  end
  
  def get_cursor_idx
    @text_field.offsetFromPosition(@text_field.beginningOfDocument, toPosition: @text_field.selectedTextRange.start)
  end
  
  def reset_cursor
    new_pos   = @text_field.positionFromPosition(@text_field.beginningOfDocument, offset: @cursor_idx - 1)
    new_range = @text_field.textRangeFromPosition(new_pos, toPosition: new_pos)
    
    @text_field.setSelectedTextRange new_range
  end
  
  def text_change
    # check to see if target was hit
    if (!append_idx.nil? && @text_field.text[append_idx + 1] != ' ' && @text_field.text[append_idx + 1] != '<') ||
       (!prepend_idx.nil? && append_idx.nil? && @text_field.text[prepend_idx - 1] != ' ')
      end_trial
    else
      @error += 1
    end
  end
  
  def append_idx
    @text_field.text.index('>')
  end
  
  def prepend_idx
    @text_field.text.index('<')
  end
  
end
