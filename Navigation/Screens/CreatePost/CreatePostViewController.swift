//
//  CreatePostViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 03.12.2024.
//

import UIKit

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    private var viewModel: CreatePostViewModel
    
    private lazy var bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16)
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 8.0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var attachPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Attach Photo", for: .normal)
        button.backgroundColor = .systemGray6
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(attachPhotoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var attachedImageView: LoadingImageView = {
        let imageView = LoadingImageView()
        imageView.contentMode = .center // Центрирование символа
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(
            systemName: "photo.on.rectangle"
        )?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray // Цвет символа
        return imageView
        
    }()
    
    private lazy var publishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Publish", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 8.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(publishButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    init(viewModel: CreatePostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        bindViewModel()
    }
    
    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .customBackgroundColor
        navigationItem.title = "Create Post"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    private func addSubviews() {
        view.addSubview(bodyTextView)
        view.addSubview(attachPhotoButton)
        view.addSubview(attachedImageView)
        view.addSubview(publishButton)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            bodyTextView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 16),
            bodyTextView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            bodyTextView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            bodyTextView.heightAnchor.constraint(equalToConstant: 200),
            
            attachPhotoButton.topAnchor.constraint(equalTo: bodyTextView.bottomAnchor, constant: 16),
            attachPhotoButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            attachPhotoButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            attachPhotoButton.heightAnchor.constraint(equalToConstant: 44),
            
            attachedImageView.topAnchor.constraint(equalTo: attachPhotoButton.bottomAnchor, constant: 16),
            attachedImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            attachedImageView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
            attachedImageView.heightAnchor.constraint(equalToConstant: 200),
            
            publishButton.topAnchor.constraint(equalTo: attachedImageView.bottomAnchor, constant: 24),
            publishButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            publishButton.widthAnchor.constraint(equalToConstant: 120),
            publishButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onPostCreated = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        viewModel.onErrorOccurred = { [weak self] error in
            let alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(alert, animated: true)
        }
    }
    
    @objc private func attachPhotoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc private func publishButtonTapped() {
        guard let body = bodyTextView.text, !body.isEmpty else {
            let alert = UIAlertController(
                title: "Validation Error",
                message: "Post content cannot be empty.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
    
        viewModel.createPost(body: body)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.uploadImage(image: image, imageView: attachedImageView)
            attachedImageView.contentMode = .scaleAspectFill
            attachedImageView.image = image
            
        }
        dismiss(animated: true)
    }
}

