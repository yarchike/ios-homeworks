//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 23.01.2024.
//

import UIKit

class ProfileHeaderView : UIView{
    
    private var statusText: String = ""
    
    let avatarView: UIImageView = {
        let avatarView = UIImageView(image: UIImage(named: "cat"))
        avatarView.frame = CGRect(x: 16, y: 90, width: 100, height: 100)
        avatarView.layer.cornerRadius = 50
        avatarView.clipsToBounds = true
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.layer.borderWidth = 3
        return avatarView
    }()
    
    let nameView: UILabel = {
        let nameView = UILabel()
        nameView.frame = CGRect(x: 132, y: 90, width: 100, height: 30)
        nameView.text = "Hipster Cat"
        nameView.font = UIFont.boldSystemFont(ofSize: 18.0)
        nameView.textColor = .black
        return nameView
    }()
    
    let statusView: UILabel = {
        let statusView = UILabel()
        statusView.frame = CGRect(x: 132, y: 130, width: 100, height: 30)
        statusView.text = "Where"
        statusView.font = statusView.font.withSize(14)
        statusView.textColor = .gray
        return statusView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 16, y: 230, width: 380, height: 50)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Set status", for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.backgroundColor  = UIColor.systemBlue
        button.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var textField:UITextField = {
        let textField = UITextField()
        textField.frame = CGRect(x: 132, y: 160, width: 200, height: 40)
        textField.layer.cornerRadius = 12
        textField.clipsToBounds = true
        textField.backgroundColor  = UIColor.white
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.font = UIFont.boldSystemFont(ofSize: 15.0)
        textField.textColor = .black
        textField.placeholder = "Введите статус"
        textField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        return textField
    }()
    
    @objc func buttonPressed(_ sender: UIButton) {
        if !statusText.isEmpty{
            statusView.text = statusText
            textField.text = ""
        }
        
    }
    
    @objc func statusTextChanged(_ textField: UITextField){
        if let text = textField.text {
            statusText =  text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(avatarView)
        addSubview(nameView)
        addSubview(statusView)
        addSubview(button)
        addSubview(textField)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
