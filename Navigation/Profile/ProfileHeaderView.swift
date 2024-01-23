//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 23.01.2024.
//

import UIKit

class ProfileHeaderView : UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
   
        
    
        let avatarView = UIImageView(image: UIImage(named: "cat"))
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.frame = CGRect(x: 16, y: 66, width: 100, height: 100)
        avatarView.layer.cornerRadius = 50
        avatarView.clipsToBounds = true
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.layer.borderWidth = 3
        
        
        let nameView = UILabel()
        nameView.translatesAutoresizingMaskIntoConstraints = false
        nameView.frame = CGRect(x: 132, y: 37, width: 100, height: 100)
        nameView.text = "Hipster Cat"
        nameView.font = UIFont.boldSystemFont(ofSize: 18.0)
        nameView.textColor = .black
        
        let statusView = UILabel()
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.frame = CGRect(x: 132, y: 67, width: 100, height: 100)
        statusView.text = "Where"
        statusView.font = statusView.font.withSize(14)
        statusView.textColor = .gray
    
        
        addSubview(avatarView)
        addSubview(nameView)
        addSubview(statusView)
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            }
