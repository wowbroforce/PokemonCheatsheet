//
//  AutoLayout+Extensions.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/11/21.
//

import Foundation
import UIKit

extension UIView {
    /// Simple NSLayoutConstraint wrapper.
    /// It doesn't support right-to-left languages.
    func edgesToSuperview(excludedEdge: LayoutEdge = .none, insets: UIEdgeInsets = .zero, usingSafeArea: Bool = false) {
        guard let superview = superview else { return }
        var constraints = [NSLayoutConstraint]()
        
        if !(excludedEdge.contains(.leading) || excludedEdge.contains(.left)) {
            constraints.append(leadingAnchor.constraint(
                equalTo: usingSafeArea ? superview.safeAreaLayoutGuide.leadingAnchor : superview.leadingAnchor,
                constant: insets.left
            ))
        }
            
        if !(excludedEdge.contains(.trailing) || excludedEdge.contains(.right)) {
            constraints.append(trailingAnchor.constraint(
                equalTo: usingSafeArea ? superview.safeAreaLayoutGuide.trailingAnchor : superview.trailingAnchor,
                constant: -insets.right
            ))
        }
        
        if !excludedEdge.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(
                equalTo: usingSafeArea ? superview.safeAreaLayoutGuide.bottomAnchor : superview.bottomAnchor,
                constant: -insets.bottom
            ))
        }

        if !excludedEdge.contains(.top) {
            constraints.append(topAnchor.constraint(
                equalTo: usingSafeArea ? superview.safeAreaLayoutGuide.topAnchor : superview.topAnchor,
                constant: insets.top
            ))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}

struct LayoutEdge: OptionSet {
    let rawValue: UInt8
    init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
    static let top = LayoutEdge(rawValue: 1 << 0)
    static let bottom = LayoutEdge(rawValue: 1 << 1)
    static let trailing = LayoutEdge(rawValue: 1 << 2)
    static let leading = LayoutEdge(rawValue: 1 << 3)
    static let left = LayoutEdge(rawValue: 1 << 4)
    static let right = LayoutEdge(rawValue: 1 << 5)
    static let none = LayoutEdge(rawValue: 1 << 6)
}

