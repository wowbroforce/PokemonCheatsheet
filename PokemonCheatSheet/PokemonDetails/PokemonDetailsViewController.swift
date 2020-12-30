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
    private let imageView = UIImageView()
    private let stackView = UIStackView()
    private let statsLabel = UILabel()
    private let viewModel: PokemonDetailsViewModel
    private let backButton = UIBarButtonItem(image: Image(named: "back"), style: .plain, target: nil, action: nil)
    private let bag = DisposeBag()
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    private let errorView = ErrorView()
    
    private var detailsView: UIView? {
        willSet {
            guard let view = detailsView else {
                return
            }
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        didSet {
            guard let view = detailsView else {
                return
            }
            stackView.insertArrangedSubview(view, at: 2)
        }
    }
    
    private var statsView: UIView? {
        willSet {
            guard let view = statsView else {
                return
            }
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        didSet {
            guard let view = statsView else {
                return
            }
            stackView.insertArrangedSubview(view, at: 3)
        }
    }
    
    private var imagesView: UIView? {
        willSet {
            guard let view = imagesView else {
                return
            }
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        didSet {
            guard let view = imagesView else {
                return
            }
            stackView.insertArrangedSubview(view, at: 4)
        }
    }
    
    private var details: Binder<PokemonDetailsModel> {
        return Binder(self) { controller, details in
            controller.imageView.image = details.images.first
            controller.detailsView = controller.makeDetailsUI(model: details)
            controller.statsView = controller.makeStatsUI(model: details)
            controller.imagesView = controller.makeImagesUI(model: details)
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
            stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -32),
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(statsLabel)
        
        stackView.addArrangedSubview(UIView())
        
        navigationItem.leftBarButtonItem = backButton
        
        statsLabel.numberOfLines = 0
                
        imageView.contentMode = .scaleAspectFit
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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
        output.title.drive(navigationItem.rx.title).disposed(by: bag)
        output.hideError.drive(errorView.rx.isHidden).disposed(by: bag)
    }
    
    private func makeDetailsItemUI(key: String, value: String, size: CGFloat = 15) -> UIView {
        let valueLabel = UILabel()
        valueLabel.font = .boldSystemFont(ofSize: size)
        valueLabel.textColor = Colors.label
        valueLabel.text = value
        valueLabel.textAlignment = .center
        valueLabel.setContentHuggingPriority(.init(rawValue: 100), for: .vertical)
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .gray
        titleLabel.text = key
        titleLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [valueLabel, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        return stackView
    }
    
    private func makeDetailsUI(model: PokemonDetailsModel) -> UIView {
        let weightView = makeDetailsItemUI(key: "Weight", value: "\(model.weight) hg")
        let heightView = makeDetailsItemUI(key: "Height", value: "\(model.height) dm")
        let typeViews = model.types.map {
            makeDetailsItemUI(key: $0, value: $0.emojified, size: 24)
        }
        let views = [weightView, HorizontalSeparator()] +
            typeViews +
            [HorizontalSeparator(), heightView]
        let stackView = UIStackView(arrangedSubviews: views)
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .equalCentering
        
        return stackView
    }
    
    private func makeStatsItemUI(key: String, value: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = Colors.label
        titleLabel.text = key
        titleLabel.textAlignment = .center
        
        let valueLabel = UILabel()
        valueLabel.font = .boldSystemFont(ofSize: 17)
        valueLabel.textColor = #colorLiteral(red: 0, green: 0.4745098039, blue: 0.1725490196, alpha: 1)
        valueLabel.text = value
        valueLabel.textAlignment = .center
        
        let separator = UIView()
        separator.heightAnchor.constraint(equalToConstant: 36).isActive = true

        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, separator, valueLabel]
        )
        stackView.axis = .horizontal
        stackView.spacing = 4
        
        return stackView
    }
    
    private func makeStatsUI(model: PokemonDetailsModel) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = "Stats"
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        let statViews = model.stats.map { key, value in
            makeStatsItemUI(key: key, value: value)
        }
        
        let stackView = UIStackView(
            arrangedSubviews: [titleLabel, VerticalSeparator()] + statViews
        )
        stackView.axis = .vertical
        
        return stackView
    }
    
    private func makeImagesUI(model: PokemonDetailsModel) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = "Other Images"
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        let imageViews = model.images.map { image -> UIImageView in
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }
        
        let scrollView = UIScrollView()
        let stackView = UIStackView(arrangedSubviews: imageViews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: stackView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 96)
        ])
        
        let outerStackView = UIStackView(arrangedSubviews: [titleLabel, VerticalSeparator(), scrollView])
        outerStackView.axis = .vertical
        return outerStackView
    }
}
