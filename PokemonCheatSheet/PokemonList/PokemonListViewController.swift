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
    private let tableView = UITableView()
    private let viewModel: PokemonListViewModel
    private let bag = DisposeBag()
    private let refreshControl = UIRefreshControl()
    private let stackView = UIStackView()
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        configureBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func configureUI() {
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.refreshControl = refreshControl
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(PokemonListViewCell.self, forCellReuseIdentifier: PokemonListViewCell.reuseIdentifier)
        
        stackView.addArrangedSubview(tableView)
    }
    
    private func configureBindings() {
        let viewWillAppear = rx
            .sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let pull = refreshControl.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let selected = tableView.rx.itemSelected.asDriver()
        
        let input = PokemonListViewModel.Input(
            fetch: Driver.merge(viewWillAppear, pull),
            selected: selected
        )
        
        let output = viewModel.transform(input: input)
        
        output
            .pokemons
            .drive(
                tableView.rx.items(
                    cellIdentifier: PokemonListViewCell.reuseIdentifier,
                    cellType: PokemonListViewCell.self
                )
            ) { tableView, viewModel, cell in
                cell.bind(with: viewModel)
            }
            .disposed(by: bag)
        output.navigation.drive().disposed(by: bag)
        output.fetching.drive(refreshControl.rx.isRefreshing).disposed(by: bag)
    }
}

extension PokemonListViewController: ViewUpdatable {
    func update() {
        tableView.reloadData()
    }
}
