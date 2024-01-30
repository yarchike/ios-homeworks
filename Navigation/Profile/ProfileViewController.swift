//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 23.01.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let profileViewHeaderView = ProfileHeaderView()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Click me", for: .normal)
        button.backgroundColor  = UIColor.systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        title = "Profile"
        
    }
    
    override func viewWillLayoutSubviews() {
        
        profileViewHeaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileViewHeaderView)
        view.addSubview(button)
        
        setupContraints()
        
    }
    
    func setupContraints(){
        let safeAreaGuide = view.safeAreaLayoutGuide
        let constraint = [
            profileViewHeaderView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 0),
            profileViewHeaderView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 0),
            profileViewHeaderView.heightAnchor.constraint(equalToConstant: 220),
            
            button.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 0),
            button.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: 0),
            button.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: 0)
        ]
        NSLayoutConstraint.activate(constraint)
    }
    
    
    
}
