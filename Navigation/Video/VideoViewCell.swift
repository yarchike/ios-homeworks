//
//  VideoViewCell.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 25.04.2024.
//

import Foundation
import UIKit
import AVFoundation



class VideoViewCell : UITableViewCell{
    
    static let cellId = "VideoViewCell"
    var video: Video? = nil
    
    let labelView: UILabel = {
        let labelView = UILabel()
        labelView.text = "Hipster Cat"
        labelView.font = UIFont.boldSystemFont(ofSize: 20.0)
        labelView.textColor = .black
        labelView.numberOfLines = 2
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    
    let contantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
    
    // MARK: - Private
    
    private func tuneView() {
        contentView.backgroundColor = .white
        accessoryType = .none
    }

    
    private func addSubviews() {
        contentView.addSubview(labelView)
        contentView.addSubview(contantImageView)

    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            contantImageView.topAnchor.constraint(equalTo: labelView.bottomAnchor,constant: 16),
            contantImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            contantImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            contantImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -16),
            
        ])
    }

    
    
    func update(_ video: Video) {
        labelView.text = video.label
        
        let queue = DispatchQueue(label: "bruteForce", qos:
        .default)
        queue.async {
            let image = self.createThumbnailOfVideoFromRemoteUrl(url:  video.url)
            DispatchQueue.main.async {
                if let image = image{
                    self.contantImageView.image = image
                }
                
            }
        }
        
    }
    
    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: url)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
          print(error.localizedDescription)
          return nil
        }
    }
    

}
