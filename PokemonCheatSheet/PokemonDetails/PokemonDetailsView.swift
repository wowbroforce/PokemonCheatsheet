//
//  PokemonDetailsView.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/8/21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Domain

protocol PokemonDetailsViewType: AnyObject {
    var view: UIView { get }
    var tableView: UITableView { get }
}

extension PokemonDetailsViewType where Self: UIView {
    var view: UIView {
        return self
    }
}

final class PokemonDetailsView: UIView, PokemonDetailsViewType {
    let tableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(cellType: PokemonDetailsViewCell.self)
        tableView.register(cellType: PokemonDetailsSpriteCell.self)
        tableView.register(cellType: PokemonDetailsStatView.self)
        tableView.register(cellType: PokemonDetailsHeaderCell.self)
        tableView.register(cellType: PokemonDetailsGalleryView.self)
        
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
