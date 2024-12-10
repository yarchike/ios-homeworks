//
//  FullScreenImageViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 10.12.2024.
//

import Foundation


import UIKit

class FullScreenImageViewController: UIViewController {

    var image: UIImage?
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        view.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
 
        imageView.image = image

        view.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Добавляем жест для закрытия экрана
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeFullscreen))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func closeFullscreen() {
        dismiss(animated: true, completion: nil)
    }
}
