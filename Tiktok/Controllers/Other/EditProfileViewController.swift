//
//  EditProfileViewController.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 10/22/22.
//

import UIKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }
    @objc func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    

    

}
