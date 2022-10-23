//
//  SignInViewController.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 9/29/22.
//

import UIKit
import SafariServices

class SignInViewController: UIViewController {

    public var completion: (() -> Void)?
    
    
    private let logoImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
        
    }()
    
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)
    private let signInButton = AuthButton(type: .signIn, title: nil)
    private let forgotPasswordButton = AuthButton(type: .plain, title: "Forgot Password")
    private let signUpButton = AuthButton(type: .plain, title: "New User? Create Account")
   
  
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "TikTok"
        addSubview()
        configureButtons()
        configureFields()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    private  func addSubview() {
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(forgotPasswordButton)
     
    }
    
    func configureFields() {
        emailField.delegate = self
        passwordField.delegate = self
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                         UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
                         emailField.inputAccessoryView = toolBar
                         passwordField.inputAccessoryView = toolBar
        
        
        
     
    }
    
    @objc func didTapKeyboardDone() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize: CGFloat = 100
        logoImageView.frame = CGRect(x: (view.width-imageSize)/2, y: view.safeAreaInsets.top, width: imageSize, height: imageSize)
        emailField.frame = CGRect(x: 20, y: logoImageView.bottom+20, width: view.width-40, height: 55)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+20, width: view.width-40, height: 55)
        signInButton.frame = CGRect(x: 20, y: passwordField.bottom+20, width: view.width-40, height: 55)
        forgotPasswordButton.frame = CGRect(x: 20, y: signInButton.bottom+40, width: view.width-40, height: 55)
        signUpButton.frame = CGRect(x: 20, y: forgotPasswordButton.bottom+20, width: view.width-40, height: 55)
       
    }
    
    func configureButtons() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
        
        
    }
 
    @objc private func didTapSignIn() {
        didTapKeyboardDone()
        guard let email = emailField.text, let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            let alert = UIAlertController(title: "Woops!", message: "Please enter a valid email and password to sign in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        
        AuthManager.shared.signIn(with: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let email):
                    HapticsManager.shared.vibrate(for: .success)
                    self?.dismiss(animated: true, completion: nil)
                    
                case .failure(let error):
                    HapticsManager.shared.vibrate(for: .error)
                    let alert = UIAlertController(title: "Woops!", message: "Please check your email and password to try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                    self?.passwordField.text = nil
                }
            }
            
        }
    }
    @objc private func didTapSignUp() {
        didTapKeyboardDone()
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapForgotPassword() {
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com/forgot-password") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }

}

extension SignInViewController: UITextFieldDelegate {
    
}
