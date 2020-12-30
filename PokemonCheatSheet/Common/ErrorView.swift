//
//  ErrorView.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/30/20.
//

import UIKit

final class ErrorView: UIView {
    let label = UILabel()
    
    var text: String? = "Oops! Something went wrong!" {
        didSet {
            updateLabel()
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = Colors.systemRed
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
        
        updateLabel()
    }
    
    private func updateLabel() {
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
