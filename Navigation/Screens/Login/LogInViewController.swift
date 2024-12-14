//
//  LogInViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 30.01.2024.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    var loginText = ""
    var passwordText = ""
    
    var countErrors = 0
    
    let viewModel: LogInViewModel
    
    
    var routeToProfile: (() -> ()) = {}
    
    
    init(viewModel: LogInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .customBackgroundColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor =  .customBackgroundColor
        
        return contentView
    }()
    
    private lazy var logoView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    lazy var loginAndPasswordView: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 10
        uiView.clipsToBounds = true
        uiView.backgroundColor  = UIColor.systemGray6
        uiView.layer.borderColor = UIColor.lightGray.cgColor
        uiView.layer.borderWidth = 0.5
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var loginView: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.keyboardType = UIKeyboardType.default
        textField.backgroundColor  = UIColor.systemGray6
        textField.font = UIFont.boldSystemFont(ofSize: 16.0)
        textField.textColor = .customTextColor
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(loginTextChanged(_:)), for: .editingChanged)
        textField.placeholder = "Email of phone"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    lazy var lineView: UIView = {
        let uiView = UIView()
        uiView.clipsToBounds = true
        uiView.backgroundColor  = UIColor.lightGray
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var passwordView: UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.backgroundColor  = UIColor.systemGray6
        textField.font = UIFont.boldSystemFont(ofSize: 16.0)
        textField.textColor = .customTextColor
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocapitalizationType = .none
        textField.placeholder = "Password".localized
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(passwordTextChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var loginButtonView: CustomButton = {
        let button = CustomButton(title: "Log In".localized, titleColor: .white){
            self.buttonPressed()
        }
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "blue_pixel")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var regButtonView: UIButton = {
        let button = UIButton()
        button.setTitle("Register".localized, for: .normal)
        button.addTarget(self, action: #selector(openRegistration), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "blue_pixel"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let timeLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.translatesAutoresizingMaskIntoConstraints = false
        return uiLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        setupContentOfScrollView()
        bindViewModel()
        
    }
    
    private func bindViewModel() {
        viewModel.onValidationError = { [weak self] message in
            self?.showErrorAlert(text: message)
        }
        viewModel.onLoginSuccess = { [weak self] in
            self?.routeToProfile()
        }
        viewModel.onLoginBlocked = { [weak self] message in
            self?.timeLabel.text = message
        }
    }
    
    private func setupView() {
        view.backgroundColor = .customBackgroundColor
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    private func setupContentOfScrollView() {
        
        // logo
        contentView.addSubview(logoView)
        contentView.addSubview(loginAndPasswordView)
        contentView.addSubview(loginView)
        contentView.addSubview(lineView)
        loginAndPasswordView.addSubview(passwordView)
        loginAndPasswordView.addSubview(activityIndicator)
        contentView.addSubview(loginButtonView)
        contentView.addSubview(regButtonView)
        contentView.addSubview(timeLabel)
        
        
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 100),
            logoView.heightAnchor.constraint(equalToConstant: 100),
            
            loginAndPasswordView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 120),
            loginAndPasswordView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginAndPasswordView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginAndPasswordView.heightAnchor.constraint(equalToConstant: 100),
            
            loginView.topAnchor.constraint(equalTo: loginAndPasswordView.topAnchor),
            loginView.leadingAnchor.constraint(equalTo: loginAndPasswordView.leadingAnchor, constant: 8),
            loginView.trailingAnchor.constraint(equalTo: loginAndPasswordView.trailingAnchor, constant: -8),
            loginView.heightAnchor.constraint(equalToConstant: 50),
            
            lineView.topAnchor.constraint(equalTo: loginView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: loginAndPasswordView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: loginAndPasswordView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5),
            
            passwordView.topAnchor.constraint(equalTo: lineView.bottomAnchor),
            passwordView.leadingAnchor.constraint(equalTo: loginAndPasswordView.leadingAnchor, constant: 8),
            passwordView.trailingAnchor.constraint(equalTo: loginAndPasswordView.trailingAnchor, constant: -8),
            passwordView.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.topAnchor.constraint(equalTo: lineView.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: loginAndPasswordView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loginAndPasswordView.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 50),
            
            loginButtonView.topAnchor.constraint(equalTo: loginAndPasswordView.bottomAnchor, constant: 16),
            loginButtonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButtonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButtonView.heightAnchor.constraint(equalToConstant: 50),
            
            regButtonView.topAnchor.constraint(equalTo: loginButtonView.bottomAnchor, constant: 16),
            regButtonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            regButtonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            regButtonView.heightAnchor.constraint(equalToConstant: 50),
            regButtonView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            
            timeLabel.topAnchor.constraint(equalTo: regButtonView.bottomAnchor, constant: 16),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.heightAnchor.constraint(equalToConstant: 50),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        
        
    }
    
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Authorization error".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
    
    func buttonPressed() {
        viewModel.validateAndLogin()
    }
    
    func blockLogin(){
        loginButtonView.isEnabled = false
        var counter = 60
        Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true) { [weak self] timer in
                guard let self else { return }
                counter -= 1
                
                timeLabel.text = counter <= 0 ? "" : "До следующей попытки \(counter) с."
                if counter <= 0 {
                    timer.invalidate()
                    countErrors = 0
                    loginButtonView.isEnabled = true
                }
            }
        
    }
    
    @objc func loginTextChanged(_ textField: UITextField){
        viewModel.loginText = textField.text ?? ""
    }
    
    @objc func passwordTextChanged(_ textField: UITextField){
        viewModel.passwordText = textField.text ?? ""
    }
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight ?? 0.0
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset.bottom = 0.0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeKeyboardObservers()
    }
    
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    private func showErrorAlert(text: String){
        let alert = UIAlertController(title: "Error".localized, message: text, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    @objc private func openRegistration() {
        let registrationVC = RegistrationViewController()
        registrationVC.modalPresentationStyle = .formSheet
        registrationVC.modalTransitionStyle = .coverVertical
        registrationVC.routeToProfile = routeToProfile
        present(registrationVC, animated: true)
    }
    
}

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(
        _ textField: UITextField
    ) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
