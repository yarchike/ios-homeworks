//
//  UIImage.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 04.12.2024.
//

import Foundation
import UIKit
import FirebaseStorage



extension UIImageView{
    
    func loadImageFromURL(_ urlString: String, placeholder: UIImage? = nil) {
            self.image = placeholder

            guard let url = URL(string: urlString) else {
                print("Некорректный URL")
                return
            }

            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            activityIndicator.hidesWhenStopped = true
            self.addSubview(activityIndicator)
            activityIndicator.startAnimating()

            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }

                if let error = error {
                    print("Ошибка загрузки изображения: \(error.localizedDescription)")
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                } else {
                    print("Не удалось загрузить изображение.")
                }
            }.resume()
        }
    
    func loadImageFromStoragePath(_ path: String, placeholder: UIImage? = nil) {
            self.image = placeholder
            print("1111111")
            print(path)
            print("1111111")
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            activityIndicator.hidesWhenStopped = true
            self.addSubview(activityIndicator)
            activityIndicator.startAnimating()

            // Ссылка на объект в Firebase Storage
            let storageRef = Storage.storage(url:"gs://navigation-14b39.firebasestorage.app").reference(withPath: path)
            
            storageRef.getData(maxSize: 5 * 1024 * 1024) { [weak self] data, error in
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }

                if let error = error {
                    print("Ошибка загрузки изображения: \(error.localizedDescription)")
                    return
                }

                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                } else {
                    print("Не удалось преобразовать данные в изображение.")
                }
            }
        }
}
