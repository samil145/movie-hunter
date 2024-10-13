//
//  RegisterController.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 17.09.24.
//

import UIKit

class RegisterController: UIViewController {
    
    private let headerView = AuthHeaderView(title: "Movie Hunter", subTitle: "Create your account.")
    
    private let usernameField = AuthTextField(fieldType: .username)
    private let emailField = AuthTextField(fieldType: .email)
    private let passwordField = AuthTextField(fieldType: .password)
    
    private let signUpButton = AuthButton(title: "Sign Up", hasBackground: true, fontSize: .big)
    private let signInButton = AuthButton(title: "Already have an account? Sign In.", fontSize: .med)
    
    private var emailFieldTopConstraint: NSLayoutConstraint?
    private var passwordFieldTopConstraint: NSLayoutConstraint?
    private var signUpButtonTopConstraint: NSLayoutConstraint?
    
    private var hasValidationError = false
    {
        didSet
        {
            view.addSubview(usernameErrorLabel)
            view.addSubview(emailErrorLabel)
            view.addSubview(passwordErrorLabel)
            
            usernameErrorLabel.isHidden = false
            emailErrorLabel.isHidden = false
            passwordErrorLabel.isHidden = false
            configureErrorConstraints()
        }
    }
    
    private var usernameErrorLabel  = UILabel()
    private var emailErrorLabel     = UILabel()
    private var passwordErrorLabel  = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.setupUI()
        
        self.signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        self.signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        usernameErrorLabel = createAuthLabels(text: "Username must be 4-24 characters and can include letters, numbers, and underscores.")
        emailErrorLabel = createAuthLabels(text: "Please enter a valid email address.")
        passwordErrorLabel = createAuthLabels(text: "Password must be minimum 6 characters, with at least one uppercase letter (A-Z), one number (0-9).")
        
        usernameField.delegate = self
        usernameField.tag = 0
        
        emailField.delegate = self
        emailField.tag = 1
        
        passwordField.delegate = self
        passwordField.tag = 2
        
        createDismissKeyboardTapGesture()
    }
    
    func createDismissKeyboardTapGesture()
    {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func setupUI()
    {
        self.view.addSubview(headerView)
        
        // Text Fields
        self.view.addSubview(usernameField)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        
        // Buttons
        self.view.addSubview(signUpButton)
        self.view.addSubview(signInButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Text Fields
        usernameField.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        
        // Buttons
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        configureConstraints()
    }
    
    func createAuthLabels(text: String) -> UILabel
    {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .red
        label.textAlignment = .left
        label.text = text
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }
    
    
    // Selectors
    @objc private func didTapSignUp()
    {
        let registerUserRequest = RegisterUserRequest(username: self.usernameField.text ?? "",
                                                      email: self.emailField.text ?? "",
                                                      password: self.passwordField.text ?? "")
        
        if !Validator.isValidUsername(for: registerUserRequest.username)
        {
            if !hasValidationError
            {
                hasValidationError = true
            }
            return
        }
        
        if !Validator.isValidEmail(for: registerUserRequest.email)
        {
            if !hasValidationError
            {
                hasValidationError = true
            }
            return
        }
        
        if !Validator.isValidPassword(for: registerUserRequest.password)
        {
            if !hasValidationError
            {
                hasValidationError = true
            }
            return
        }
        
        showLoadingView()
        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            if error != nil
            {
                presentMHAlertOnMainThread(title: "Registration Error", message: "Registration failed. Please try again.", buttonTitle: "Ok")
                return
            }
            
            if wasRegistered
            {
                if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
                {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        sceneDelegate.checkAuth()
                        self.dismissLoadingView()
                    }
                }
            }
            else
            {
                presentMHAlertOnMainThread(title: "Something Went Wrong", message: "Registration failed. Please try again.", buttonTitle: "Ok")
            }
        }
        
    }
    
    @objc private func didTapSignIn()
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func configureConstraints()
    {
        emailFieldTopConstraint = emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 15)
        passwordFieldTopConstraint = passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 15)
        signUpButtonTopConstraint = signUpButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22)
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.heightAnchor.constraint(equalToConstant: 270),
            
            self.usernameField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.usernameField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.usernameField.heightAnchor.constraint(equalToConstant: 55),
            self.usernameField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            emailFieldTopConstraint!,
            self.emailField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            passwordFieldTopConstraint!,
            self.passwordField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            signUpButtonTopConstraint!,
            self.signUpButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 55),
            self.signUpButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 1),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 55),
            self.signInButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    private func configureErrorConstraints()
    {
        
        NSLayoutConstraint.deactivate([
            emailFieldTopConstraint!,
            passwordFieldTopConstraint!,
            signUpButtonTopConstraint!
        ])
        
        
        emailFieldTopConstraint = emailField.topAnchor.constraint(equalTo: usernameErrorLabel.bottomAnchor, constant: 10)
        passwordFieldTopConstraint = passwordField.topAnchor.constraint(equalTo: emailErrorLabel.bottomAnchor, constant: 10)
        signUpButtonTopConstraint = signUpButton.topAnchor.constraint(equalTo: passwordErrorLabel.bottomAnchor, constant: 22)
        
        
        NSLayoutConstraint.activate([
            usernameErrorLabel.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            usernameErrorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            usernameErrorLabel.heightAnchor.constraint(equalToConstant: 45),
            usernameErrorLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            
            emailFieldTopConstraint!,
            
            emailErrorLabel.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 10),
            emailErrorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            emailErrorLabel.heightAnchor.constraint(equalToConstant: 30),
            emailErrorLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            
            passwordFieldTopConstraint!,
            
            passwordErrorLabel.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 10),
            passwordErrorLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            passwordErrorLabel.heightAnchor.constraint(equalToConstant: 30),
            passwordErrorLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8),
            
            signUpButtonTopConstraint!
        ])
        
        view.updateConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if hasValidationError
        {
            usernameErrorLabel.sizeToFit()
            passwordErrorLabel.sizeToFit()
            emailErrorLabel.sizeToFit()
        }

    }
}

extension RegisterController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
           nextField.becomeFirstResponder()
        } else {
           textField.resignFirstResponder()
            didTapSignUp()
        }

        return false
    }
}
