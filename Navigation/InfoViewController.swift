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
    
    
    private lazy var labelView: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.text = "Загрузка..."
        return labelView
    }()
    
    private lazy var palnetLabelView: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.text = "Загрузка..."
        return labelView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews()
        setupConstraints()
        
    }
    
    private func addSubviews() {
        view.addSubview(actionButton)
        
        view.addSubview(labelView)
        view.addSubview(palnetLabelView)
        
        view.addSubview(activityIndicator)
        
        actionButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        loadUser()
        getPlaent()
    }
    
    
    
    private func setupConstraints() {
        
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
            actionButton.heightAnchor.constraint(equalToConstant: 44.0),
            
            
            labelView.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 16),
            labelView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            labelView.heightAnchor.constraint(equalToConstant: 44.0),
            
            palnetLabelView.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 16),
            palnetLabelView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            palnetLabelView.heightAnchor.constraint(equalToConstant: 44.0),
            
            
            
            activityIndicator.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 20.0
            ),
            activityIndicator.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -20.0
            ),
            activityIndicator.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            activityIndicator.heightAnchor.constraint(equalToConstant: 44.0),
        ])
        
        
    }
    
    func loadUser(){
        activityIndicator.startAnimating()
        NetworkManager.getUser{ [weak self] result in
            switch result {
                
            case .success(let result):
                DispatchQueue.main.async{ [weak self] in
                    self?.labelView.text = result
                    self?.activityIndicator.stopAnimating()
                }
                
            case .failure(_):
                DispatchQueue.main.async{ [weak self] in
                    self?.labelView.text = "Ошибка загрузки"
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func getPlaent(){
        activityIndicator.startAnimating()
        NetworkManager.getPlanet{ [weak self] result in
            switch result {
                
            case .success(let planet):
                DispatchQueue.main.async{ [weak self] in
                    self?.palnetLabelView.text = planet.orbitalPeriod
                    self?.activityIndicator.stopAnimating()
                }
                
            case .failure(_):
                DispatchQueue.main.async{ [weak self] in
                    self?.labelView.text = "Ошибка загрузки"
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
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
        print(alertAction.title as Any)
    }
    
}
