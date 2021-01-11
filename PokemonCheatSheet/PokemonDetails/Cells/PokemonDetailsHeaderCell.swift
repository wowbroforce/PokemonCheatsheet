//
//  PokemonDetailsHeaderCell.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/8/21.
//

import Foundation
import UIKit

final class PokemonDetailsHeaderCell: UITableViewCell {
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with title: String) {
        titleLabel.text = title
    }

    private func configureUI() {
        selectionStyle = .none

        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.heightAnchor.constraint(equalToConstant: 54).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let separator = VerticalSeparator()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(separator)
        
        titleLabel.edgesToSuperview(
            excludedEdge: .bottom,
            insets: .init(top: 8, left: 32, bottom: 0, right: 32)
        )
        separator.edgesToSuperview(
            excludedEdge: .top,
            insets: .init(top: 0, left: 32, bottom: 0, right: 32)
        )
        
        titleLabel.bottomAnchor.constraint(equalTo: separator.topAnchor).isActive = true
    }
}
