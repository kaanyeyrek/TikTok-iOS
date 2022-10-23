//
//  PostViewController.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 9/29/22.
//

import UIKit
import AVFoundation

protocol PostViewControllerDelegate: AnyObject {
    func postViewController(_ vc: PostViewController, with post: PostModel)
    func postViewController(_ vc: PostViewController, didTapProfileButtonWith post: PostModel)
}




class PostViewController: UIViewController {
    var player: AVPlayer?
    
    private var playerDidFinishObserver: NSObjectProtocol?
    
    
    weak var delegate: PostViewControllerDelegate?
    
    var model: PostModel
    
    private let videoView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.startAnimating()
        spinner.color = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
       
       return button
    }()
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
       return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
       return button
    }()
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "test"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.layer.masksToBounds = true
        button.tintColor = .white
       return button
    }()
    
    
    private let captionLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = "Check out this video! #fyp #foryou #foryoupage"
        label.font = .systemFont(ofSize: 24)
        return label
        
        
    }()
   
    
    
    
    
    init(model: PostModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVideo()
        setUpButtons()
        setUpDoubleTapToLike()
       
        view.backgroundColor = .black
       
 
    }
    
    func setUpButtons() {
        view.addSubview(spinner)
        view.addSubview(videoView)
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        view.addSubview(captionLabel)
        view.addSubview(profileButton)
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
       
        
    }
    
  
    @objc private func didTapProfileButton() {
        delegate?.postViewController(self, didTapProfileButtonWith: model)
    }
    
    
    @objc private func didTapLike() {
        model.isLikedByCurrentUser = !model.isLikedByCurrentUser
        likeButton.tintColor = model.isLikedByCurrentUser ? .systemRed : .white
    }
    
    @objc private func didTapComment() {
        delegate?.postViewController(self, with: model)
    
    }
    
    @objc private func didTapShare() {
        
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
        present(vc, animated: true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoView.frame = view.bounds
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = videoView.center
        
        let size: CGFloat = 40
      
        let yStart: CGFloat = view.height - (size * 4) - 30 - view.safeAreaInsets.bottom
        
        for (index, button) in [profileButton, likeButton, commentButton, shareButton].enumerated() {
            
            button.frame = CGRect(x: view.width-size-10, y: yStart + (CGFloat(index) * 10) + (CGFloat(index) * size), width: size, height: size)
        }
        captionLabel.sizeToFit()
        let captionLabelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12, height: view.height))
        captionLabel.frame = CGRect(x: 5, y: view.height - view.safeAreaInsets.bottom - captionLabelSize.height,
        width: view.width - size - 12, height: captionLabelSize.height)
        

        profileButton.layer.cornerRadius = size / 2
        
        
       
    }
    private func configureVideo() {

        StorageManager.shared.getDownloadURL(for: model) { [weak self] result in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                strongSelf.spinner.stopAnimating()
                strongSelf.spinner.removeFromSuperview()
                switch result {
                case .success(let url):
                    
                    strongSelf.player = AVPlayer(url: url)
                    let playerLayer = AVPlayerLayer(player: strongSelf.player)
                    playerLayer.frame = strongSelf.view.bounds
                    strongSelf.videoView.layer.addSublayer(playerLayer)
                    playerLayer.videoGravity = .resizeAspectFill
                    strongSelf.player?.volume = 0
                    strongSelf.player?.play()
                    
                case .failure:

                    guard let path = Bundle.main.path(forResource: "video", ofType: "mp4") else {
                        return
                    }
                    let url = URL(fileURLWithPath: path)
                    
                    strongSelf.player = AVPlayer(url: url)
                    
                    let playerLayer = AVPlayerLayer(player: strongSelf.player)
                    playerLayer.frame = strongSelf.view.bounds
                    strongSelf.videoView.layer.addSublayer(playerLayer)
                    playerLayer.videoGravity = .resizeAspectFill
                    strongSelf.player?.volume = 0
                    strongSelf.player?.play()

                }

            }

        }

        guard let player = player else {
            return
        }

        playerDidFinishObserver = NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main)
            { _ in
                player.seek(to: .zero)
                player.play()
            }

    }

    func setUpDoubleTapToLike() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }

    @objc private func didDoubleTap(_ gesture: UITapGestureRecognizer) {
        if !model.isLikedByCurrentUser {
            model.isLikedByCurrentUser = true
        }
        HapticsManager.shared.vibrateForSelection()
        let touchLocation = gesture.location(in: view)

        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = touchLocation
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1
        } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    UIView.animate(withDuration: 0.2) {
                        imageView.alpha = 0

                    } completion: { done in
                        if done {
                            imageView.removeFromSuperview()
                        }
                    }
                }
                
            }
            
        }
        
    }


}
