//
//  PokemonDetailsStatView.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/8/21.
//

import Foundation
import UIKit

final class PokemonDetailsStatView: UITableViewCell {
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    private func configureUI() {
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = Colors.label
        titleLabel.textAlignment = .center
        
        valueLabel.font = .boldSystemFont(ofSize: 17)
        valueLabel.textColor = #colorLiteral(red: 0, green: 0.4745098039, blue: 0.1725490196, alpha: 1)
        valueLabel.textAlignment = .center
        
        let separator = UIView()
        
        separator.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, separator, valueLabel]
        )
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
