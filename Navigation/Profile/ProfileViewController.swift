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
        let headerView = ProfileHeaderView()
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

