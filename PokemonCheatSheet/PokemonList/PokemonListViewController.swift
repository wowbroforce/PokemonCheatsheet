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
    private let errorView = ErrorView()
    
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
        tableView.rowHeight = 108
        tableView.register(PokemonListViewCell.self, forCellReuseIdentifier: PokemonListViewCell.reuseIdentifier)
        
        stackView.addArrangedSubview(tableView)
        
        stackView.addArrangedSubview(errorView)

        errorView.isHidden = true
    }
    
    private func configureBindings() {
        let viewWillAppear = rx
            .sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .take(1)
            .asDriverOnErrorJustComplete()
        
        let pull = refreshControl.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let selected = tableView.rx.itemSelected.asDriver()
        
        let tableView = self.tableView
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

        output.hideError.drive(errorView.rx.isHidden).disposed(by: bag)
        
        navigationItem.title = output.navigationTitle
    }
}

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
