//
//  InfoTableViewCell.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 08.05.2024.
//

import Foundation
import UIKit


class InfoTableViewCell : UITableViewCell{
    static let cellId = "InfoTableViewCell"
    
    let labelView: UILabel = {
        let labelView = UILabel()
        labelView.text = "Name"
        labelView.font = UIFont.boldSystemFont(ofSize: 20.0)
        labelView.textColor = .black
        labelView.numberOfLines = 2
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: 1000
        )
    }
    
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        tuneView()
        addSubviews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func tuneView() {
        contentView.backgroundColor = .white
        accessoryType = .none
    }
    
    
    private func addSubviews() {
        contentView.addSubview(labelView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -16),
            
        ])
    }
    
    func update(_ residentPlanet: ResidentPlanet) {
        labelView.text = residentPlanet.name
    }
}
