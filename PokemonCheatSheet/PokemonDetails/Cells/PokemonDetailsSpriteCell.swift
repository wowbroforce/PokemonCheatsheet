//
//  PokemonDetailsSpriteCell.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/8/21.
//

import Foundation
import UIKit
import Domain

final class PokemonDetailsSpriteCell: UITableViewCell {
    let spriteView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        NSLayoutConstraint.activate([
            spriteView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            spriteView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            spriteView.topAnchor.constraint(equalTo: contentView.topAnchor),
            spriteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
