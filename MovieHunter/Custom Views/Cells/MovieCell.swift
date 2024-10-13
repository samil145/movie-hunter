//
//  MovieCell.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 11.08.24.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    let placeholderImage = UIImage(named: "moviePlaceholder")!
    
    static let reuseID = "MovieCell"
    let avatarImageView = MHAvatarImageView(image: UIImage(named: "moviePlaceholder")!)
    let movieTitleLabel   = MHTitleLabel(textAlignment: .center, fontSize: 16)
    let movieYearLabel = MHBodyLabel(textAlignment: .center, color: .secondaryLabel)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(movie: Movie)
    {
        guard let movieTitle = movie.title ?? movie.name else { movieTitleLabel.text = "Unknown"; return }
        movieTitleLabel.text = movieTitle
//        movieTitleLabel.text = movie.original_title
        
        if let date = movie.release_date ?? movie.first_air_date
        {
            if let year = date.split(separator: "-").first.map(String.init)
            {
                movieYearLabel.text = year
            }
        }
        
        guard let imageUrl = movie.poster_path else { return }
        avatarImageView.downloadImage(from: ("https://image.tmdb.org/t/p/w500/" + imageUrl))
    }
    
    private func configure()
    {
        addSubview(avatarImageView)
        addSubview(movieTitleLabel)
        addSubview(movieYearLabel)
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 1.5),
            
            movieTitleLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            movieTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            movieTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            movieTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            movieYearLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 6),
            movieYearLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            movieYearLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            movieYearLabel.heightAnchor.constraint(equalToConstant: 10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = placeholderImage
        avatarImageView.contentMode = .scaleAspectFit
        movieTitleLabel.text = nil
        movieYearLabel.text = nil
    }
}
