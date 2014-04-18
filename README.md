# Tilt Device to Move Cursor

Final project for 05-499 Interaction Techniques

## Interaction Technique

Definition paraphrased from Wikipedia: An interaction technique is a combination of hardware and software elements that provides a way for computer users to accomplish a single task.

This project's goal is to introduce a new interaction technique for smartphone, tablet, and other mobile device text entry. One of the greatest challenges when entering text on mobile devices is manual movement of the cursor. Few mobile keyboards offer dedicated arrow keys, so a finger must be used to make cursor position changes; this can be slow. We propose that the cursor could be moved to new positions by tilting the device at an angle. The cursor's movement correlates to the angle.

## Technology

The programming language used to implement this prototype is RubyMotion: a propriety toolchain that combines the Ruby language with Objective-C classes and methods allowing for the easy development of iOS applications.

### Useful Links

* RubyMotion Getting Started: http://www.rubymotion.com/developer-center/guides/getting-started/
* RubyMotion Tutorials: http://rubymotion-tutorial.com/0-in-motion/
* Objective-C API Library: https://developer.apple.com/library/ios/navigation/

### Basic Info

* RubyMotion is a combination of Ruby and Obj-C. It is compiled in the form of an iOS app. This technology is proprietary and costs money to own.
* Rails developers will feel relatively at home with RubyMotion. All commands are run through the terminal. `rake` and `motion` are the commands used to complete most tasks.
* RubyMotion apps are fully App Store complient (assuming the developer has followed the proper guidelines).
* When reading RubyMotion code, you will notice both snake\_case and camelCase being used. Snake\_case is used on the Ruby side and camelCase is from the Obj-C side.

## Contributors

* Folashade Okunubi
* Hayden Demerson
* Matt Nielsen

### Bugs / Needs Work

* MVC style may not be 100% right now. Efforts will be made to keep the logic in the model, the displays in the view, and the interactions in the controller.
* Cursor movement is much better, but not perfect.
* Algorithm for ideal distance works, but is often off by a small amount.
