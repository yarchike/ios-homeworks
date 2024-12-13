//
//  FirebaseStorageService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 26.11.2024.
//

import Foundation
import UIKit
import FirebaseStorage


class FirebaseStorageService {
    
    static let shared = FirebaseStorageService()
    private let storage = Storage.storage(url: "gs://navigation-14b39.firebasestorage.app")
    
    
    func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Ошибка при конвертации изображения в данные")
            completion(.failure(NSError(domain: "ImageConversionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось конвертировать изображение в данные"])))
            return
        }
        
        // Правильный путь для загрузки
        
        let pach = "images/\(UUID().uuidString).jpg"
        let storageRef = storage.reference().child(pach)
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Ошибка при загрузке изображения: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Ошибка при получении URL: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                if let downloadURL = url {
                    print("Изображение успешно загружено! URL: \(downloadURL)")
                    completion(.success(pach))
                }
            }
        }
    }
    func fetchImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard URL(string: urlString) != nil else {
            completion(.failure(NSError(domain: "InvalidURLError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Некорректный URL"])))
            return
        }
        
        let gsReference = storage.reference(forURL: urlString)
        
        gsReference.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Ошибка при загрузке данных: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(.failure(NSError(domain: "ImageConversionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Не удалось преобразовать данные в изображение"])))
                return
            }
            
            completion(.success(image))
        }
    }


    
}
