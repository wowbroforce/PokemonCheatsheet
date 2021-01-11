//
//  PokemonDetailsGalleryView.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/8/21.
//

import Foundation
import UIKit
import Domain

final class PokemonDetailsGalleryView: UITableViewCell {
    private let collectionView: UICollectionView
    private let layout = UICollectionViewFlowLayout()
    private var images: [Image] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with images: [Image]) {
        self.images = images
        
        collectionView.reloadData()
    }

    private func configureUI() {
        selectionStyle = .none

        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 96, height: 96)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Colors.systemBackground
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.edgesToSuperview(insets: .init(top: 0, left: 32, bottom: 0, right: 32))
        collectionView.heightAnchor.constraint(equalToConstant: 96).isActive = true
    }
}

extension PokemonDetailsGalleryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath) as! ImageCollectionViewCell
        cell.update(with: images[indexPath.item])
        return cell
    }
}

private final class ImageCollectionViewCell: UICollectionViewCell, CellReusable {
    static let reuseIdentifier = "ImageCollectionViewCell"
    
    private let spriteView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with image: Image) {
        spriteView.image = image
    }
    
    private func configureUI() {
        spriteView.contentMode = .scaleAspectFit
        spriteView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spriteView)
        spriteView.edgesToSuperview()
    }
}
