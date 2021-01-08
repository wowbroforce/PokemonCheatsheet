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
    var activityIndicator: UIActivityIndicatorView { get }
    var errorView: ErrorView { get }
    
    func cellFactory(tableView: UITableView, row: Int, element: PokemonDetailsModelItem) -> UITableViewCell
}

extension PokemonDetailsViewType where Self: UIView {
    var view: UIView {
        return self
    }
}

final class PokemonDetailsView: UIView, PokemonDetailsViewType {
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(style: .gray)
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
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
        
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
        
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(tableView)
        
        errorView.isHidden = true
        errorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(errorView)
        
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension PokemonDetailsView {
    func cellFactory(tableView: UITableView, row: Int, element: PokemonDetailsModelItem) -> UITableViewCell {
        switch element {
        case .sprite(let image):
            let cell: PokemonDetailsSpriteCell = tableView.dequeueReusableCell()
            cell.update(with: image)
            return cell
        case .details(weight: let weight, height: let height, types: let types):
            let cell: PokemonDetailsViewCell = tableView.dequeueReusableCell()
            cell.update(weight: weight, height: height, types: types)
            return cell
        case .stat(name: let name, value: let value):
            let cell: PokemonDetailsStatView = tableView.dequeueReusableCell()
            cell.update(title: name, value: value)
            return cell
        case .header(let text):
            let cell: PokemonDetailsHeaderCell = tableView.dequeueReusableCell()
            cell.update(with: text)
            return cell
        case.gallery(let images):
            let cell: PokemonDetailsGalleryView = tableView.dequeueReusableCell()
            cell.update(with: images)
            return cell
        }
    }    
}
