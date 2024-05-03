//
//  VideoViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 25.04.2024.
//

import UIKit
import AVFoundation
import AVKit

class VideoViewController: UIViewController {
    
    let videos = Video.make()
    
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
        setupView()
        addSubviews()
        setupConstraints()
        tuneTableView()
        
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            
        ])
        
    }
    
    private func tuneTableView() {
        tableView.register(VideoViewCell.self, forCellReuseIdentifier: VideoViewCell.cellId)
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
}

extension VideoViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: VideoViewCell.cellId,
            for: indexPath
        ) as? VideoViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        cell.update(videos[indexPath.row])
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: videos[indexPath.row].url)
        
        if let url = url {
            let player = AVPlayer(url: url)
            
            let controller = AVPlayerViewController()
            controller.player = player
            
            present(controller, animated: true) {
                player.play()
            }
        }
    }
    
}

extension VideoViewController: UITableViewDelegate {}

