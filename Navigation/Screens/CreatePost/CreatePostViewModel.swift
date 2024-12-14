//
//  CreatePostViewModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 03.12.2024.
//

import Foundation
import UIKit

class CreatePostViewModel {
    
    var onPostCreated: (() -> Void)?
    var onErrorOccurred: ((Error) -> Void)?
    var imageUrl:String = ""
    
    func createPost(body: String) {
        guard let user = CurrentUser.shared.user else {
               onErrorOccurred?(NSError(domain: "App", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
               return
           }

           let newPost = Post(
               id: UUID().uuidString,
               author: Author(id: user.id, name: user.fullname, urlImage: user.avatarURL ?? ""),
               postDescription: body,
               urlImage: imageUrl,
               likes: 0,
               createdAt: Date()
           )
        PostManager.shared.savePost(post: newPost){error in
            if let error = error {
                self.onErrorOccurred?(error)
                return
            }else{
                self.onPostCreated?()
            }
        }
       
    }
    
    func uploadImage(image: UIImage, button: UIButton, imageView: LoadingImageView){
        imageView.showLoading()
        button.isEnabled = false
        PhotosManager.shared.addPhoto(image: image){result in
            
            print(result)
            switch result{
            case .success(let url):
                self.imageUrl = url
                button.isEnabled = true
                imageView.hideLoading()

            case .failure(let error):
                self.onErrorOccurred?(error)
                imageView.hideLoading()
            }
            
        }
        
    }
}
