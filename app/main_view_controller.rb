class MainViewController < UIViewController
  
  #
  # initialize constants
  #
  
  
  
  #
  # launch sequence
  #
  
  # def iphone_4_inch?
  #   UIScreen.mainScreen.bounds.size.height == 568.0
  # end
  
  def loadView
    # if iphone_4_inch?
    #   views = NSBundle.mainBundle.loadNibNamed 'MainView', owner: self, options: nil
    # else
    #   views = NSBundle.mainBundle.loadNibNamed 'MainViewShort', owner: self, options: nil
    # end
    views = NSBundle.mainBundle.loadNibNamed 'MainView', owner: self, options: nil
    self.view = views.first
  end

  def viewDidLoad
    super
    
    @model   = MainModel.new
    @testing = false
    @trial   = 1
    @time    = nil
    @error   = 0
    
    load_text_field
    load_trial_label
    load_test_button
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
  
  def load_trial_label
    @trial_label = self.view.viewWithTag 2
    @trial_label.setHidden(true)
  end
  
  def load_test_button
    @test_button = self.view.viewWithTag 3
    @test_button.addTarget(self, action: 'button_press:', forControlEvents: UIControlEventTouchDown)
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
    @model.update_movements(rotation_rate)
    move_cursor(@model.cursor_direction) if @model.should_move_cursor?      
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
  
  def button_press(sender)
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
  
  # def begin_testing
  #   count = 1
  #   60.times do
  #     begin_trial(count)
  #     count += 1
  #   end
  #   end_testing
  # end
  
  def end_testing
    puts @model.test_data
    
    @text_field.setText(@model.format_data)
  end
  
  def begin_trial
    # type = :append  if count % 3 == 1
    # type = :prepend if count % 3 == 2
    # type = :insert  if count % 3 == 3
    
    @text_field.setText(@model.generate_text(@trial))
    
    @error = 0
    @time = Time.now
  end
  
  def end_trial
    elapse = Time.now - @time
    
    @model.test_data << [@trial, elapse, @error]
    @trial += 1
    if @trial <= 60
      begin_trial
    else
      end_testing
    end
  end
  
  def text_change
    append_idx = @text_field.text.index('>')
    prepend_idx = @text_field.text.index('<')
    
    if (!append_idx.nil? && @text_field.text[append_idx + 1] != ' ' && @text_field.text[append_idx + 1] != '<') ||
       (!prepend_idx.nil? && append_idx.nil? && @text_field.text[prepend_idx - 1] != ' ')
      end_trial
    else
      @error += 1
    end
  end
  
  # def show_alert
  #   alert = UIAlertView.alloc.initWithTitle('Welcome',
  #                                           message: 'Enter your bill using the keypad. See Settings for options.',
  #                                           delegate: nil,
  #                                           cancelButtonTitle: 'OK',
  #                                           otherButtonTitles: nil)
  #   alert.show
  # end
  # 
  # def open_review_view
  #   msg = 'It looks like you have been using CheckMate quite a bit. Would you like to review it on the App Store?'
  #   alert = UIAlertView.alloc.initWithTitle('Review CheckMate',
  #                                           message: msg,
  #                                           delegate: self,
  #                                           cancelButtonTitle: 'No',
  #                                           otherButtonTitles: nil)
  #   alert.addButtonWithTitle('Yes')
  #   alert.show
  # end
  # 
  # def alertView(alertView, clickedButtonAtIndex: buttonIndex)
  #   if buttonIndex == 1
  #     str = "http://itunes.apple.com/app/id782864867"
  #     UIApplication.sharedApplication.openURL(NSURL.URLWithString(str))
  #   end
  # end
  
end
