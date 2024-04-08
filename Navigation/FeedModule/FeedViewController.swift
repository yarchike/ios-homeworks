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
    
    let feedModel = FeedModel()
    
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
    
    
    private lazy var checkGuessTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .lightGray
        return textField
    }()
    
    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(title: "Check Guess", titleColor: .white)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .blue
        button.setupTapButton{
            if(self.checkGuessTextField.text != nil && self.feedModel.check(input: self.checkGuessTextField.text!)){
                self.checkGuessLabel.textColor = .green
                self.checkGuessLabel.text = "success"
            }else{
                self.checkGuessLabel.textColor = .red
                self.checkGuessLabel.text = "failed"
            }
        }
        return button
    }()
    
    private lazy var checkGuessLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    
    
    private lazy var stackView: UIStackView = { [unowned self] in
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.addArrangedSubview(self.buttonOne)
        stackView.addArrangedSubview(self.buttonTwo)
        
        stackView.addArrangedSubview(self.checkGuessTextField)
        stackView.addArrangedSubview(self.checkGuessButton)
        stackView.addArrangedSubview(self.checkGuessLabel)
    
        
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
