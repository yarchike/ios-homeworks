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
        return imageView
    }()

    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.text = "Полное имя"
        return label
    }()

    private lazy var fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите полное имя"
        textField.borderStyle = .roundedRect
        textField.isHidden = true // Изначально скрыто
        return textField
    }()

    private lazy var editFullNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить", for: .normal)
        button.addTarget(self, action: #selector(editFullNameTapped), for: .touchUpInside)
        return button
    }()

    private lazy var updatePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Изменить пароль", for: .normal)
        button.addTarget(self, action: #selector(updatePasswordTapped), for: .touchUpInside)
        return button
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
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
        setupView()
        bindViewModel()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground

        view.addSubview(avatarImageView)
        view.addSubview(fullNameLabel)
        view.addSubview(fullNameTextField)
        view.addSubview(editFullNameButton)
        view.addSubview(updatePasswordButton)
        view.addSubview(saveButton)

        // Отключаем автолейаут для добавленных элементов
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameTextField.translatesAutoresizingMaskIntoConstraints = false
        editFullNameButton.translatesAutoresizingMaskIntoConstraints = false
        updatePasswordButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        // Констрейнты для аватарки
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Констрейнты для лейбла с полным именем
        NSLayoutConstraint.activate([
            fullNameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            fullNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fullNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        // Констрейнты для поля ввода полного имени
        NSLayoutConstraint.activate([
            fullNameTextField.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 10),
            fullNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fullNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            fullNameTextField.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Констрейнты для кнопки "Редактировать полное имя"
        NSLayoutConstraint.activate([
            editFullNameButton.topAnchor.constraint(equalTo: fullNameTextField.bottomAnchor, constant: 10),
            editFullNameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        // Констрейнты для кнопки изменения пароля
        NSLayoutConstraint.activate([
            updatePasswordButton.topAnchor.constraint(equalTo: editFullNameButton.bottomAnchor, constant: 20),
            updatePasswordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            updatePasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            updatePasswordButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Констрейнты для кнопки сохранения
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: updatePasswordButton.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func bindViewModel() {
        viewModel.onSettingsUpdated = { [weak self] in
            self?.avatarImageView.image = self?.viewModel.avatar
            self?.fullNameLabel.text = self?.viewModel.fullName
            self?.fullNameTextField.text = self?.viewModel.fullName
        }

        viewModel.onError = { [weak self] error in
            self?.showAlert(title: "Ошибка", message: error)
        }
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
        editFullNameButton.setTitle("Отмена", for: .normal)
        editFullNameButton.removeTarget(self, action: #selector(editFullNameTapped), for: .touchUpInside)
        editFullNameButton.addTarget(self, action: #selector(cancelEditFullNameTapped), for: .touchUpInside)
    }

    @objc private func cancelEditFullNameTapped() {
        fullNameTextField.isHidden = true
        fullNameLabel.isHidden = false
        editFullNameButton.setTitle("Изменить", for: .normal)
        editFullNameButton.removeTarget(self, action: #selector(cancelEditFullNameTapped), for: .touchUpInside)
        editFullNameButton.addTarget(self, action: #selector(editFullNameTapped), for: .touchUpInside)
    }

    @objc private func updatePasswordTapped() {
        let alert = UIAlertController(title: "Изменить пароль", message: "Введите новый пароль", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Новый пароль"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { textField in
            textField.placeholder = "Повторите новый пароль"
            textField.isSecureTextEntry = true
        }

        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self] _ in
            guard let newPassword = alert.textFields?[0].text, let confirmPassword = alert.textFields?[1].text else { return }
            self?.viewModel.updatePassword(newPassword, confirmPassword: confirmPassword) { error in
                if let error = error {
                    self?.showAlert(title: "Ошибка", message: error.localizedDescription)
                } else {
                    self?.showAlert(title: "Успех", message: "Пароль успешно обновлён")
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
