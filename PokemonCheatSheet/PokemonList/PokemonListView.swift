//
//  PokemonListView.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/11/21.
//

import Foundation
import UIKit

protocol PokemonListViewType: ViewContainable {
    var tableView: UITableView { get }
    var refreshControl: UIRefreshControl { get }
    var errorView: ErrorView { get }
}

final class PokemonListView: UIView, PokemonListViewType {
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let errorView = ErrorView()

    private let stackView = UIStackView()

    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.edgesToSuperview(usingSafeArea: true)
        
        tableView.refreshControl = refreshControl
        tableView.rowHeight = 108
        tableView.register(PokemonListViewCell.self, forCellReuseIdentifier: PokemonListViewCell.reuseIdentifier)
        
        stackView.addArrangedSubview(tableView)
        
        stackView.addArrangedSubview(errorView)

        errorView.isHidden = true
    }
}
