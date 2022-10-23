//
//  CaptionViewController.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 10/10/22.
//

import UIKit
import ProgressHUD
import Appirater

class CaptionViewController: UIViewController {

    private let captionTextView: UITextView = {
        let textView = UITextView()
        textView.contentInset = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        return textView
    }()
    
    
    let videoURL: URL
    
    
    init(videoURL: URL) {
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
        view.addSubview(captionTextView)
  
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captionTextView.frame = CGRect(x: 5, y: view.safeAreaInsets.top+5, width: view.width-10, height: 150).integral
    }
    
    override func viewDidAppear(_ animated: Bool) {
        becomeFirstResponder()
    }
    
    @objc private func didTapPost() {
        captionTextView.resignFirstResponder()
        let caption = captionTextView.text ?? ""
        let videoName = StorageManager.shared.generateVideoName()
        
        ProgressHUD.show("Posting")
        
        StorageManager.shared.uploadVideoURL(from: videoURL, fileName: videoName) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    DatabaseManager.shared.insertPost(fileName: videoName, caption: caption) { databaseUpdated in
                        if databaseUpdated {
                            Appirater.tryToShowPrompt()
                            HapticsManager.shared.vibrate(for: .success)
                            ProgressHUD.dismiss()
                            self?.navigationController?.popToRootViewController(animated: true)
                            self?.tabBarController?.selectedIndex = 0
                            self?.tabBarController?.tabBar.isHidden = false
                        }
                    }
                
                    
                } else {
                    HapticsManager.shared.vibrate(for: .error)
                    ProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Woops", message: "We were unable to upload your video. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel,handler: nil))
                    self?.present(alert, animated: true)
                }
            }
        }
        
    }
    

  


}
