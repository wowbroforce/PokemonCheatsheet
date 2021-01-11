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
        label.edgesToSuperview(
            insets: .init(top: 16, left: 32,bottom: 16, right: 32)
        )
        
        updateLabel()
    }
    
    private func updateLabel() {
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
