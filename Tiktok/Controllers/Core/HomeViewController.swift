//
//  ViewController.swift
//  Tiktok
//
//  Created by Kaan Yeyrek on 9/29/22.
//

import UIKit




class HomeViewController: UIViewController {

    private var forYouPosts = PostModel.mockModels()
    private var followingPosts = PostModel.mockModels()
    
    private let control: UISegmentedControl = {
        let titles = ["Following", "For You"]
        let control = UISegmentedControl(items: titles)
        control.selectedSegmentIndex = 1
        
        return control
    }()
    
    
    let horizontalScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
        
    }()
    
    let forYouPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: [:])
    
    let followingPageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: [:])
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(horizontalScrollView)
        horizontalScrollView.contentOffset = CGPoint(x: view.width, y: 0)
        setUpFeed()
        horizontalScrollView.contentInsetAdjustmentBehavior = .never
        
        setUpHeaderButtons()
        horizontalScrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        horizontalScrollView.frame = view.bounds
    }
    
    func setUpHeaderButtons() {
        control.addTarget(self, action: #selector(didChangeSegmentControl(_:)), for: .valueChanged)
        
        navigationItem.titleView = control
    }
    
    @objc private func didChangeSegmentControl(_ sender: UISegmentedControl) {
        horizontalScrollView.setContentOffset((CGPoint(x: view.width * CGFloat(sender.selectedSegmentIndex), y: 0)), animated: true)
    }


    
    func setUpFeed() {
        horizontalScrollView.contentSize = CGSize(width: view.width * 2, height: view.height)
        
      setUpFollowingFeed()
      setUpForYouFeed()
        
        
    }
    
    func setUpFollowingFeed() {
     
        guard let model = followingPosts.first else {
            return
        }
        
        let vc = PostViewController(model: model)
        vc.delegate = self
        followingPageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        
        followingPageViewController.dataSource = self
        horizontalScrollView.addSubview(followingPageViewController.view)
        followingPageViewController.view.frame = CGRect(x: view.width, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        addChild(followingPageViewController)
        followingPageViewController.didMove(toParent: self)
    }
    
    func  setUpForYouFeed() {
        
        guard let model = forYouPosts.first else {
            return
        }
        let vc = PostViewController(model: model)
        vc.delegate = self
        forYouPageViewController.setViewControllers([vc], direction: .forward, animated: false, completion: nil)
        
        forYouPageViewController.dataSource = self
        horizontalScrollView.addSubview(forYouPageViewController.view)
        forYouPageViewController.view.frame = CGRect(x: view.width, y: 0, width: horizontalScrollView.width, height: horizontalScrollView.height)
        addChild(forYouPageViewController)
        forYouPageViewController.didMove(toParent: self)
        
    }
    
    
}

//MARK: - UIPageView DataSource

extension HomeViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        
        guard let index = currentPosts.firstIndex(where: {
            
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        if index == 0 {
            return  nil
        }
        let priorIndex = index - 1
        let model = currentPosts[priorIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let fromPost = (viewController as? PostViewController)?.model else {
            return nil
        }
        
        guard let index = currentPosts.firstIndex(where: {
            
            $0.identifier == fromPost.identifier
        }) else {
            return nil
        }
        
        guard index < (currentPosts.count - 1) else {
            return nil
        }
        
        let nextIndex = index + 1
        let model = currentPosts[nextIndex]
        let vc = PostViewController(model: model)
        vc.delegate = self
        return vc
    }
    
    
    var currentPosts: [PostModel] {
        if horizontalScrollView.contentOffset.x == 0 {
            return followingPosts
        }
        
        return forYouPosts
    }
    
    
    //MARK: - UIScrollView Delegate
    
}


extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x < (view.width/2){
            control.selectedSegmentIndex = 0
            
        } else if scrollView.contentOffset.x > (view.width/2) {
            control.selectedSegmentIndex = 1
        }
    }
}

extension HomeViewController: PostViewControllerDelegate{
    func postViewController(_ vc: PostViewController, with post: PostModel) {
        horizontalScrollView.isScrollEnabled = false
        if horizontalScrollView.contentOffset.x == 0 {
            followingPageViewController.dataSource = nil
            
        } else {
            forYouPageViewController.dataSource = nil
        }
        HapticsManager.shared.vibrateForSelection()
        
        let vc = CommentsViewController(post: post)
        vc.delegate = self
        addChild(vc)
        vc.didMove(toParent: self)
        view.addSubview(vc.view)
        let frame: CGRect = CGRect(x: 0, y: view.height, width: view.width, height: view.height * 0.76)
        vc.view.frame = frame
        
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(x: 0, y: self.view.height - frame.height, width: frame.width, height: frame.height)
        }
    }
    
    func postViewController(_ vc: PostViewController, didTapProfileButtonWith post: PostModel) {
        let user = post.user
        let vc = ProfileViewController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: CommentsViewControllerDelegate {
    func didTapCloseForComments(with vc: CommentsViewController) {
        
        let frame = vc.view.frame
        UIView.animate(withDuration: 0.2) {
            vc.view.frame = CGRect(x: 0, y: self.view.height, width: frame.width, height: frame.height)
        } completion: { [weak self] done in
            if done {
                DispatchQueue.main.async {
                    vc.view.removeFromSuperview()
                    vc.removeFromParent()
                    
                    self?.horizontalScrollView.isScrollEnabled = true
                    self?.forYouPageViewController.dataSource = self
                    self?.followingPageViewController.dataSource = self
                }
            }
        }
        
    }
    
   
}


