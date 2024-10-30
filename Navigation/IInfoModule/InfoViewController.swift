//
//  InfoViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 14.01.2024.
//

import UIKit

class InfoViewController: UIViewController {
    
    var residentsPlanet : [ResidentPlanet] = []
    
    
    
    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open important information".localized, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    
    private lazy var labelView: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.text = "Loading".localized + "..."
        return labelView
    }()
    
    private lazy var palnetLabelView: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.text = "Loading".localized + "..."
        return labelView
    }()
    
    private lazy var namePlanetLabel: UILabel = {
        let labelView = UILabel()
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.text = "Loading".localized + "..."
        return labelView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews()
        setupConstraints()
        tuneTableView()
        loadUser()
        getPlaent()
        
    }
    
    private func addSubviews() {
        view.addSubview(actionButton)
        
        view.addSubview(labelView)
        view.addSubview(palnetLabelView)
        view.addSubview(namePlanetLabel)
        view.addSubview(activityIndicator)
        
        view.addSubview(tableView)
        
        actionButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        
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
            actionButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            actionButton.heightAnchor.constraint(equalToConstant: 20.0),
            
            
            labelView.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 16),
            labelView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            labelView.heightAnchor.constraint(equalToConstant: 20.0),
            
            palnetLabelView.topAnchor.constraint(equalTo: labelView.bottomAnchor, constant: 16),
            palnetLabelView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            palnetLabelView.heightAnchor.constraint(equalToConstant: 20.0),
            
            namePlanetLabel.topAnchor.constraint(equalTo: palnetLabelView.bottomAnchor, constant: 16),
            namePlanetLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            namePlanetLabel.heightAnchor.constraint(equalToConstant: 20.0),
            
            tableView.topAnchor.constraint(equalTo: namePlanetLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 20.0
            ),
            tableView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -20.0
            ),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            
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
    
    private func tuneTableView() {
        
        tableView.register(InfoTableViewCell.self, forCellReuseIdentifier: InfoTableViewCell.cellId)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func loadUser(){
        activityIndicator.startAnimating()
        NetworkManager.shared.getUser{ [weak self] result in
            switch result {
                
            case .success(let result):
                DispatchQueue.main.async{ [weak self] in
                    self?.labelView.text = result
                    self?.activityIndicator.stopAnimating()
                }
                
            case .failure(_):
                DispatchQueue.main.async{ [weak self] in
                    self?.labelView.text = "Loading error".localized
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func getPlaent(){
        activityIndicator.startAnimating()
        NetworkManager.shared.getPlanet{ [weak self] result in
            switch result {
                
            case .success(let planet):
                DispatchQueue.main.async{ [weak self] in
                    self?.palnetLabelView.text = planet.orbitalPeriod
                    self?.namePlanetLabel.text = planet.name
                    self?.activityIndicator.stopAnimating()
                    self?.getResidentsPlanet(planet: planet)
                }
                
            case .failure(_):
                DispatchQueue.main.async{ [weak self] in
                    self?.labelView.text = "Loading error".localized
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Error".localized, message: "Fix the error immediately".localized, preferredStyle: .alert)
        let actionOne = UIAlertAction(title: "Eliminate".localized, style: .default, handler: action)
        let actionTwo = UIAlertAction(title: "Not a critical error".localized, style: .default, handler: action)
        alertController.addAction(actionOne)
        alertController.addAction(actionTwo)
        present(alertController, animated:true)
    }
    func action(alertAction: UIAlertAction){
        print(alertAction.title as Any)
    }
    
    
    func getResidentsPlanet(planet: Planet){
        
        NetworkManager.shared.getResidentsPlanet(planet: planet){ result in
            switch result{
                
            case .success(let residents):
                DispatchQueue.main.async {
                    self.residentsPlanet = residents
                    self.tableView.reloadData()
                }
            case .failure(_):
                break
            }
            
        }
    }
    
}

extension InfoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return residentsPlanet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: InfoTableViewCell.cellId,
                for: indexPath
            ) as? InfoTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            cell.update(residentsPlanet[indexPath.row])
            
            return cell
    }
    
}

extension InfoViewController: UITableViewDelegate {}
