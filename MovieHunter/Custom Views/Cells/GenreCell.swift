//
//  GenreCell.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 16.08.24.
//

import UIKit

class GenreCell: UICollectionViewCell {
    static let identifier = "GenreCell"
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    init(genre: String)
//    {
//        super.init(frame: .zero)
//        genreLabel.text = genre
//        layoutUI()
//    }
    
    func layoutUI()
    {
        addSubview(genreLabel)
        //translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        backgroundColor = .systemGray6
        
        NSLayoutConstraint.activate([
            genreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            genreLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            genreLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            genreLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func configure(genre: String)
    {
        genreLabel.text = genre
    }

}
