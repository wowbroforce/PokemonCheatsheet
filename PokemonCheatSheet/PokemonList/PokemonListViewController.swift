//
//  PokemonListViewController.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit
import RxSwift
import RxCocoa

final class PokemonListViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel: PokemonListViewModel
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
