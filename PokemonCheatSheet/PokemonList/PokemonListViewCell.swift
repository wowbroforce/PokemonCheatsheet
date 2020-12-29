//
//  PokemonListViewCell.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit

final class PokemonListViewCell: UITableViewCell {
    private let pokemonNameLabel = UILabel()
    private let pokemonImageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    private func configureUI() {
//        [pokemonNameLabel, pokemonImageView].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
        let stackView = UIStackView(arrangedSubviews: [pokemonNameLabel, pokemonImageView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}