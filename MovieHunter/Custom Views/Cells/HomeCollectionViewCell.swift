//
//  HomeCollectionViewCell.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 10.09.24.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    
    private let posterImageView = MHAvatarImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        posterImageView.frame = contentView.bounds
    }
    
    public func configure(with imageURL: String)
    {
        posterImageView.downloadImage(from: ("https://image.tmdb.org/t/p/w500/" + imageURL))
    }
    
}
