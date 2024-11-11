//
//  LocalAuthorizationService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 11.11.2024.
//

import LocalAuthentication
import UIKit

class LocalAuthorizationService {
    
    var biometricType: LABiometryType {
         let context = LAContext()
         context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
         
         switch context.biometryType {
         case .faceID:
             return .faceID
         case .touchID:
             return .touchID
         default:
             return .none
         }
     }
    

    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Авторизации по биометрии"
            
        
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
                DispatchQueue.main.async {
                    authorizationFinished(success, error)
                }
            }
        } else {
            authorizationFinished(false,error)
        }
    }
}
