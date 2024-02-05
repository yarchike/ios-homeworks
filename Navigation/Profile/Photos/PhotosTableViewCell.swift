import UIKit


class PhotosTableViewCell: UITableViewCell{
    
    var buttonTapCallback: () -> () = {}
    
    fileprivate lazy var photos: [Photo] = Photo.make()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24.0)
        label.textColor = .black
        label.text = "Photo"
        return label
    }()
    
    private lazy var arrowButton: UIButton = {
        let button =  UIButton()
        button.setImage(UIImage(systemName: "arrow.forward"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: viewLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(
            PhotosCell.self,
            forCellWithReuseIdentifier: PhotosCell.identifier
        )
        
        return collectionView
    }()
    
    
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
        selectionStyle = .none
        backgroundColor = .white
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowButton)
        contentView.addSubview(collectionView)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 12
            ),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            arrowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            arrowButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowButton.widthAnchor.constraint(equalToConstant: 50),
            arrowButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            
            
            
            collectionView.topAnchor.constraint(equalTo: arrowButton.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(
                equalTo: leadingAnchor, constant: 12
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: trailingAnchor, constant: -4
            ),
            
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            collectionView.heightAnchor.constraint(equalToConstant:60)
        ])
    }
    
    @objc private func didTapButton(_ sender: UIResponder) {
        buttonTapCallback()
    }
    
    func update(){}
}

extension PhotosTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotosCell.identifier,
            for: indexPath) as! PhotosCell
        
        let photo = photos[indexPath.row]
        cell.setup(photo: photo)
        
        return cell
    }
}

extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    
    private enum LayoutConstant {
        static let spacing: CGFloat = 8
        static let itemHeight: CGFloat = 50
    }
    
    private func itemWidth(
        for width: CGFloat,
        spacing: CGFloat
    ) -> CGFloat {
        let itemsInRow: CGFloat = 4
        
        let totalSpacing: CGFloat = 4 * spacing + (itemsInRow) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        
        return floor(finalWidth)
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = itemWidth(
            for: contentView.frame.width,
            spacing: LayoutConstant.spacing
        )
        
        return CGSize(width: width, height: LayoutConstant.itemHeight)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 8
        )
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        buttonTapCallback()
    }
}

