//
//  Separator.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/30/20.
//

import UIKit

final class VerticalSeparator: UIView {
    init(width: CGFloat = 1) {
        super.init(frame: .zero)

        heightAnchor.constraint(equalToConstant: width).isActive = true
        
        backgroundColor = .lightGray
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class HorizontalSeparator: UIView {
    init(width: CGFloat = 1) {
        super.init(frame: .zero)
        
        widthAnchor.constraint(equalToConstant: width).isActive = true
        
        backgroundColor = .lightGray
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
