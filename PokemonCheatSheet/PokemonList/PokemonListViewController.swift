//
//  PokemonListViewController.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit
import RxSwift
import RxCocoa

final class PokemonListViewController: BaseViewController {
    private let pokemonListView: PokemonListViewType
    private let viewModel: PokemonListViewModel
    private let bag = DisposeBag()
    
    init(view: PokemonListViewType, viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        self.pokemonListView = view

        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        configureBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        view.addSubview(pokemonListView.view)
        pokemonListView.view.edgesToSuperview(usingSafeArea: true)
    }

    private func configureBindings() {
        let viewWillAppear = rx
            .sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .take(1)
            .asDriverOnErrorJustComplete()
        
        let pull = pokemonListView.refreshControl.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let selected = pokemonListView.tableView.rx.itemSelected.asDriver()
        
        let tableView = pokemonListView.tableView
        let next = tableView.rx.contentOffset
            .asDriver()
            .map { _ in
                tableView.isNearBottomEdge()
            }
            .distinctUntilChanged()
            .filter { $0 }
            .mapToVoid()

        let input = PokemonListViewModel.Input(
            fetch: Driver.merge(viewWillAppear, pull),
            next: next,
            selected: selected
        )
        
        let output = viewModel.transform(input: input)
        
        output
            .pokemons
            .drive(
                pokemonListView.tableView.rx.items(
                    cellIdentifier: PokemonListViewCell.reuseIdentifier,
                    cellType: PokemonListViewCell.self
                )
            ) { tableView, viewModel, cell in
                cell.bind(with: viewModel)
            }
            .disposed(by: bag)
        output.navigation.drive().disposed(by: bag)
        output.fetching
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(pokemonListView.refreshControl.rx.isRefreshing)
            .disposed(by: bag)

        output.hideError.drive(pokemonListView.errorView.rx.isHidden).disposed(by: bag)
        
        navigationItem.title = output.navigationTitle
    }
}

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
