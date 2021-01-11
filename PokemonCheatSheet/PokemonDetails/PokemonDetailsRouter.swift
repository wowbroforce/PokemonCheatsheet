//
//  PokemonDetailsRouter.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit

final class PokemonDetailsRouter {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toList() {
        guard let navigationController = navigationController else { return }
        navigationController.popViewController(animated: true)
    }
}
