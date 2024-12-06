import UIKit
import iOSIntPackage
import StorageService

class PostTableViewCell: UITableViewCell {
    
    static let cellId = "PostTableViewCell"
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .customTextColor
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .customTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .customTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .customTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        contentView.backgroundColor = .customBackgroundColor
        accessoryType = .none
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(contentImageView)
        contentView.addSubview(postDescriptionLabel)
        contentView.addSubview(likesLabel)
        contentView.addSubview(viewsLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            authorLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            contentImageView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            contentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),
            
            postDescriptionLabel.topAnchor.constraint(equalTo: contentImageView.bottomAnchor, constant: 12),
            postDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            postDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            likesLabel.topAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor, constant: 12),
            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            viewsLabel.centerYAnchor.constraint(equalTo: likesLabel.centerYAnchor),
            viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Configuration
    
    func update(with model: Post) {
        avatarImageView.loadImageFromStoragePath(model.author.urlImage)
        authorLabel.text = model.author.name
        contentImageView.loadImageFromStoragePath(model.urlImage)
        postDescriptionLabel.text = model.postDescription
        likesLabel.text = "Likes: \(model.likes)"

    }
}
