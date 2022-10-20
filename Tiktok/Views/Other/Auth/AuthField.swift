//
//  AuthField.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 10/8/22.
//

import UIKit

class AuthField: UITextField {

    enum FieldType {
        case email
        case password
        case username
        
        var title: String {
            switch self {
            case .email:
                return "Email Adress"
            case .password:
                return "Password"
            case .username:
                return "Username"
            }
            
            
        }
    }
    
    private let type: FieldType
    
    
    
    init(type: FieldType) {
        self.type = type
        super.init(frame: .zero)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureUI() {
        if type == .password {
            isSecureTextEntry = true
            textContentType = .oneTimeCode
   
        } else if type == .email {
            keyboardType = .emailAddress
            textContentType = .emailAddress 
        }
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height))
        leftViewMode = .always
        returnKeyType = .done
        autocorrectionType = .no
        autocapitalizationType = .none
       
        
    }
    
    
}
