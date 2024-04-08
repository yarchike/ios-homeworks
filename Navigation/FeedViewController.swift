//
//  FeedViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 14.01.2024.
//

import UIKit
import StorageService

class FeedViewController: UIViewController {
    
    var post = Post.make()[0]
    
    private lazy var buttonOne: CustomButton = {
        let button = CustomButton(title: "Открыть пост", titleColor: .systemBlue)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setupTapButton{
            self.buttonPressed()
        }
        return button
    }()
    
    private lazy var buttonTwo: CustomButton = {
        let button = CustomButton(title: "Открыть пост 2", titleColor: .systemBlue)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setupTapButton{
            self.buttonPressed()
        }
        return button
    }()
    
    private lazy var stackView: UIStackView = { [unowned self] in
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 10.0
        
        stackView.addArrangedSubview(self.buttonOne)
        stackView.addArrangedSubview(self.buttonTwo)
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(stackView)
        setupContraints()
        
        
    }
    
    func setupContraints(){
        let safeAreaGuide = view.safeAreaLayoutGuide
        let constraint = [
            stackView.centerXAnchor.constraint(equalTo: safeAreaGuide.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: safeAreaGuide.centerYAnchor)
        ]
        NSLayoutConstraint.activate(constraint)
    }
    
     func buttonPressed() {
        let postViewController = PostViewController()
        
        postViewController.postTitle = post.author
        
        self.navigationController?.pushViewController(postViewController, animated: true)
        
        
        
    }
    
}
