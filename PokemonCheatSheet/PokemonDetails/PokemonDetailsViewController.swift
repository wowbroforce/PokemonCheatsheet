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

// TODO: Create a separate component for the image galery
final class PokemonDetailsViewController: BaseViewController {
    private let tableView = UITableView()
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let typesLabel = UILabel()
    private let statsLabel = UILabel()
    private let viewModel: PokemonDetailsViewModel
    private let backButton = UIBarButtonItem(title: "back", style: .plain, target: nil, action: nil)
    private let bag = DisposeBag()
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    private var details: Binder<PokemonDetailsModel> {
        return Binder(self) { controller, details in
            controller.nameLabel.text = details.name
            controller.typesLabel.text = details.types.joined(separator: " ")
            controller.statsLabel.text = details.stats.joined(separator: "\n")
        }
    }

    init(viewModel: PokemonDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        configureUI()
        configureBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(typesLabel)
        stackView.addArrangedSubview(statsLabel)
        
        stackView.addArrangedSubview(UIView())
        
        navigationItem.leftBarButtonItem = backButton
        
        typesLabel.numberOfLines = 0
        statsLabel.numberOfLines = 0
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
        
        output.details.drive(details).disposed(by: bag)
        output.navigation.drive().disposed(by: bag)
        output.fetching.drive(activityIndicator.rx.isAnimating).disposed(by: bag)
    }
}

extension Reactive where Base: PokemonDetailsViewController {
}
