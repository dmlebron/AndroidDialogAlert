//
//  DialogView.swift
//  ATH Movil
//
//  Created by David Martinez on 5/4/17.
//  Copyright © 2017 EVERTEC, Inc. All rights reserved.
//

import UIKit

/// Private constants fro the dialog frame
internal enum DialogFrame: CGFloat, EnumProtocol {
    
    typealias T = CGFloat
    
    case width = 300.0
    case height = 100.0
    case padding = 16.0
    case cornerRadious = 3.0
    case borderWidth = 0.5
}

/// Private constants fro the button frame
internal enum ButtonFrame: CGFloat, EnumProtocol {
    
    typealias T = CGFloat
    
    case width = 100
    case height = 30
    case padding = 16
}

public protocol Subview {
    var layer: CALayer {get set}
    var translatesAutoresizingMaskIntoConstraints: Bool { get set }
}

extension Subview where Self: UIView {
    
}


public typealias ButtonCompletion = (AndroidDialogAlert) -> ()

public typealias TextFieldDelegateClosure = (_ textField: UITextField, _ range: NSRange, _ replacementString: String) -> ()

public class AndroidDialogAlert: UIViewController {
    
    private var defaultDialogBorderColor: UIColor {
        return UIColor.groupTableViewBackground
    }
    
    /// Background View. REQUIRED
    internal lazy var background: UIView = {
        
        let bkg = UIView()
        
        bkg.translatesAutoresizingMaskIntoConstraints = false
        bkg.frame = self.view.frame
        
        return bkg
    }()
    
    /// Dialog container view that contains all subcontrollers
    internal lazy var dialogView: UIView = {
        
        let dv = UIView(frame: .zero)
        
        dv.backgroundColor = .white
        dv.translatesAutoresizingMaskIntoConstraints = false
        
        dv.layer.cornerRadius = DialogFrame.cornerRadious.value
        dv.layer.borderWidth = DialogFrame.borderWidth.value
        dv.layer.borderColor = self.defaultDialogBorderColor.cgColor
        dv.layer.shadowOffset = CGSize(width:0, height:12);
        dv.layer.shadowRadius = 5;
        dv.layer.shadowOpacity = 0.5;
        
        return dv
    }()
    
    // background blur effect. Should be optional
    //TODO: change to optional
    internal var blurEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: blur)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        
        return effectView
    }()
    
    /// Usually the 'OK' button. It always appear on the right side of the dialog. REQUIRED
    internal lazy var button: UIButton = {
        
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.italicSystemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        return btn
    }()
    
    /// Usually the 'Cancel' button. It always appear on the 'center' side of the dialog.
    internal lazy var alternateButton: UIButton = {
        
        let aBtn = UIButton()
        
        aBtn.setTitleColor(.red, for: .normal)
        aBtn.translatesAutoresizingMaskIntoConstraints = false
        aBtn.setTitleColor(.black, for: .normal)
        aBtn.titleLabel?.font = UIFont.italicSystemFont(ofSize: 16)
        aBtn.addTarget(self, action: #selector(alternateButtonPressed), for: .touchUpInside)
        
        return aBtn
    }()
    
    /// Input text field
    fileprivate lazy var defaultTextField: UITextField = {
        
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        
        txtField.delegate = self
        
        return txtField
    }()
    
    /// This is the textfield used. If no textfield is set, the defaultTextField will be used.
    internal var textField: UITextField? {
        didSet {
            self.textField?.translatesAutoresizingMaskIntoConstraints = false
            self.dialogView.addSubview(self.textField!)
            
            self.addTextfieldConstraints()
            
            //FIXME:
            self.background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        }
    }
    
    /// Title label. Up to lines or a height of 100.
    internal var titleLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    /// Message label. Up to lines or a height of 100.
    internal lazy var messageLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.italicSystemFont(ofSize: 15)
        
        return label
    }()
    
    /// Alternate button text
    private var alternateButtonText: String? {
        get {
            return self.alternateButtonText
        }
        set {
            self.alternateButton.setTitle(newValue, for: .normal)
        }
    }
    
    /// Button text
    public var buttonText: String! {
        get {
            return self.buttonText
        }
        set {
            self.button.setTitle(newValue, for: .normal)
        }
    }
    
    /// The text that will be presented on the title label. Not accessible by the view controller.
    private var titleText: String?  {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    
    /// The text that will be presented on the message label. Can be changed dynamically from the view controller.
    public var messageText: String? {
        get {
            return messageLabel.text
        }
        set {
            messageLabel.text = newValue
            self.addMessageLabelConstaints()
        }
    }
    
    /// Alternate button text
    public var alternateButtonTitle: String? {
        get {
            return self.alternateButtonTitle
        }
        set {
            alternateButton.setTitle(newValue, for: .normal)
        }
    }
    
    /// Dialog corner radious
    public var cornerRadius: CGFloat {
        get {
            return self.dialogView.layer.cornerRadius
        }
        set {
            self.dialogView.layer.cornerRadius = newValue
        }
    }
    
    internal var _isTextFieldAvailable: Bool = false
    
    public var isTextFieldAvailable: Bool {
        return _isTextFieldAvailable
    }
    
    public var textFieldClosure: TextFieldDelegateClosure?
    
    public var isBlurEffectOn: Bool! = true {
        willSet {
            if !newValue {
                self.manageBlurEffect()
            }
        }
    }
    
    /// DialogView background color
    public var dialogColor: UIColor? {
        willSet {
            if let newValue = newValue {
                dialogView.backgroundColor = newValue
            }
        }
    }
    
    public var dialogBorderColor: UIColor? {
        willSet {
            dialogView.layer.borderColor = newValue?.cgColor
        }
    }
    
    /// Detault button title color
    public var buttonColor: UIColor? {
        willSet {
            button.setTitleColor(newValue, for: .normal)
        }
    }
    
    /// Alternate button title color
    public var alternateButtonColor: UIColor? {
        willSet {
            alternateButton.setTitleColor(newValue, for: .normal)
        }
    }
    
    /// Action of the default button. If action is nil, `dismiss()` will be called.
    public var buttonCompletion: ButtonCompletion?
    
    /// Action of the alternate button.
    fileprivate var alternateButtonCompletion: ButtonCompletion?
    
    //TODO: Add keyboard constraints property
    public var alertBottomCon: NSLayoutConstraint?
    
    //MARK: Initializers
    public init(titleText: String, buttonText: String) {
        super.init(nibName: nil, bundle: nil)
        
        defaultCustomization()
        
        self.titleText = titleText
        self.buttonText = buttonText
        
        initializeView()
    }
    
    public convenience init(titleText: String, messageText: String, buttonText: String) {
        self.init(titleText: titleText, buttonText: buttonText)
        self.messageText = messageText
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // TODO: Add keyboard listener and contraints
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // adds show/hide keyboard events notifications
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // removes all keyboard events notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let textField = textField, textField == defaultTextField else {
            return
        }
        
        textField.addBottomLine()
    }
    
    //MARK: - Actions
    
    /// Button action.
    ///
    /// - Parameter sender: UIButton
    @objc internal func buttonPressed(sender: UIButton) {
        
        // if there is no handler, dismiss will be called
        guard let buttonCompletion = buttonCompletion else {
            return dismiss(animated: true, completion: nil)
        }
        
        buttonCompletion(self)
    }
    
    
    /// Alternate button action.
    ///
    /// - Parameter sender: UIButton
    @objc internal func alternateButtonPressed(sender: UIButton) {
        
        // if there is no handler, dismiss will be called
        guard let alternateButtonCompletion = alternateButtonCompletion else {
            return dismiss(animated: true, completion: nil)
        }
        
        alternateButtonCompletion(self)
    }
    
    @objc internal func hideKeyboard() {
        textField?.resignFirstResponder()
    }
    
    //MARK: - Keyboard Handlers
    @objc private func handleKeyboardShow(notification: NSNotification) {
        if let keyboardDictionary = notification.userInfo as NSDictionary?, let keyboardFrame = keyboardDictionary[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            enableKeyboardContraint(keyboardHeight: keyboardFrame.size.height)
        }
        
    }
    
    @objc private func handleKeyboardHide(notification: NSNotification) {
        disableKeyboardContraint()
    }
    
}

// MARK: - Private Methods
private extension AndroidDialogAlert {
    
    /// Initializes the view controller with some required default parameters
    func defaultCustomization() {
        modalPresentationStyle = .custom
    }
    
    func initializeView() {
        
        initializeConstraints()
        
        addBackgroundContraints(inView: view)
//        manageBlurEffect()
        
        // show with textfield if required
        if _isTextFieldAvailable {
            addTextfieldConstraints()
        }
    }
    
    // MARK: View Effects
    
    /// Adds blur effect to the background view. Should be optinal.
    func manageBlurEffect() {
        
        guard isBlurEffectOn else {
            return
        }
        
        background.insertSubview(self.blurEffectView, belowSubview: dialogView)
        
        blurEffectView.topAnchor.constraint(equalTo: background.topAnchor, constant: 0).isActive = true
        blurEffectView.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 0).isActive = true
        blurEffectView.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: 0).isActive = true
        blurEffectView.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: 0).isActive = true
    }
    
    //TODO: Add shake animation
}

// MARK: - UITextField Delegate
extension AndroidDialogAlert: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textFieldClosure?(textField, range, string)
        return true
    }
}

// MARK: - Public Methods
public extension AndroidDialogAlert {
    
    /// Initializes and adds the alternate button.
    ///
    /// - Parameters:
    ///   - title: String title for the button
    ///   - completion: completion to be handled by the caller
    func alternateButton(title: String, withCompletion completion: @escaping ButtonCompletion) {
        alternateButtonTitle = title
        alternateButtonCompletion = completion
    }
    
    /// Initialize the defeault textfield and starts listening to the textfield delegates
    ///
    /// - Parameter textTield: textfield actions
    func textField(withClosure textTield: @escaping TextFieldDelegateClosure) {
        
        self.textFieldClosure = textTield
        _isTextFieldAvailable = true
        textField = defaultTextField
        
        addTextfieldConstraints()
    }
    
    /// Assign the arg textField to the dialog view textfield. The caller must have already declare all delegates in case delegate methods are intended to be used.
    ///
    /// - Warning: This method shouldn't be used along with:
    ///
    /// `func textField(withClosure firstTextField: @escaping TextFieldDelegateClosure)`
    ///
    /// - Parameter textField: textfield to be used if specific customization is intended.
    func setCustom(textField: UITextField) {
        
        if self.textField == nil {
            self.textField = textField
            _isTextFieldAvailable = true
        }
        
    }
    
}














