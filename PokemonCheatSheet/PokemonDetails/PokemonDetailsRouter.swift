//
//  PokemonDetailsRouter.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit

final class PokemonDetailsRouter {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toList() {
        navigationController.popViewController(animated: true)
    }
}
