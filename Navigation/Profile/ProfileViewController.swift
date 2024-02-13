import UIKit

class ProfileViewController: UIViewController {
    
    fileprivate let data = Post.make()
    
    private var avatarView: UIImageView?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(
            frame: .zero,
            style: .plain
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var closeImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "xmark"))
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTap)
        )
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    
    
    private enum CellReuseID: String {
        case base = "BaseTableViewCell_ReuseID"
        case custom = "CustomTableViewCell_ReuseID"
        case photo = "PhotoTableViewCell_ReuseID"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        tuneTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    // MARK: - Private
    
    private func setupView() {
        view.backgroundColor = .white
        navigationItem.title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(backgroundView)
        view.addSubview(closeImage)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            
            backgroundView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            
            closeImage.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 16),
            closeImage.widthAnchor.constraint(equalToConstant: 30),
            closeImage.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -16),
            closeImage.heightAnchor.constraint(equalToConstant: 30),
        ])
        
    }
    
    private func tuneTableView() {
        let headerView = ProfileHeaderView()
        headerView.buttonTapCallback = animateAvatar
        tableView.setAndLayout(headerView: headerView)
        tableView.tableFooterView = UIView()
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0.0
        }
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: CellReuseID.base.rawValue)
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: CellReuseID.photo.rawValue)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func animateAvatar(_ avatarImage: UIImageView){
        self.avatarView = avatarImage
        let width = UIScreen.main.bounds.width
        let translation = width / 2 - 60
        let scale = width / 100
        UIView.animate(withDuration: 1){
            avatarImage.transform = CGAffineTransform(translationX: translation, y: translation + 100).scaledBy(x: scale, y: scale)
            self.backgroundView.alpha = 0.5
        }
        UIView.animate(withDuration: 1){
            self.closeImage.alpha = 1
    
        }
        
    
    }
    
    @objc private func didTap(gesture: UIGestureRecognizer) {
        UIView.animate(withDuration: 1){
            self.avatarView?.transform = CGAffineTransform(translationX: 0, y: 0)
            self.backgroundView.alpha = 0
            self.closeImage.alpha = 0
        }
     }
    
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CellReuseID.photo.rawValue,
                for: indexPath
            ) as? PhotosTableViewCell else {
                fatalError("could not dequeueReusableCell")
            }
            cell.buttonTapCallback = {
                let photosViewController = PhotosViewController()
                self.navigationController?.pushViewController(photosViewController, animated: true)
            }
            cell.update()
            
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CellReuseID.base.rawValue,
            for: indexPath
        ) as? PostTableViewCell else {
            fatalError("could not dequeueReusableCell")
        }
        
        cell.update(data[indexPath.row])
        
        return cell
    }
    
    func numberOfSections(
        in tableView: UITableView
    ) -> Int {
        2
    }
    
    
}

extension ProfileViewController: UITableViewDelegate {}

