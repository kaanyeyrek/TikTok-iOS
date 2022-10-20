//
//  SignUpViewController.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 9/29/22.
//

import UIKit
import SafariServices

class SignUpViewController: UIViewController {

    public var completion: (() -> Void)?
    
    
    private let logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
        
    }()
    
    private let usernameField = AuthField(type: .username)
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)
    
    private let signUpButton = AuthButton(type: .signUp, title: nil)
    private let TermsOfServiceButton = AuthButton(type: .plain, title: "Terms of Service")

   
  
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Create Account"
        addSubview()
        configureButtons()
        configureFields()

        
    }
    private  func addSubview() {
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(TermsOfServiceButton)
     
    }
    
    func configureFields() {
        emailField.delegate = self
        passwordField.delegate = self
        usernameField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                         UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
                         emailField.inputAccessoryView = toolBar
                         passwordField.inputAccessoryView = toolBar
                         usernameField.inputAccessoryView = toolBar
        
        
        
     
    }
    
    @objc func didTapKeyboardDone() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        usernameField.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize: CGFloat = 100
        logoImageView.frame = CGRect(x: (view.width-imageSize)/2, y: view.safeAreaInsets.top, width: imageSize, height: imageSize)
        
        usernameField.frame = CGRect(x: 20, y: logoImageView.bottom+20, width: view.width-40, height: 55)
        emailField.frame = CGRect(x: 20, y: usernameField.bottom+15, width: view.width-40, height: 55)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+15, width: view.width-40, height: 55)
       
        signUpButton.frame = CGRect(x: 20, y: passwordField.bottom+20, width: view.width-40, height: 55)
        TermsOfServiceButton.frame = CGRect(x: 20, y: signUpButton.bottom+50, width: view.width-40, height: 55)
      
       
    }
    
    func configureButtons() {
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        TermsOfServiceButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        
        
    }
 
    @objc private func didTapSignUp() {
        didTapKeyboardDone()
        guard let email = emailField.text, let password = passwordField.text, let username = usernameField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty, 
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6,
              !username.contains(" "),
              !username.contains(".")
                else {
                  let alert = UIAlertController(title: "Woops!", message: "Please make sure to enter a valid username, email, and password. Your password must be atleast 6 characters long", preferredStyle: .alert)
                  alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                  present(alert, animated: true)
                  return
              }
        
        
        AuthManager.shared.signUp(with: username, emailAdress: email, password: password) { success in
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Woops!", message: "Something went wrong when trying to register. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    
                }
            }
        }
        
    }
  
    @objc private func didTapTerms() {
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com/terms") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }

}

  

extension SignUpViewController: UITextFieldDelegate {
    
}

