//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 23.01.2024.
//

import UIKit
import SnapKit

class ProfileHeaderView : UIView{
    
    var buttonTapCallback: (_ avatarImage: UIImageView) -> () = {avatarImage in }
    
    private var statusText: String = ""
    
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: 230
        )
    }
    
    lazy var avatarImageView: UIImageView = {
        let avatarView = UIImageView(image: UIImage(named: "cat"))
        avatarView.layer.cornerRadius = 50
        avatarView.clipsToBounds = true
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.layer.borderWidth = 3
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(tapAvatar)
        )
        avatarView.addGestureRecognizer(tap)
        
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
    
    lazy var statusTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 12
        textField.clipsToBounds = true
        textField.backgroundColor  = UIColor.white
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.font = UIFont.boldSystemFont(ofSize: 15.0)
        textField.textColor = .black
        textField.placeholder = " Введите статус"
        textField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var closeImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "xmark"))
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap)
        )
        imageView.addGestureRecognizer(tap)
        return imageView
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
    
    @objc private func didTap(gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 0.5){
            self.avatarImageView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.avatarImageView.layer.cornerRadius = 50
            self.backgroundView.alpha = 0
            self.closeImage.alpha = 0
        }
     }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(setStatusButton)
        addSubview(statusTextField)
        addSubview(backgroundView)
        addSubview(closeImage)
        addSubview(avatarImageView)
        setupContraints()
        
    }
    
    
    func setupContraints(){
        
        avatarImageView.snp.makeConstraints{
            $0.height.equalTo(100)
            $0.width.equalTo(100)
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
        }
        
        fullNameLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(27)
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        statusLabel.snp.makeConstraints{
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            $0.top.equalTo(fullNameLabel.snp.bottom).offset(24)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        statusTextField.snp.makeConstraints{
            $0.top.equalTo(statusLabel.snp.bottom).offset(8)
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            $0.height.equalTo(40)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        setStatusButton.snp.makeConstraints{
            $0.top.equalTo(statusTextField.snp.bottom).offset(24)
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        backgroundView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        closeImage.snp.makeConstraints{
            $0.top.equalToSuperview().offset(16)
            $0.width.equalTo(30)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapAvatar(gesture: UIGestureRecognizer) {
        animateAvatar(gesture.view as! UIImageView)
     }
    
    func animateAvatar(_ avatarImage: UIImageView){
        let width = UIScreen.main.bounds.width
        let translation = width / 2 - 65
        let scale = width / 100
        UIView.animate(withDuration: 0.5){
            avatarImage.transform = CGAffineTransform(translationX: translation, y: translation + 100).scaledBy(x: scale, y: scale)
            self.backgroundView.alpha = 0.5
            self.backgroundView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 100, y: 100)
            avatarImage.layer.cornerRadius = 0
        }
        UIView.animate(withDuration: 0.3){
            self.closeImage.alpha = 1
    
        }
        
    
    }
    
}
