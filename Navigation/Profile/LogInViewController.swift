//
//  LogInViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 30.01.2024.
//

import UIKit

class LogInViewController: UIViewController {
    
    var loginText = ""
    var passwordText = ""

    var countErrors = 0
    
    
    var routeToProfile: ((User) -> ())?
    
    private let localAuthorizationService = LocalAuthorizationService()

    
    var userService: UserService
    var loginDelegate: LoginViewControllerDelegate
    
    init(userService: UserService, delegate: LoginViewControllerDelegate) {
        self.userService = userService
        self.loginDelegate = delegate
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
        textField.textColor = .black
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
        textField.textColor = .black
        textField.returnKeyType = UIReturnKeyType.done
        textField.autocapitalizationType = .none
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(passwordTextChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var loginButtonView: CustomButton = {
        let button = CustomButton(title: "Log In", titleColor: .white){
            self.buttonPressed()
        }
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor(named: "blue_pixel")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var biometricAuthButton: CustomButton = {
        let button = CustomButton(title: "Авторизация по биометрии", titleColor: .white){
            self.buttonPressed()
        }
        switch localAuthorizationService.biometricType {
             case .faceID:
                button.setImage(UIImage(systemName: "faceid"), for: .normal)
             case .touchID:
                button.setImage(UIImage(systemName: "touchid"), for: .normal)
             default:
                button.setImage(nil, for: .normal)
             }
    
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
//    lazy var findPasswordButtonView: CustomButton = {
//        let button = CustomButton(title: "Подобрать пароль", titleColor: .white){
//            self.brutePassword()
//        }
//        button.clipsToBounds = true
//        button.layer.cornerRadius = 10
//        button.backgroundColor = UIColor(named: "blue_pixel")
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
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
#if DEBUG
        userService = TestUserService()
#else
        userService = CurrentUserService()
#endif
        
        setupView()
        addSubviews()
        setupConstraints()
        setupContentOfScrollView()
        
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
        contentView.addSubview(biometricAuthButton)
        //contentView.addSubview(findPasswordButtonView)
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
            
            biometricAuthButton.topAnchor.constraint(equalTo: loginButtonView.bottomAnchor, constant: 16),
            biometricAuthButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            biometricAuthButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            biometricAuthButton.heightAnchor.constraint(equalToConstant: 50),
            
            timeLabel.topAnchor.constraint(equalTo: loginButtonView.bottomAnchor, constant: 16),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            timeLabel.heightAnchor.constraint(equalToConstant: 50),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        
        
    }
    
    
    func brutePassword(){
        loginView.text = userService.user.login
        loginText = userService.user.login
        let bruteForceService = BruteForceService()
        activityIndicator.startAnimating()
        //findPasswordButtonView.isEnabled = false
        let queue = DispatchQueue(label: "bruteForce", qos:
        .default)
        queue.async {
            let password = bruteForceService.bruteForce{password in
                var truePassword = false
                do{
                   try self.loginDelegate.check(login: self.userService.user.login, password: password){ result in
                        switch result{
                        case .success(_):
                            break
                         //   truePassword = result
                        case .failure(_):
                            truePassword  = false
                        }
                        
                    }
                }
                catch {
                    truePassword = false
                }
                return truePassword
            }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                //self.findPasswordButtonView.isEnabled = true
                self.passwordView.isSecureTextEntry = false
                self.passwordView.text = password
                self.passwordText = password
                DispatchQueue.global().asyncAfter(deadline: .now() + 3, execute: { [weak self] in
                    guard let self else { return }
                    DispatchQueue.main.async {
                        self.buttonPressed()
                    }
                })
            }
        }
        
    }
    
    private func biometricAuthTapped() {
        localAuthorizationService.authorizeIfPossible { [weak self] success, error in
            if success {
                print("Авторизация успешна")
            } else {
                let errorMessage = error?.localizedDescription ?? "Неизвестная ошибка"
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    private func showAlert(message: String) {
          let alert = UIAlertController(title: "Ошибка авторизации", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "ОК", style: .default))
          present(alert, animated: true)
      }
    
    func buttonPressed() {
        if(!passwordText.isEmpty && !loginText.isEmpty){
            do{
                try loginDelegate.check(login: loginText, password: passwordText){result in
                    switch result {
                    case .success(_):
                        self.countErrors = 0
                        let profileViewController = ProfileViewController()
                        self.navigationController?.pushViewController(profileViewController, animated: true)
                    case .failure(let error):
                        self.handleError(with: error)
                    }
                }
            }
            catch ApiError.notFound{
                countErrors += 1
                showErrorAlert(text: "Нету такого пользователя")
            }
            catch ApiError.badRequest{
                showErrorAlert(text: "Нет доступа к серверу")
            }
            catch{
                showErrorAlert(text: "Неизвестрая ошибка")
            }
        }else{
            countErrors += 1
            showErrorAlert(text: "Не введен логин или пароль")
        }
        if(countErrors >= 3){
            blockLogin()
        }
        
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
        if let text = textField.text {
            loginText =  text
        }
    }
    
    @objc func passwordTextChanged(_ textField: UITextField){
        if let text = textField.text {
            passwordText =  text
        }
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
        let alert = UIAlertController(title: "Ошибка", message: text, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    private func handleError(with error: ApiError) {
        switch error{
        case .unAuth:
            self.countErrors += 1
            self.showErrorAlert(text: "Не верный логин или пароль")
        case .badRequest:
            self.showErrorAlert(text: "Ошибка сервера")
        case .notFound:
            self.showErrorAlert(text: "Неизвестная ошибка")
        case .unowned:
            self.showErrorAlert(text: "Неизвестная ошибка")
        case .forbidden:
            self.showErrorAlert(text: "Неизвестная ошибка")
        case .authError(let message):
            self.showErrorAlert(text: message)
        }
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
