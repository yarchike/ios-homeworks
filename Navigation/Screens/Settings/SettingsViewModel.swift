//
//  SettingsViewModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 06.12.2024.
//

import UIKit

class SettingsViewModel {
    var avatarUrl: String?
    var fullName: String?
    var switchToLoginInterface: (() -> ()) = {}

    var onSettingsUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    

    func fetchCurrentSettings() {
        self.avatarUrl = CurrentUser.shared.user?.avatarURL
        self.fullName = CurrentUser.shared.user?.fullname
        onSettingsUpdated?()
    }

    func updateAvatar(_ newAvatar: UIImage) {
        FirebaseStorageService.shared.uploadImage(image: newAvatar){result in
            switch result{
            case .success(let url):
                if let user = CurrentUser.shared.user{
                    let newUser = user.copyWithNewValues(avatarURL: url)
                    UserService.shared.updateUser(user: newUser){error in
                        if error != nil{
                            self.onError?("Loading error".localized)
                            return
                        }
                        CurrentUser.shared.user = newUser
                        self.onSettingsUpdated?()
                    }
                    self.avatarUrl = url
                    self.onSettingsUpdated?()
                }
            case .failure(_):
                self.onError?("Loading error".localized)
            }
            
        }
    }

    func updateFullName(_ newFullName: String) {
        if let user = CurrentUser.shared.user{
            let newUser = user.copyWithNewValues(fullname: newFullName)
            UserService.shared.updateUser(user: newUser){error in
                if error != nil{
                    self.onError?("Loading error".localized)
                    return
                }
                CurrentUser.shared.user = newUser
                self.onSettingsUpdated?()
            }
            self.fullName = newFullName
            self.onSettingsUpdated?()
        }
        self.fullName = newFullName
        onSettingsUpdated?()
    }

    func updatePassword(_ newPassword: String, confirmPassword: String, completion: @escaping (Error?) -> Void) {
        if newPassword != confirmPassword {
            completion(NSError(domain: "SettingsViewModel", code: 1001, userInfo: [NSLocalizedDescriptionKey: "The passwords do not match.".localized]))
            return
        }
        UserService.shared.updatePassword(password: newPassword){ error in
            if error != nil{
                completion(error)
            }
            completion(nil)
        }

    }
    func logout(){
        UserService.shared.signOut()
        switchToLoginInterface()
    }
}
