//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 23.01.2024.
//

import UIKit

class ProfileHeaderView : UIView{
    
    private var statusText: String = ""
    
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: 230
        )
    }
    
    let avatarImageView: UIImageView = {
        let avatarView = UIImageView(image: UIImage(named: "cat"))
        avatarView.layer.cornerRadius = 50
        avatarView.clipsToBounds = true
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.layer.borderWidth = 3
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        return avatarView
    }()
    
    let fullNameLabel: UILabel = {
        let nameView = UILabel()
        nameView.text = "Hipster Cat"
        nameView.font = UIFont.boldSystemFont(ofSize: 18.0)
        nameView.textColor = .black
        nameView.translatesAutoresizingMaskIntoConstraints = false
        return nameView
    }()
    
    let statusLabel: UILabel = {
        let statusView = UILabel()
        statusView.text = "Where"
        statusView.font = statusView.font.withSize(14)
        statusView.textColor = .gray
        statusView.translatesAutoresizingMaskIntoConstraints = false
        return statusView
    }()
    
    lazy var setStatusButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Set status", for: .normal)
        button.layer.cornerRadius = 4
        button.backgroundColor  = UIColor.systemBlue
        button.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var statusTextField:UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 12
        textField.clipsToBounds = true
        textField.backgroundColor  = UIColor.white
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.font = UIFont.boldSystemFont(ofSize: 15.0)
        textField.textColor = .black
        textField.placeholder = "Введите статус"
        textField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    @objc func buttonPressed(_ sender: UIButton) {
        if !statusText.isEmpty{
            statusLabel.text = statusText
            statusTextField.text = ""
        }
        
    }
    
    @objc func statusTextChanged(_ textField: UITextField){
        if let text = textField.text {
            statusText =  text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(setStatusButton)
        addSubview(statusTextField)
        setupContraints()
        
    }
    
    
    func setupContraints(){
        let safeAreaGuide = safeAreaLayoutGuide
        let constraint = [
            avatarImageView.heightAnchor.constraint(equalToConstant: 100.0),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100.0),
            avatarImageView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 16),
            
            fullNameLabel.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 27),
            fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            fullNameLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            
            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            statusLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 24),
            statusLabel.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            
            statusTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            statusTextField.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            statusTextField.heightAnchor.constraint(equalToConstant: 40.0),
            statusTextField.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            
            setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant:24),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50.0),
            setStatusButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 16),
            setStatusButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16)
            
        ]
        NSLayoutConstraint.activate(constraint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
