//
//  LikeDataManager.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 03.06.2024.
//

import Foundation
import CoreData
import StorageService

final class LikeDataManager {
    
    static let shared = LikeDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LikeModel")
        container.loadPersistentStores(completionHandler: {(storeDescription, error) in
            if let error = error as NSError?{
                fatalError("Unresolved error \(error)")
            }
        })
        
        return container
    }()
    
    
    func getLikePost() -> [LikePost]{
        let request = LikePost.fetchRequest()
        return (try? persistentContainer.viewContext.fetch(request)) ?? []
    }
    
    func addLikePost(post: Post){
        let likePost = LikePost(context: persistentContainer.viewContext)
        likePost.author = post.author
        likePost.image = post.image
        likePost.likes = Int16(post.likes)
        likePost.views = Int16(post.views)
        likePost.postDescription = post.postDescription
        try? persistentContainer.viewContext.save()
    }
    
}

