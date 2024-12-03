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
    
    func createPost(title: String, body: String) {
        // Simulate API call or data persistence
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            DispatchQueue.main.async {
                self.onPostCreated?()
            }
        }
    }
    
    func uploadImage(image: UIImage){
        FirebaseStorageService.shared.uploadImage(image: image){result in
            switch result{
            case .success(let url):
                self.imageUrl = url

            case .failure(let error):
                self.onErrorOccurred?(error)
            }
            
        }
        
    }
}
