//
//  ForgotPasswordController.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 17.09.24.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
    private let headerView = AuthHeaderView(title: "Forgot Password?", subTitle: "Reset your password")
    
    private let emailField = AuthTextField(fieldType: .email)
    
    private let resetPasswordButton = AuthButton(title: "Reset Password", hasBackground: true, fontSize: .med)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.setupUI()
        
        self.resetPasswordButton.addTarget(self, action: #selector(didTapResetPassword), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .systemGreen
        emailField.delegate = self
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
        self.view.addSubview(emailField)
        
        // Buttons
        self.view.addSubview(resetPasswordButton)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 1),
            emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 55),
            emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            resetPasswordButton.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            resetPasswordButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: 55),
            resetPasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
        ])
    }
    
    @objc private func didTapResetPassword()
    {
        let email = self.emailField.text ?? ""
        
        if !Validator.isValidEmail(for: email)
        {
            presentMHAlertOnMainThread(title: "Invalid Email", message: "Email is not valid. Please try again.", buttonTitle: "Ok")
            return
        }
        
        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            guard let self = self else { return }
            if error != nil
            {
                presentMHAlertOnMainThread(title: "Password Reset Error", message: "Error occured during reset password. Please try again.", buttonTitle: "Ok")
                return
            }
            
            presentMHAlertOnMainThread(title: "Password Reset Sent", message: "Please check your email for resetting password.", buttonTitle: "Ok")
        }
        
        
    }
}

extension ForgotPasswordController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        didTapResetPassword()
        return true
    }
}
