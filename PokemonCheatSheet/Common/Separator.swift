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

        NSLayoutConstraint.activate([heightAnchor.constraint(equalToConstant: width)])
        
        backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class HorizontalSeparator: UIView {
    init(width: CGFloat = 1) {
        super.init(frame: .zero)
        
        NSLayoutConstraint.activate([widthAnchor.constraint(equalToConstant: width)])
        
        backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
