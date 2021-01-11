//
//  PokemonDetailsViewController.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit
import Domain
import RxCocoa
import RxSwift

final class PokemonDetailsViewController: BaseViewController {
    private let pokemonDetailsView: PokemonDetailsViewType
    private let viewModel: PokemonDetailsViewModel
    private let backButton = UIBarButtonItem(image: Image(named: "back"), style: .plain, target: nil, action: nil)
    private let bag = DisposeBag()
    
    init(pokemonDetailsView: PokemonDetailsViewType, viewModel: PokemonDetailsViewModel) {
        self.viewModel = viewModel
        self.pokemonDetailsView = pokemonDetailsView
        
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        configureBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        view.addSubview(pokemonDetailsView.view)
        pokemonDetailsView.view.edgesToSuperview(usingSafeArea: true)

        navigationItem.leftBarButtonItem = backButton
    }
    
    private func configureBindings() {
        let viewWillAppear = rx
            .sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = PokemonDetailsViewModel.Input(
            back: backButton.rx.tap.asDriver(),
            fetch: viewWillAppear
        )
        
        let output = viewModel.transform(input: input)
        
        output.navigation.drive().disposed(by: bag)
        output.fetching.drive(pokemonDetailsView.activityIndicator.rx.isAnimating).disposed(by: bag)
        output.hideError.drive(pokemonDetailsView.errorView.rx.isHidden).disposed(by: bag)
        output.title.drive(navigationItem.rx.title).disposed(by: bag)
        output.detailItems.drive(
            pokemonDetailsView.tableView.rx.items,
            curriedArgument: pokemonDetailsView.cellFactory
        ).disposed(by: bag)
    }
}
