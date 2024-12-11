    import UIKit
    import FirebaseAuth
    import StorageService

    class ProfileViewController: UIViewController {
        
        var routeToPhoto: () -> () = {}
        
        var routeToLogin: () -> () = {}
        
        var routeToCreatePost: () -> () = {}

        var user: User?
        
        private var viewModel: ProfileViewModel
        
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
        init(viewModel: ProfileViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupView()
            addSubviews()
            setupConstraints()
            tuneTableView()
            bindViewModel()
            initButtonCreatePost()
            viewModel.checkAuth()
            viewModel.loadPosts()
            viewModel.loadPhoto()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            // Проверяем авторизацию
            viewModel.checkAuth()
            
            // Загружаем посты и фото
            viewModel.loadPosts()
            viewModel.loadPhoto()
        }

        
        // MARK: - Private
        
        private func setupView() {
            view.backgroundColor = .customBackgroundColor
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
        private func checkAutch(){
            if(Auth.auth().currentUser == nil){
                routeToLogin()
            }
        }
        func initButtonCreatePost(){
            let rightButton = UIButton(type: .system)
            rightButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
            rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)

            let rightBarButtonItem = UIBarButtonItem(customView: rightButton)
            navigationItem.rightBarButtonItem = rightBarButtonItem
        }

        // Действие на нажатие кнопки
        @objc private func rightButtonTapped() {
            routeToCreatePost()
        }
    
        
        private func tuneTableView() {
            let headerView = ProfileHeaderView()
            tableView.setAndLayout(headerView: headerView)
            tableView.tableFooterView = UIView()
            if #available(iOS 15.0, *) {
                tableView.sectionHeaderTopPadding = 0.0
            }
            
            tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.cellId)
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
            return viewModel.posts.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if(indexPath.section == 0){
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: CellReuseID.photo.rawValue,
                    for: indexPath
                ) as? PhotosTableViewCell else {
                    fatalError("could not dequeueReusableCell")
                }
                cell.buttonTapCallback = routeToPhoto
                cell.photos = viewModel.photos
                cell.update()
                
                return cell
            }
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
            
            cell.update(with: viewModel.posts[indexPath.row])
            
            return cell
        }
        
        func numberOfSections(
            in tableView: UITableView
        ) -> Int {
            2
        }
        
        @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            if let cell = gesture.view as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
        
               // LikeDataManager.shared.addLikePost(post: data[indexPath.row])
            }
        }
        
        private func bindViewModel() {
            viewModel.onUserUpdated = { [weak self] in
                guard let self = self else { return }
                if let user = self.viewModel.user {
                    // Обновление заголовка профиля
                    let headerView = self.tableView.tableHeaderView as? ProfileHeaderView
                    headerView?.setupProfile(user: user)
                }
            }
            viewModel.onPostsUpdated = { [weak self] in
                self?.tableView.reloadData()
            }
            viewModel.onPhotoUpdated = { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
        }
        
        
    }

    extension ProfileViewController: UITableViewDelegate {}

