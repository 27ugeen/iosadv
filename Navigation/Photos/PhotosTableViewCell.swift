//
//  PhotosTableViewCell.swift
//  Navigation
//
//  Created by GiN Eugene on 08.08.2021.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
//MARK: - Props
    let photoWidth = (UIScreen.main.bounds.width - 48) / 4
    
//MARK: - Localization
    let photosCellLabel = "photos_cell_label".localized()
    
//MARK: - Subviews
    lazy var titleLableView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = Palette.mainTextColor
        label.text = photosCellLabel
        return label
    }()
    
    lazy var buttonView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = Palette.mainTextColor
        button.addTarget(self, action: #selector(tappedNextImage), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var photosPreview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: PhotosCollectionViewCell.self))
        
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
//MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - objc methods
    @objc func tappedNextImage() {
        if buttonView.currentBackgroundImage == UIImage(systemName: "arrow.right") {
            let IndexPath = NSIndexPath(item: 7, section: 0)
            photosPreview.scrollToItem(at: IndexPath as IndexPath, at: .right, animated: true)
            buttonView.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
        } else {
            let IndexPath = NSIndexPath(item: 0, section: 0)
            photosPreview.scrollToItem(at: IndexPath as IndexPath, at: .left, animated: true)
            buttonView.setBackgroundImage(UIImage(systemName: "arrow.right"), for: .normal)
        }
        
    }
}
//MARK: - setupViews
extension PhotosTableViewCell {
    private func setupViews() {
        contentView.addSubview(titleLableView)
        contentView.addSubview(buttonView)
        contentView.addSubview(photosPreview)
        
        let constraints = [
            titleLableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 12),
            
            buttonView.centerYAnchor.constraint(equalTo: titleLableView.centerYAnchor),
            buttonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            buttonView.heightAnchor.constraint(equalToConstant: 24),
            
            photosPreview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  12),
            photosPreview.topAnchor.constraint(equalTo: titleLableView.bottomAnchor, constant: 12),
            photosPreview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            photosPreview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            photosPreview.heightAnchor.constraint(equalToConstant: photoWidth)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
//MARK: - UICollectionViewDataSource
extension PhotosTableViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return PhotosStorage.tableModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosPreview.dequeueReusableCell(withReuseIdentifier: String(describing: PhotosCollectionViewCell.self), for: indexPath) as! PhotosCollectionViewCell
        cell.imageView.image = ImgStorage.arrImg[indexPath.item]
        return cell
    }
}
//MARK: - UICollectionViewDelegateFlowLayout
extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: photoWidth, height: photoWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: -12, left: 0, bottom: -12, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Photos: item: \(indexPath.item)")
    }
}
