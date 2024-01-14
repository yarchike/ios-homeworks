//
//  InfoViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 14.01.2024.
//

import UIKit

class InfoViewController: UIViewController {
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Открыть важную информацию", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(actionButton)

        
        let safeAreaLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            actionButton.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 20.0
            ),
            actionButton.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -20.0
            ),
            actionButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            actionButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        
        actionButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Ошибка", message: "Срочно устраните ошибку", preferredStyle: .alert)
        let actionOne = UIAlertAction(title: "Устранить", style: .default, handler: action)
        let actionTwo = UIAlertAction(title: "Не критичная ошибка", style: .default, handler: action)
        alertController.addAction(actionOne)
        alertController.addAction(actionTwo)
        present(alertController, animated:true)
    }
    func action(alertAction: UIAlertAction){
        print(alertAction.title)
    }

}
