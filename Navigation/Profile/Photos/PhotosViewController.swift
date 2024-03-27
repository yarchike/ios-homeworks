//
//  PhotosViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 05.02.2024.
//

import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController{
    
    var images: [UIImage] = []
    
    let imagePublisherFacade: ImagePublisherFacade = ImagePublisherFacade()
    
    private let collectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: viewLayout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(
            PhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: PhotosCollectionViewCell.identifier
        )
        
        return collectionView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        setupConstraints()
        subscribeProtocolObserver()
        addImage()
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imagePublisherFacade.removeSubscription(for: self)
        
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Photo Gallery"
    }
    
    private func addSubviews() {
        view.addSubview(collectionView)
        setupCollectionView()
    }
    
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor)
        ])
    }
    
    func subscribeProtocolObserver() {
        imagePublisherFacade.subscribe(self)
    }
    
    func addImage(){
        imagePublisherFacade.addImagesWithTimer(time: 0.5, repeat: 10, userImages: Photo.make().map{
            UIImage(named: $0.image)!
        })
    }
    
    
    
}

extension PhotosViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PhotosCollectionViewCell.identifier,
            for: indexPath) as! PhotosCollectionViewCell
        
        let image = images[indexPath.row]
        cell.setup(image: image)
        
        return cell
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    
    private enum LayoutConstant {
        static let spacing: CGFloat = 8
    }
    
    private func itemWidth(
        for width: CGFloat,
        spacing: CGFloat
    ) -> CGFloat {
        let itemsInRow: CGFloat = 3
        
        let totalSpacing: CGFloat = 2 * spacing + (itemsInRow) * spacing
        let finalWidth = (width - totalSpacing) / itemsInRow
        
        return floor(finalWidth)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = itemWidth(
            for: view.frame.width,
            spacing: LayoutConstant.spacing
        )
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(
            top: LayoutConstant.spacing,
            left: LayoutConstant.spacing,
            bottom: LayoutConstant.spacing,
            right: LayoutConstant.spacing
        )
    }
    
}

extension PhotosViewController: ImageLibrarySubscriber{
    func receive(images: [UIImage]){
        self.images = images
        collectionView.reloadData()
    }
}
