//
//  AuthTextField.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 17.09.24.
//

import UIKit

class AuthTextField: UITextField {
    
    enum AuthTextFieldType
    {
        case username
        case email
        case password
    }
    
    private let authFieldType: AuthTextFieldType
    
    init(fieldType: AuthTextFieldType) {
        self.authFieldType = fieldType
        super.init(frame: .zero)
        
        self.backgroundColor = .secondarySystemBackground
        self.layer.cornerRadius = 10
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        switch fieldType {
        case .username:
            self.placeholder = "Username"
            
        case .email:
            self.placeholder = "Email Adress"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
            
        case .password:
            self.placeholder = "Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        }
        
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
