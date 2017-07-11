//
//  DialogAlertView+Constraints.swift
//  AndroidDialogAlert
//
//  Created by Dava on 5/16/17.
//  Copyright © 2017 Davaur. All rights reserved.
//

import UIKit

internal extension AndroidDialogAlert {
    
    //MARK: Constraints
    /// initializes all contraints, excepts the background's view.
    func initializeConstraints() {
        
        background.addSubview(self.dialogView)
        view.addSubview(background)
        
        // add subviews
        dialogView.addSubview(self.button)
        dialogView.addSubview(self.alternateButton)
        dialogView.addSubview(self.titleLabel)
        
        // Dialog View
        let centerYConstraint = dialogView.centerYAnchor.constraint(equalTo: background.centerYAnchor)
        centerYConstraint.priority = 750
        centerYConstraint.isActive = true
        
        let centerXConstraint = dialogView.centerXAnchor.constraint(equalTo: background.centerXAnchor)
        centerXConstraint.isActive = true
        
        let widthContraints = dialogView.widthAnchor.constraint(equalToConstant: DialogFrame.width.value)
        widthContraints.isActive = true
        
        let leadingConstraint = dialogView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: DialogFrame.padding.value)
        leadingConstraint.priority = 999
        leadingConstraint.isActive = true
        
        let trailingConstraint = dialogView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -DialogFrame.padding.value)
        trailingConstraint.priority = 999
        trailingConstraint.isActive = true
        
        // will be activated on keyboard events
        alertBottomCon = dialogView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: DialogFrame.padding.value)
        
        // Title label
        let titleLeadingCon = titleLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: DialogFrame.padding.value)
        titleLeadingCon.isActive = true
        
        let titleTrailingCon = titleLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -DialogFrame.padding.value)
        titleTrailingCon.isActive = true
        
        let titleHeightCon = titleLabel.heightAnchor.constraint(lessThanOrEqualToConstant: DialogFrame.height.value)
        titleHeightCon.isActive = true
        
        let titleTopCon = titleLabel.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: DialogFrame.padding.value)
        titleTopCon.isActive = true
        
        // only applies when there only the title label.
        let titleBottomCon = titleLabel.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -50)
        titleBottomCon.priority = 250
        titleBottomCon.isActive = true
        
        
        // Button
        let buttonTrailingCon = button.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -ButtonFrame.padding.value)
        buttonTrailingCon.isActive = true
        
        let buttonHeightCon = button.heightAnchor.constraint(equalToConstant: ButtonFrame.height.value)
        buttonHeightCon.isActive = true
        
        let buttonWidthCon = button.widthAnchor.constraint(lessThanOrEqualToConstant: ButtonFrame.width.value)
        buttonWidthCon.isActive = true
        
        let buttonBottomCon = button.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -ButtonFrame.padding.value)
        buttonBottomCon.isActive = true
        
        
        // Alternate button
        let aButtonTrailingCon = alternateButton.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -ButtonFrame.padding.value)
        aButtonTrailingCon.isActive = true
        
        let aButtonHeightCon = alternateButton.heightAnchor.constraint(equalToConstant: ButtonFrame.height.value)
        aButtonHeightCon.isActive = true
        
        let aButtonWidthCon = alternateButton.widthAnchor.constraint(lessThanOrEqualToConstant: ButtonFrame.width.value)
        aButtonWidthCon.isActive = true
        
        let aButtonBottomCon = alternateButton.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -ButtonFrame.padding.value)
        aButtonBottomCon.isActive = true
    }
    
    /// Adds message label constraints. Message Label is optional.
    func addMessageLabelConstaints() {
        
        dialogView.addSubview(messageLabel)
        
        // constraints
        let messageLeadingCon = messageLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: DialogFrame.padding.value)
        messageLeadingCon.isActive = true
        
        let messageTrailingCon = messageLabel.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -DialogFrame.padding.value)
        messageTrailingCon.isActive = true
        
        let messageTopCon = messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
        messageTopCon.isActive = true
        
        let messageButtonCon = messageLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -DialogFrame.padding.value)
        
        //  in case defaultTextField is visible
        messageButtonCon.priority = 750
        messageButtonCon.isActive = true
        
        let messageHeightCon = messageLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 100)
        messageHeightCon.isActive = true
        
        if _isTextFieldAvailable {
            let txtTopMessageCon = textField!.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8)
            txtTopMessageCon.isActive = true
        }
        
        dialogView.setNeedsDisplay()
    }
    
    func enableKeyboardContraint(keyboardHeight: CGFloat) {
        
        self.alertBottomCon?.constant = -(DialogFrame.padding.value + keyboardHeight)
        self.alertBottomCon?.isActive = true
        
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion:nil)
        

    }
    
    func disableKeyboardContraint() {
        
        self.alertBottomCon?.isActive = false
        
        UIView.animate(withDuration: 0.7, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion:nil)
    }
    
    /// Adds textfield constraints. Textfield is optional.
    func addTextfieldConstraints() {
        
        guard let textField = textField else  {
            return
        }
        
        let txtLeadingCon = textField.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: DialogFrame.padding.value)
        txtLeadingCon.isActive = true
        
        let txtTrailingCon = textField.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -DialogFrame.padding.value)
        txtTrailingCon.isActive = true
        
        let txtTopTitleCon = textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8)
        
        // if message label is visible, this should be broken
        txtTopTitleCon.priority = 250
        txtTopTitleCon.isActive = true
        
        if let _ = messageText {
            let txtTopMessageCon = textField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 8)
            txtTopMessageCon.isActive = true
        }
        
        let txtButtonCon = textField.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -DialogFrame.padding.value)
        txtButtonCon.isActive = true
        
        let txtHeightCon = textField.heightAnchor.constraint(equalToConstant: 20)
        txtHeightCon.isActive = true
        
        dialogView.setNeedsDisplay()
    }
    
    /// Adds backgorund constraints related to the view.
    ///
    /// - Parameter view: super to add dialog.
    func addBackgroundContraints(inView view: UIView) {
        
        // Background View
        background.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        background.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        background.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        background.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
}
