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
        selectionStyle = .none

        spriteView.contentMode = .scaleAspectFit
        spriteView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(spriteView)
        spriteView.edgesToSuperview()
    }
}
