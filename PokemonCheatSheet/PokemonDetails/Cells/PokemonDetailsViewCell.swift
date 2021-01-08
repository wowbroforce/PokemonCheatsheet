//
//  PokemonDetailsViewCell.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/8/21.
//

import Foundation
import UIKit

final class PokemonDetailsViewCell: UITableViewCell {
    let weightView = PokemonDetailsViewCellItem()
    let heightView = PokemonDetailsViewCellItem()
    let typeViews = [
        PokemonDetailsViewCellItem(fontSize: 24),
        PokemonDetailsViewCellItem(fontSize: 24),
        PokemonDetailsViewCellItem(fontSize: 24)
    ]
    
    private var allViews: [UIView] {
        [weightView, HorizontalSeparator()] + typeViews + [HorizontalSeparator(), heightView]
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        typeViews.forEach {
            $0.update(title: "", value: "")
            $0.isHidden = true
        }
    }
    
    func update(weight: Int, height: Int, types: [String]) {
        weightView.update(title: "Weight", value: "\(weight) hg")
        heightView.update(title: "Height", value: "\(height) dm")
        zip(typeViews, types).forEach {
            $0.update(title: $1, value: $1.emojified)
            $0.isHidden = false
        }
    }
    
    private func configureUI() {
        selectionStyle = .none
        
        let stackView = UIStackView(arrangedSubviews: allViews)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .equalCentering
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        typeViews.forEach { $0.isHidden = true }
    }
}

final class PokemonDetailsViewCellItem: UIStackView {
    private let fontSize: CGFloat
    private let valueLabel = UILabel()
    private let titleLabel = UILabel()
    
    init(fontSize: CGFloat = 15) {
        self.fontSize = fontSize
        
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(title: String, value: String) {
        valueLabel.text = value
        titleLabel.text = title
    }
    
    private func configureUI() {
        axis = .vertical
        spacing = 4

        valueLabel.font = .boldSystemFont(ofSize: fontSize)
        valueLabel.textColor = Colors.label
        valueLabel.textAlignment = .center
        valueLabel.setContentHuggingPriority(.init(rawValue: 100), for: .vertical)
        
        addArrangedSubview(valueLabel)
        
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        
        addArrangedSubview(titleLabel)
    }
}
