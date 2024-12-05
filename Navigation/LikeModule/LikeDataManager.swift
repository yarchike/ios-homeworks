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
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    
    func getLikePost() -> [LikePost]{
        let request = LikePost.fetchRequest()
        return (try? persistentContainer.viewContext.fetch(request)) ?? []
    }
    
    func getLikeFilterPost(author: String) -> [LikePost]{
        let request = LikePost.fetchRequest()
        request.predicate = NSPredicate(format: "author CONTAINS[c] %@", author)
        return (try? persistentContainer.viewContext.fetch(request)) ?? []
    }
    
    func addLikePost(post: Post){
        persistentContainer.performBackgroundTask { [weak self] backContext in
            guard let self else {
                return
            }
            let likePost = LikePost(context: persistentContainer.viewContext)
            likePost.author = post.author.name
            likePost.image = post.urlImage
            likePost.likes = Int16(post.likes)
            likePost.postDescription = post.postDescription
            try? backContext.save()
        }
  
    }
    
    func deleteLikePost(likePost: LikePost, completion: @escaping () -> Void){
        persistentContainer.performBackgroundTask { backContext in

            let context = likePost.managedObjectContext
            context?.delete(likePost)
            try? backContext.save()
            completion()
        }
  
    }
    
}

