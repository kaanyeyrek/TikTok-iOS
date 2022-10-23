//
//  StorageManager.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 9/29/22.
//

import Foundation
import FirebaseStorage

// Manager objet that deals with firebase storage
final class StorageManager {
    // Shared singleton instance
    public static let shared = StorageManager()
    // Storage bucket
    private let storageBucket = Storage.storage().reference()
    // Private constructor
    private init() {
        
    }
    
    // Public
    
    // Upload Video
    public func uploadVideoURL(from url: URL, fileName: String, completion: @escaping (Bool) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }  
        storageBucket.child("videos/\(username)/\(fileName)").putFile(from: url, metadata: nil) { _, error in
            completion(error == nil)
        }
    }
    // Upload new profile picture
    // Download profile picture
    
    public func uploadProfilePicture(with image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        let path = "profile_picture/\(username)/picture.png"
        storageBucket.child(path).putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
            }
            else {
                self.storageBucket.child(path).downloadURL { url, error in
                    guard let url = url else {
                        if let error = error {
                            completion(.failure(error))
                        }
                        return
                    }
                    completion(.success(url))
                }
                
            }
            
        }
    }
    
    //MARK: - Generate New Video fileName
    public func generateVideoName() -> String {
        
        let uuidString = UUID().uuidString
        let number = Int.random(in: 0...100)
        let unixTimestamp = Date().timeIntervalSince1970
        
        return uuidString + "_\(number)_" + "\(unixTimestamp)" + ".mov"
        
        
    }
    //MARK: - Get Download url of video post
    func getDownloadURL(for post: PostModel, completion: @escaping (Result<URL, Error>) -> Void) {
        storageBucket.child(post.videoChildPath).downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url))
            }
        }
    }
    
}

