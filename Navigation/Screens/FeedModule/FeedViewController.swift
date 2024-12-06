//
//  FeedViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 14.01.2024.
//

import UIKit
import StorageService

class FeedViewController: UIViewController {
    
    
    private var viewModel: FeedVMProtocol
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableFooterView = UIView()
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        return tableView
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    
    
       private lazy var refreshControl: UIRefreshControl = {
           let control = UIRefreshControl()
           control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
           return control
       }()
    

    
    
    init(viewModel: FeedVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        view.backgroundColor = .customBackgroundColor
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchPosts()
    }
    
    
    
    private func bindViewModel() {
        viewModel.onPostsUpdated = { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.refreshControl.endRefreshing()
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] errorMessage in
            self?.activityIndicator.stopAnimating()
            self?.refreshControl.endRefreshing()
            self?.tableView.isHidden = true
            self?.showErrorAlert(message: errorMessage)
        }
    }
    @objc private func handleRefresh() {
            viewModel.fetchPosts()
        }
    
    private func showErrorAlert(message: String) {
          let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] _ in
              self?.viewModel.fetchPosts()
          }))
          alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
          present(alert, animated: true)
      }
    
    
}

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.cellId,
            for: indexPath
        ) as? PostTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        if cell.gestureRecognizers == nil {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
            tapGesture.numberOfTapsRequired = 2
            cell.addGestureRecognizer(tapGesture)
        }
        
        let post = viewModel.posts[indexPath.row]
        cell.update(with: post)
        
        return cell
    }
    
    
    @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            viewModel.likePost(at: indexPath.row) // Вызываем метод из ViewModel для лайка
        }
    }
}


extension FeedViewController: UITableViewDelegate {}

