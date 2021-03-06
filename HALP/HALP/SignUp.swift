//
//  SignupViewController.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/13/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate{

    // UI components
    let logoImageView: UIImageView = {
        let image = UIImage(named: "logo")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    let halpLabel:UILabel = {
        let label = UILabel()
        let descriptionStr:String = "HALP"
        let attributedTitle = NSMutableAttributedString(string: descriptionStr, attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor : UIColor.black.withAlphaComponent(0.8) ])
        label.attributedText = attributedTitle
        label.textAlignment = .center
        return label
    }()
    
    let signUpDescriptionLabel:UILabel = {
        let label = UILabel()
        let descriptionStr:String = "New account"
        let attributedTitle = NSMutableAttributedString(string: descriptionStr, attributes: [ NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 24), NSAttributedStringKey.foregroundColor : UIColor.lightGray ])
        label.attributedText = attributedTitle
        label.textAlignment = .center
        return label
    }()
    
    let userNameTextField:LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Nickname", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.tag = 0
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let emailTextField:LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.tag = 1
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField:LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        //        textField.placeholder = "Password"
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.tag = 2
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let passwordConfirmTextField:LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        //        textField.placeholder = "Password"
        textField.attributedPlaceholder = NSAttributedString(string: "Re-enter your password", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.tag = 2
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    var hidePasswordButton:UIButton = {
        
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "hide").withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(#imageLiteral(resourceName: "visible").withRenderingMode(.alwaysTemplate), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        let buttonWidth:CGFloat = 26.5
        let buttonHeight:CGFloat = 37
        let buttonVerticalMargin:CGFloat = 9
        let buttonHorizontalMargin:CGFloat = 8
        button.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight)
        button.imageEdgeInsets = UIEdgeInsets(top: buttonVerticalMargin, left: 0, bottom: buttonVerticalMargin, right: buttonHorizontalMargin)
        
        button.tintColor = .black//colorTheme
        button.addTarget(self, action: #selector(hidePasswordButtonHandler), for: .touchUpInside)
        
        return button
    }()
    
    let signUpButton:UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = colorTheme
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.alpha = 0.4
        button.addTarget(self, action: #selector(signUpActionHandler), for: .touchUpInside)
        
        return button
    }()
    
    let verticalStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .red
        stackView.spacing = 10
        return stackView
    }()
    
    let backToLoginButton:UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Have an account? ", attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray ])
        attributedTitle.append(NSAttributedString(string: "Log in.", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : colorTheme]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(backToLoginButtonActionHandler), for: .touchUpInside)
        
        return button
    }()
    
    let lineView:UIView = {
        let lineView = UIView()
        lineView.layer.borderWidth = 1
        lineView.layer.borderColor = UIColor.rgbColor(220, 220, 220).cgColor
        return lineView
    }()
    
    // End of UI components
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		self.view.backgroundColor = UIColor.HalpColors.lessLightGray
        self.navigationController?.isNavigationBarHidden = true
        setUpSubViewsLayout()
        setUpSubViewsLayout()
        observeKeyboardNotifications()
        userNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordConfirmTextField.delegate = self
    }

    @objc func backToLoginButtonActionHandler()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTextInputChange()
    {
        let isFormValid = (userNameTextField.text?.count ?? 0) > 0 && (emailTextField.text?.count ?? 0) > 0 && (passwordTextField.text?.count ?? 0) > 0 && (passwordConfirmTextField.text?.count ?? 0) > 0
        if isFormValid
        {
            signUpButton.isEnabled = true
            signUpButton.alpha = 1
        } else
        {
            signUpButton.isEnabled = false
            signUpButton.alpha = 0.4
        }
    }
    
    
    @objc func signUpActionHandler()
    {
        //TODO: after signup button touched
        
        guard let username = userNameTextField.text, let password = passwordTextField.text, let email = emailTextField.text,
              let confirmPassword = passwordConfirmTextField.text
            else { return }
        
        let form = UserForm(username: username, password: password, email: email)
        
        if !form.confirmPassword(password: confirmPassword) {
            let alert = UIAlertController(title: "Passwords do not match", message: "Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if !form.validatePassword() {
            let alert = UIAlertController(title: "Illegal password!", message: "Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if !form.validateUsername() {
            let alert = UIAlertController(title: "Illegal usernmae!", message: "Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        if !form.validateEmail() {
            let alert = UIAlertController(title: "Illegal email!", message: "Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // write to local database
        let _DAO = UserDAO(username: form.getUsername(), password: form.getPassword(), email: form.getUserEmail(), id: form.getUserID())
        let defaultSetting = SettingForm(userId: _DAO.getUserID())
        let defaultSettingDAO = SettingDAO(defaultSetting)
        
        // check databse for duplicate email address
        
        _DAO.validateUserEmail(email: form.getUserEmail(), flag: { (uniqueEmail) in
            if uniqueEmail {
                if(!_DAO.saveUserInfoToLocalDB()) {
                    let alert = UIAlertController(title: "Unexpected Error :(", message: "Cannnot establish database connection", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
                else {
                    _ = defaultSettingDAO.saveSettingIntoLocalDB()
                    let alert = UIAlertController(title: "Success!", message: "You can now sign in with your account", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {(action) -> Void in
                        
                        let startupVC:StartupViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartupViewController") as! StartupViewController
                        self.navigationController?.pushViewController(startupVC, animated: true)
                        
                    }))
                    
                    syncDatabase(userId: form.getUserID(), completion: {(flag) in
                        if flag {
                        }
                    })
                    
                    self.present(alert, animated: true)
                }
            }
            else {
                let alert = UIAlertController(title: "Email already taken!", message: "Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        })
    }

    fileprivate func setUpSubViewsLayout()
    {
        verticalStackView.addArrangedSubViews([userNameTextField, emailTextField, passwordTextField, passwordConfirmTextField, signUpButton ])
        view.addSubviews([logoImageView, signUpDescriptionLabel, halpLabel, verticalStackView, lineView, backToLoginButton])
        
        backToLoginButton.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: view.frame.width, height: 45, centerX: nil, centerY: nil)
        
        lineView.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: self.backToLoginButton.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: view.frame.width, height: 1, centerX: nil, centerY: nil)
        
        verticalStackView.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: self.lineView.topAnchor, topConstant: 20, leftConstant: 10, rightConstant: 10, bottomConstant: view.frame.height/5, width: view.frame.width-20, height: view.frame.height/4 + 40, centerX: view.centerXAnchor, centerY: nil)
        
        signUpDescriptionLabel.anchor(top: nil, left: nil, right: nil, bottom: self.verticalStackView.topAnchor, topConstant:0, leftConstant: 10, rightConstant: 10, bottomConstant: 10, width: view.frame.width-20, height: 30, centerX: view.centerXAnchor, centerY: nil)
        
        halpLabel.anchor(top: nil, left: nil, right: nil, bottom: signUpDescriptionLabel.topAnchor, topConstant: 0, leftConstant: 10, rightConstant: 10, bottomConstant: 0, width: view.frame.width-20, height: 30, centerX: view.centerXAnchor, centerY: nil)
    
        logoImageView.anchor(top: nil, left: nil, right: nil, bottom: self.halpLabel.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: view.frame.width/3, height: view.frame.width/3, centerX: view.centerXAnchor, centerY: nil)
        
        passwordTextField.rightView = hidePasswordButton
        passwordTextField.rightViewMode = .whileEditing
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -150 : -80
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    @objc func hidePasswordButtonHandler()
    {
        hidePasswordButton.isSelected = !hidePasswordButton.isSelected
        if hidePasswordButton.isSelected
        {
            passwordTextField.isSecureTextEntry = false
            
        }else
        {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch(textField.tag)
        {
        case 0:
            emailTextField.becomeFirstResponder()
        case 1:
            passwordTextField.becomeFirstResponder()
        case 2:
            passwordTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
}
