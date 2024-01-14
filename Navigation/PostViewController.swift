//
//  PostViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 14.01.2024.
//

import UIKit

class PostViewController: UIViewController {
    
    
    
    var postTitle:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        title = postTitle
        view.backgroundColor = .systemGray
        let navigateButton = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(buttonPressed))
        self.navigationItem.rightBarButtonItem = navigateButton
    
    }
    
    @objc func buttonPressed() {
        let infoViewController = InfoViewController()
        self.navigationController?.pushViewController(infoViewController, animated: true)

    }

}
