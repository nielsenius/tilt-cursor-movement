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
    
    @model = MainModel.new
    
    load_text_field
    load_accelerometer
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
