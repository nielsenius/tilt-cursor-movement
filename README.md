# Tilt Device to Move Cursor

Final project for 05-499 - Interaction Techniques

## Interaction Technique

Definition paraphrased from Wikipedia: An interaction technique is a combination of hardware and software elements that provides a way for computer users to accomplish a single task.

This project's goal is to introduce a new interaction technique for text entry on smartphones, tablets, and other mobile devices. One of the greatest challenges when entering text on mobile devices is manual movement of the cursor. Few mobile keyboards offer dedicated arrow keys, so a finger must be used to make cursor position changes; this can be slow and inaccurate. We propose that the cursor could be moved to new positions within the text field by using the device's degree of tilt as input. The cursor's movement correlates to the degree of tilt of the device.

## Technology

The programming language used to implement this prototype is RubyMotion: a propriety toolchain that combines the Ruby language with Apple's Objective-C, allowing for easy development of iOS applications.

### Useful Links

* RubyMotion Getting Started: http://www.rubymotion.com/developer-center/guides/getting-started/
* RubyMotion Tutorials: http://rubymotion-tutorial.com/0-in-motion/
* Objective-C API Library: https://developer.apple.com/library/ios/navigation/

### Basic Info

* RubyMotion is a combination of Ruby and Obj-C. It is compiled in the form of an iOS app.
* Rails developers will feel relatively at home with RubyMotion. All commands are run through the terminal. `rake` and `motion` are the commands used to complete most tasks.
* RubyMotion apps are fully App Store complient (assuming the developer has followed the proper guidelines).
* When reading RubyMotion code, you will notice both snake\_case and camelCase being used. Snake\_case is used on the Ruby side and camelCase is from the Obj-C side.

## Project Status

Development of Tilter has ceased.

### Bugs / Needs Work

* MVC style may not be at 100%.
* Cursor movement rate is not perfect.
* Algorithm for ideal distance from cursor to target works, but is often off by a small amount.
* Rate controlled cursor movement would be a nice addition (instead of two speeds).
* An acceloration curve would make movement feel more natural.

## Contributors

* Folashade Okunubi
* Hayden Demerson
* Matt Nielsen
