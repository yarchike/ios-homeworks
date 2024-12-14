//
//  ApiError.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 25.04.2024.
//

import Foundation

enum ApiError: Error {
    case badRequest
    case notFound
    case unAuth
    case unowned
    case forbidden
    case authError(message: String)
    
    
    var message: String {
         switch self {
         case .badRequest:
             return "Bad request. Please check your input.".localized
         case .notFound:
             return "Requested resource not found.".localized
         case .unAuth:
             return "Unauthorized access. Please log in.".localized
         case .unowned:
             return "An unknown error occurred.".localized
         case .forbidden:
             return "Access forbidden. You don't have permission.".localized
         case .authError(let message):
             return message
         }
     }
}
