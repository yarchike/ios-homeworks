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
    
    private lazy var scrollView: UIScrollView = {
         let scrollView = UIScrollView()
         scrollView.backgroundColor = .white
         scrollView.translatesAutoresizingMaskIntoConstraints = false
         
         return scrollView
     }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        
        return contentView
    }()
    
    private lazy var logoView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
     }()

    
    lazy var loginAndPasswordView :UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 10
        uiView.clipsToBounds = true
        uiView.backgroundColor  = UIColor.systemGray6
        uiView.layer.borderColor = UIColor.lightGray.cgColor
        uiView.layer.borderWidth = 0.5
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var loginView :UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.backgroundColor  = UIColor.systemGray6
        textField.font = UIFont.boldSystemFont(ofSize: 16.0)
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(loginTextChanged(_:)), for: .editingChanged)
        textField.placeholder = "Email of phone"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var lineView :UIView = {
        let uiView = UIView()
        uiView.clipsToBounds = true
        uiView.backgroundColor  = UIColor.lightGray
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var passwordView :UITextField = {
        let textField = UITextField()
        textField.clipsToBounds = true
        textField.backgroundColor  = UIColor.systemGray6
        textField.font = UIFont.boldSystemFont(ofSize: 16.0)
        textField.textColor = .black
        textField.autocapitalizationType = .none
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(passwordTextChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    lazy var loginButtonView :CustomButton = {
        let button = CustomButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "blue_pixel")
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        setupConstraints()
        setupContentOfScrollView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
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
              scrollView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor)
          ])
          
          NSLayoutConstraint.activate([
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
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 100),
            logoView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        //login and password
        
        contentView.addSubview(loginAndPasswordView)
        
        NSLayoutConstraint.activate([
            loginAndPasswordView.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 120),
            loginAndPasswordView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginAndPasswordView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginAndPasswordView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        //login
        contentView.addSubview(loginView)
        
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalTo: loginAndPasswordView.topAnchor),
            loginView.leadingAnchor.constraint(equalTo: loginAndPasswordView.leadingAnchor, constant: 8),
            loginView.trailingAnchor.constraint(equalTo: loginAndPasswordView.trailingAnchor, constant: -8),
            loginView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //line
        contentView.addSubview(lineView)
        
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: loginView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: loginAndPasswordView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: loginAndPasswordView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        //password
        
        loginAndPasswordView.addSubview(passwordView)
        
        NSLayoutConstraint.activate([
            passwordView.topAnchor.constraint(equalTo: lineView.bottomAnchor),
            passwordView.leadingAnchor.constraint(equalTo: loginAndPasswordView.leadingAnchor, constant: 8),
            passwordView.trailingAnchor.constraint(equalTo: loginAndPasswordView.trailingAnchor, constant: -8),
            passwordView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        //button
        
        contentView.addSubview(loginButtonView)
        
        NSLayoutConstraint.activate([
            loginButtonView.topAnchor.constraint(equalTo: loginAndPasswordView.bottomAnchor, constant: 16),
            loginButtonView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButtonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButtonView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        
       }
    
    
    @objc func buttonPressed(_ sender: UIButton) {
        if(!passwordText.isEmpty && !loginText.isEmpty){
            let profileViewController = ProfileViewController()
            

            self.navigationController?.pushViewController(profileViewController, animated: true)
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

}
