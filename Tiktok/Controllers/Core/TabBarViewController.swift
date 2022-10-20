//
//  TabBarViewController.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 9/29/22.
//

import UIKit



class TabBarViewController: UITabBarController {

    private var signInPresented = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpControllers()
     
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !signInPresented {
            presentSignInIfNeeded()
            
            
        }
       
    }
    
    private func  presentSignInIfNeeded() {
        if !AuthManager.shared.isSignedIn {
            signInPresented = true
            let vc = SignInViewController()
            vc.completion = { [weak self] in
                self?.signInPresented = false
            }
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            present(navVC, animated: false )
        }
    }
    

    private func setUpControllers() {
        let home = HomeViewController()
        let explore = ExplorerViewController()
        let camera = CameraViewController()
        let notification = NotificationViewController()
        var urlString: String?
        if let cachedUrlString = UserDefaults.standard.string(forKey: "profile_picture_url") {
            urlString = cachedUrlString
        }
        
        
        
        
        let profile = ProfileViewController(user: User(username: "joesmith".uppercased(), profilePictureURL: nil, identifier: "joesmith"))
        
        
        home.title = "Home"
        explore.title = "Explore"
        notification.title = "Notification"
        profile.title = "Profile"
       
        
        let nav1 = UINavigationController(rootViewController: home)
        let nav2 = UINavigationController(rootViewController: explore)
        let nav3 = UINavigationController(rootViewController: notification)
        let nav4 = UINavigationController(rootViewController: profile)
        let cameraNav = UINavigationController(rootViewController: camera)
        cameraNav.navigationBar.backgroundColor = .clear
        cameraNav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        cameraNav.navigationBar.shadowImage = UIImage()
        cameraNav.navigationBar.tintColor = .white
        
        nav3.navigationBar.tintColor = .label
        nav4.navigationBar.tintColor = .label
        
        nav1.navigationBar.backgroundColor = .clear
        nav1.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav1.navigationBar.shadowImage = UIImage()
        
        
        nav1.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "safari"), tag: 2)
        camera.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 3)
        nav3.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell"), tag: 4)
        nav4.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.circle"), tag: 5)
        
        
        
        if #available(iOS 14.0, *) {
            nav1.navigationItem.backButtonDisplayMode = .minimal
            nav2.navigationItem.backButtonDisplayMode = .minimal
            nav3.navigationItem.backButtonDisplayMode = .minimal
            nav4.navigationItem.backButtonDisplayMode = .minimal
            cameraNav.navigationItem.backButtonDisplayMode = .minimal
        }
        
       
        
        setViewControllers([nav1, nav2, cameraNav, nav3, nav4], animated: false)
        
        
        
        
    }
}
