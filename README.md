Android dialog alert
============

This library was created to be the simpleme meant for ease of implementation. Although some customization is provided. 

## Getting started

To get the best possible results (with some updates over time) I recommend the installation using cocoa pods:

`pod 'AndroidDialogAlert'`

Also, you can download the project and installed it manually.
All required files are inside `Pod/Classes`, just copy and paste them.

## Example

        let alert = DialogAlertView(titleText: "Alert", buttonText: "OK")
        
        alert.messageText = "This is a test message"
        
        alert.textField { (textField, range, string) in
            if string == "s" {
                alert.dialogColor = .red
                return
            }
            alert.dialogColor = .white
        }
        
        alert.buttonCompletion = { (alert) in
            // do some action or validation
            
            alert.dismiss(animated: true, completion: nil)
        }
    
        present(alert, animated: true, completion: nil)
        

#### Simple Alert
![alt text](https://github.com/davamale/AndroidDialogAlert/blob/master/androidAlert_simple.gif)

### Alert with Message
![alt text](https://github.com/davamale/AndroidDialogAlert/blob/master/androidAlert_message.gif)

### Alert with TextField and Cancel Button
![alt text](https://github.com/davamale/AndroidDialogAlert/blob/master/androidAlert_message_textfield_cancel.gif)

## TODO's

- [ ] add show and dismiss custom animations
- [ ] add background blur effect
- [ ] add two textfields support (for login)
- [ ] something on your mind? let me know

## Requirements:

- CocoaPods 1.0.0+
- iOS 9+
