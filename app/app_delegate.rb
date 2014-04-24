class AppDelegate
  
  def application(application, didFinishLaunchingWithOptions: launchOptions)  
    # get the frame for the window
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    # instantiate a new object of the MainViewController
    # and assign it as the root controller.
    @window.rootViewController = MainViewController.new

    # this makes the window a receiver of events
    @window.makeKeyAndVisible
    
    # because this method must return true
    true
  end
  
end
