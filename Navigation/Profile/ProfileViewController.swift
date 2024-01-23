//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 23.01.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let profileViewHeaderView = ProfileHeaderView(frame: CGRect(
        x: 100.0,
        y: 200.0,
        width: 200.0,
        height: 100.0))

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        title = "Profile"
    
        

       
    }
    
    override func viewWillLayoutSubviews() {
        profileViewHeaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileViewHeaderView)
        profileViewHeaderView.frame = view.frame
        
    }



}
