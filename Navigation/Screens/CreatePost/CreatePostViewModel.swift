//
//  CreatePostViewModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 03.12.2024.
//

import Foundation
import UIKit
import StorageService

class CreatePostViewModel {
    
    var onPostCreated: (() -> Void)?
    var onErrorOccurred: ((Error) -> Void)?
    var imageUrl:String = ""
    
    func createPost(body: String) {
        let user = CurrentUser.shared.user
        let newPost = Post(
            author: Author(id: user?.id ?? "0", name: user?.fullname ?? "", urlImage:user?.avatarURL ?? ""),
            postDescription: body,
            urlImage: imageUrl,
            likes: 0
        )
        PostService.shared.saveToDataBase(post: newPost){error in
            if let error = error {
                self.onErrorOccurred?(error)
                return
            }else{
                self.onPostCreated?()
            }
        }
       
    }
    
    func uploadImage(image: UIImage, imageView: LoadingImageView){
        imageView.showLoading()
        FirebaseStorageService.shared.uploadImage(image: image){result in
            
            print(result)
            switch result{
            case .success(let url):
                self.imageUrl = url
                imageView.hideLoading() 

            case .failure(let error):
                self.onErrorOccurred?(error)
                imageView.hideLoading()
            }
            
        }
        
    }
}
