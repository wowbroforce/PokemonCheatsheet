//
//  PokemonListViewCell.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import UIKit
import RxCocoa
import RxSwift

final class PokemonListViewCell: UITableViewCell {
    private let pokemonNameLabel = UILabel()
    private let pokemonImageView = UIImageView()
    
    private var bag = DisposeBag()
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        
//        configureUI()
//    }
//    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = DisposeBag()
        
        pokemonNameLabel.text = nil
        pokemonImageView.image = nil
    }
    
    func bind(with viewModel: PokemonListViewCellViewModel) {
        viewModel.image.drive(pokemonImageView.rx.image).disposed(by: bag)
        pokemonNameLabel.text = viewModel.pokemon.name.capitalized
    }
    
    private func configureUI() {
//        [pokemonNameLabel, pokemonImageView].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//        }
        let stackView = UIStackView(arrangedSubviews: [pokemonNameLabel, UIView(), pokemonImageView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            pokemonImageView.widthAnchor.constraint(equalToConstant: 92),
            pokemonImageView.heightAnchor.constraint(equalToConstant: 92)
        ])
        
        pokemonImageView.layer.cornerRadius = 16
        pokemonImageView.layer.masksToBounds = true
    }
}
