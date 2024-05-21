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
}
