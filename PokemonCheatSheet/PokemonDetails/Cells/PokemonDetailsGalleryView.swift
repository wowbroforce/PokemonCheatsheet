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
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 96, height: 96)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier)
        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 96)
        ])
    }
}

extension PokemonDetailsGalleryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier, for: indexPath)
    }
}

extension PokemonDetailsGalleryView: UICollectionViewDelegate {
}

private final class ImageCollectionViewCell: UICollectionViewCell, CellReusable {
    static let reuseIdentifier = "ImageCollectionViewCell"
    
    private let spriteView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        NSLayoutConstraint.activate([
            spriteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spriteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spriteView.topAnchor.constraint(equalTo: contentView.topAnchor),
            spriteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
