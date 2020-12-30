//
//  BaseNavigationController.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit

class BaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.backgroundColor = Colors.systemBackground
        navigationBar.isTranslucent = false
    }
}
