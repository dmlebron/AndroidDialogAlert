//
//  ViewController.swift
//  AndroidDialogAlert
//
//  Created by Dava on 5/15/17.
//  Copyright © 2017 Davaur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let dialog = DialogAlertView(titleText: "test", buttonText: "OK")
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show Alert", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(showDialog), for: .touchUpInside)
        
        view.addSubview(button)
        
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
    @objc fileprivate func showDialog() {
        
        dialog.buttonCompletion = { (dialog) in
            dialog.dismiss(animated: true, completion: nil)
        }
        
        dialog.alternateButton(title: "Cancel") { (dialog) in
            dialog.dismiss(animated: true, completion: nil)
        }
        
//        dialog.textField { (textField, range, string) in
//            dialog.messageText = "\(textField.text!)\(string)"
//        }
        
        let textField = UITextField()
        textField.text = "WHAT?!?!?"
        textField.delegate = self
        
        dialog.setCustom(textField: textField)
        
        dialog.isBlurEffectOn = true
        
        present(dialog, animated: true, completion: nil)
    }

    
}


extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        dialog.messageText = "\(textField.text!)\(string)"
        return true
    }
}



