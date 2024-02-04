import UIKit

class PostTableViewCell: UITableViewCell {
    
    
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
    
    let contantTextView: UILabel = {
        let labelView = UILabel()
        labelView.backgroundColor = .white
        labelView.numberOfLines = 0
        labelView.textColor = .systemGray
        labelView.font.withSize(14)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    
    let likesLableView: UILabel = {
        let labelView = UILabel()
        labelView.backgroundColor = .white
        labelView.textColor = .black
        labelView.font.withSize(16)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    
    let viewsLableView: UILabel = {
        let labelView = UILabel()
        labelView.backgroundColor = .white
        labelView.textColor = .black
        labelView.font.withSize(16)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    }()
    
    
    
    override var intrinsicContentSize: CGSize {
        CGSize(
            width: UIView.noIntrinsicMetric,
            height: 1000
        )
    }
    
    // MARK: - Lifecycle
    
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
        contentView.addSubview(contantTextView)
        contentView.addSubview(likesLableView)
        contentView.addSubview(viewsLableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            contantImageView.topAnchor.constraint(equalTo: labelView.bottomAnchor,constant: 16),
            contantImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            contantImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
         
            contantTextView.topAnchor.constraint(equalTo: contantImageView.bottomAnchor, constant: 16),
            contantTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contantTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            likesLableView.topAnchor.constraint(equalTo: contantTextView.bottomAnchor, constant: 16),
            likesLableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -16),
            likesLableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            viewsLableView.topAnchor.constraint(equalTo: contantTextView.bottomAnchor, constant: 16),
            viewsLableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -16),
            viewsLableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
            
        ])
    }
    
    
    func update(_ model: Post) {
        labelView.text = model.author
        contantImageView.image = UIImage(named: model.image)
        contantTextView.text = model.description
        likesLableView.text = "Likes: \(model.likes)"
        viewsLableView.text = "Views: \(model.views)"
    }
}
