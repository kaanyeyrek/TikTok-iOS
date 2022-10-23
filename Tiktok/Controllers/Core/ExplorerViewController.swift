//
//  ExplorerViewController.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 9/29/22.
//

import UIKit




class ExplorerViewController: UIViewController {
    
    
    private var sections = [ExploreSection]()
    
    private let searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search"
        bar.layer.cornerRadius = 8
        bar.layer.masksToBounds = true
        return bar
    }()
    
    private var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        setupSearchBar()
        setupCollectionView()
        view.backgroundColor = .systemBackground
        
    }
    

 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    func setupSearchBar() {
        navigationItem.titleView = searchBar
        searchBar.delegate = self
    }
    
    func configureModels() {
        // Banners
        var cells = [ExploreCell]()
        for _ in 0...1000 {
            cells.append(ExploreCell.banner(viewModel: ExploreBannerViewModel(image: UIImage(named: "test"), title: "Gradient", handler: {
            })))
    }
        sections.append(ExploreSection(type: .banners, cells: cells))
        
        
        
        // Trending Posts
        var posts = [ExploreCell]()
        for _ in 0...40 {
            posts.append(ExploreCell.post(viewModel: ExplorePostViewModel(thumbnailImage: UIImage(named: "test"), caption: "This was a really cool post.. ", handler: {
            })))
        }
        sections.append(ExploreSection(type: .trendingPosts, cells: posts))
                                                                     
     
        //Users
        sections.append(ExploreSection(type: .users, cells: [.user(viewModel: ExploreUserViewModel(profilePictureURL: nil, username: "charlie", followerCount: 0, handler: {
        })),
            .user(viewModel: ExploreUserViewModel(profilePictureURL: nil, username: "jason", followerCount: 0, handler: {

        })),
            .user(viewModel: ExploreUserViewModel(profilePictureURL: nil, username: "kaan", followerCount: 0, handler: {
         }
        )),
            .user(viewModel: ExploreUserViewModel(profilePictureURL: nil, username: "kevin", followerCount: 0, handler: {

}))]))
        
        // Trending Hashtags
        sections.append(ExploreSection(type: .trendingHashtags, cells: [.hashtag(viewModel: ExploreHashtagViewModel(text: "#iphone", icon: UIImage(systemName: "bell"), count: 1, handler: {
            
        })),
             .hashtag(viewModel: ExploreHashtagViewModel(text: "#macbookpro", icon: UIImage(systemName: "airplane"), count: 1, handler: {
        })),
             .hashtag(viewModel: ExploreHashtagViewModel(text: "#macbookair", icon: UIImage(systemName: "bell"), count: 1, handler: {
        })),
             .hashtag(viewModel: ExploreHashtagViewModel(text: "#iphone13", icon: UIImage(systemName: "house"), count: 1, handler: {
        })),
             .hashtag(viewModel: ExploreHashtagViewModel(text: "#iphone14", icon: UIImage(systemName: "heart"), count: 1, handler: {
        })),
]))
        
        // Recommended
         
        sections.append(ExploreSection(type: .recommended, cells: posts))
        
        // Popular
        sections.append(ExploreSection(type: .popular, cells: posts))
        // New
        sections.append(ExploreSection(type: .new, cells: posts))
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection in
            return self.layout(for: section)
            
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ExploreBannerCollectionViewCell.self, forCellWithReuseIdentifier: ExploreBannerCollectionViewCell.identifier)
        collectionView.register(ExplorePostCollectionViewCell.self, forCellWithReuseIdentifier: ExplorePostCollectionViewCell.identifier)
        collectionView.register(ExploreUserCollectionViewCell.self, forCellWithReuseIdentifier: ExploreUserCollectionViewCell.identifier)
        collectionView.register(ExploreHashtagCollectionViewCell.self, forCellWithReuseIdentifier: ExploreHashtagCollectionViewCell.identifier   )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        
        self.collectionView = collectionView
        
        
    }
 
   
}
//MARK: - CollectionView Delegate Methods
extension ExplorerViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].cells[indexPath.row]
      
        switch model {
            
            
        case .banner(viewModel: let viewModel):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreBannerCollectionViewCell.identifier, for: indexPath) as? ExploreBannerCollectionViewCell
            else {
              return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
                return cell
        case .post(viewModel: let viewModel):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExplorePostCollectionViewCell.identifier, for: indexPath) as? ExplorePostCollectionViewCell else {
              return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
            return cell
        case .hashtag(viewModel: let viewModel):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreHashtagCollectionViewCell.identifier, for: indexPath) as? ExploreHashtagCollectionViewCell else {
              return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
            return cell
        case .user(viewModel: let viewModel):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreUserCollectionViewCell.identifier, for: indexPath) as? ExploreUserCollectionViewCell else {
              return UICollectionViewCell()
            }
            cell.configure(with: viewModel)
            return cell 
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
    }
    
}

//MARK: - SearchBar Delegate Methods
extension ExplorerViewController: UISearchBarDelegate {
    
    
}

//MARK: - Section Layouts

extension ExplorerViewController {
    
    func layout(for section: Int) -> NSCollectionLayoutSection {
        let sectionType = sections[section].type
        
        switch sectionType {
        case .banners:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200)), subitems: [item])
            
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .groupPaging
            
            return sectionLayout
     
          
        case .users:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(200), heightDimension: .absolute(200)), subitems: [item])
            
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            return sectionLayout
            
        case .trendingHashtags:
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), subitems: [item])
  
            
                                                                 
            let sectionLayout = NSCollectionLayoutSection(group: verticalGroup)
          
            
            return sectionLayout
        
          
            
        case .recommended, .new, .trendingPosts:
             
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(300)), subitem: item, count: 2)
            
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(300)), subitems: [verticalGroup])
            
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            return sectionLayout
       
            
        case .popular:
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            
            
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(200)), subitems: [item])
            
            let sectionLayout = NSCollectionLayoutSection(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            
            return sectionLayout
            
        }
        
      
        
        
    }
}


