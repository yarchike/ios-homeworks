//
//  RegistrationViewModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 27.11.2024.
//

import UIKit

class RegistrationViewModel {
    // Свойства для хранения данных
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var urlAvatar: String = ""
    
    // Замыкания для обработки событий
    var onValidationError: ((String) -> Void)?
    var onRegistrationSuccess: (() -> Void)?
    
    // Метод валидации и регистрации
    func validateAndRegister() {
        if email.isEmpty || firstName.isEmpty || lastName.isEmpty || password.isEmpty || confirmPassword.isEmpty ||  urlAvatar.isEmpty {
            onValidationError?("Заполните все поля")
            return
        }
        
        if password != confirmPassword {
            onValidationError?("Пароли не совпадают")
            return
        }
        
        // Успешная регистрация
        FirebaseAutch.shared.signUp(withEmail: email, password: password){ result in
            switch result{
            case .success(let uid):
                let newUser  = User(id:uid, email: self.email, fullname: "\(self.firstName) \(self.lastName)", avatarURL: self.urlAvatar, status: "")
                FirebaseDataBaseService.shared.saveUser(user: newUser){_ in 
                    switch result{
                    case .failure(_):
                        self.onValidationError?("Ошибка. Попробуйте позже")
                    case .success(_):
                        self.onRegistrationSuccess?()
                    }
                }

            case .failure(_):
                self.onValidationError?("Ошибка. Попробуйте позже")
            }
        }
    }
    
    
    
    
    func changeAvatart(avatar: UIImage){
        FirebaseStorageService.shared.uploadImage(image: avatar){result in
            switch result{
            case .success(let url):
                self.urlAvatar = url

            case .failure(_):
                self.onValidationError?("Ошибка загрузки")
            }
            
        }
        
    }
    

}
