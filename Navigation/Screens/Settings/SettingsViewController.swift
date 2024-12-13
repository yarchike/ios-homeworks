//
//  SettingsViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 06.12.2024.
//
import UIKit

class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectAvatarTapped)))
        
        // Устанавливаем заглушку по умолчанию
        let placeholderImage = UIImage(systemName: "person.circle.fill") // Иконка человека из SF Symbols
        imageView.image = placeholderImage
        
        return imageView
    }()

    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .label
        label.text = "Full name".localized
        return label
    }()

    private lazy var fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your full name".localized
        textField.borderStyle = .none
        textField.font = UIFont.preferredFont(forTextStyle: .body)
        textField.isHidden = true
        return textField
    }()

    private lazy var editFullNameButton: UIButton = {
        let button = UIButton(type: .system)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.title = "Change".localized
            config.image = UIImage(systemName: "pencil")
            config.imagePadding = 8
            config.buttonSize = .medium
            button.configuration = config
        } else {
            button.setTitle("Change".localized, for: .normal)
            button.setImage(UIImage(systemName: "pencil"), for: .normal)
        }
        button.addTarget(self, action: #selector(editFullNameTapped), for: .touchUpInside)
        return button
    }()

    private lazy var updatePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.filled()
            config.title = "Change password".localized
            config.buttonSize = .large
            button.configuration = config
        } else {
            button.setTitle("Change password".localized, for: .normal)
        }
        button.addTarget(self, action: #selector(updatePasswordTapped), for: .touchUpInside)
        return button
    }()
    private lazy var logoutButton: UIButton = {
           let button = UIButton(type: .system)
            button.setTitle("Exit".localized, for: .normal)
           button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
           button.tintColor = .systemRed
           return button
       }()

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        bindViewModel()
    }

    private func setupNavigationBar() {
        title = "Settings".localized
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save".localized,
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Exit".localized,
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
    }

    private func setupView() {
        view.backgroundColor = .systemGroupedBackground

        let stackView = UIStackView(arrangedSubviews: [
            avatarImageView,
            createSeparator(),
            fullNameLabel,
            fullNameTextField,
            editFullNameButton,
            createSeparator(),
            updatePasswordButton,
            logoutButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .center

        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),

            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }

    private func bindViewModel() {
        viewModel.onSettingsUpdated = { [weak self] in
            if let avatarUrl = self?.viewModel.avatarUrl{
                self?.avatarImageView.loadImageFromStoragePath(avatarUrl)
            }else{
                self?.avatarImageView.image = UIImage(systemName: "person.circle.fill")
            }
            self?.fullNameLabel.text = self?.viewModel.fullName
            self?.fullNameTextField.text = self?.viewModel.fullName
        }

        viewModel.onError = { [weak self] error in
            self?.showAlert(title: "Error".localized, message: error)
        }
        viewModel.fetchCurrentSettings()
    }

    @objc private func selectAvatarTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    @objc private func editFullNameTapped() {
        fullNameTextField.isHidden = false
        fullNameLabel.isHidden = true
        editFullNameButton.setTitle("Cancel".localized, for: .normal)
        editFullNameButton.removeTarget(self, action: #selector(editFullNameTapped), for: .touchUpInside)
        editFullNameButton.addTarget(self, action: #selector(cancelEditFullNameTapped), for: .touchUpInside)
    }

    @objc private func cancelEditFullNameTapped() {
        fullNameTextField.isHidden = true
        fullNameLabel.isHidden = false
        editFullNameButton.setTitle("Change".localized, for: .normal)
        editFullNameButton.removeTarget(self, action: #selector(cancelEditFullNameTapped), for: .touchUpInside)
        editFullNameButton.addTarget(self, action: #selector(editFullNameTapped), for: .touchUpInside)
    }

    @objc private func updatePasswordTapped() {
        let alert = UIAlertController(title: "Change password".localized, message: "Enter new password".localized, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "New Password".localized
            textField.isSecureTextEntry = true
        }
        alert.addTextField { textField in
            textField.placeholder = "Repeat new password".localized
            textField.isSecureTextEntry = true
        }

        let saveAction = UIAlertAction(title: "Save".localized, style: .default) { [weak self] _ in
            guard let newPassword = alert.textFields?[0].text, let confirmPassword = alert.textFields?[1].text else { return }
            self?.viewModel.updatePassword(newPassword, confirmPassword: confirmPassword) { error in
                if let error = error {
                    self?.showAlert(title: "Error".localized, message: error.localizedDescription)
                } else {
                    self?.showAlert(title: "Success".localized, message: "Password successfully updated".localized)
                }
            }
        }

        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }

    @objc private func saveTapped() {
        viewModel.updateFullName(fullNameTextField.text ?? "")
    }
    
    @objc private func logoutTapped() {
        let alert = UIAlertController(title: "Exit".localized, message: "Are you sure you want to go out?".localized, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
        alert.addAction(UIAlertAction(title: "Exit".localized, style: .destructive) { [weak self] _ in
              self?.viewModel.logout()
          })
          present(alert, animated: true)
      }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let selectedImage = info[.originalImage] as? UIImage {
            viewModel.updateAvatar(selectedImage)
        }
    }
}

