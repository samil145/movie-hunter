//
//  UserInfoVC+Layout+Ext.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 17.08.24.
//

import UIKit

extension MovieInfoVC
{
    func layoutScrollView()
    {
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func layoutContentView()
    {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    func layoutMoviePoster()
    {
        contentView.addSubview(moviePoster)

        NSLayoutConstraint.activate([
            moviePoster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            moviePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            moviePoster.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            moviePoster.heightAnchor.constraint(equalTo: moviePoster.widthAnchor, multiplier: 1.2)
        ])
    }
    
    func layoutTrailerButton()
    {
        contentView.addSubview(trailerButton)
        
        trailerButton.setImage(UIImage(named: "youtube_logo"), for: .normal)
        
        
        trailerButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            trailerButton.centerYAnchor.constraint(equalTo: moviePoster.bottomAnchor),
            trailerButton.trailingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: -15),
            trailerButton.widthAnchor.constraint(equalToConstant: 50),
            trailerButton.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    func layoutMovieTitleLabel()
    {
        contentView.addSubview(movieTitleLabel)
        
        movieTitleLabel.numberOfLines = 2
        movieTitleLabel.adjustsFontSizeToFitWidth = true
        movieTitleLabel.minimumScaleFactor = 0.5
        movieTitleLabel.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            movieTitleLabel.topAnchor.constraint(equalTo: moviePoster.bottomAnchor, constant: 15),
            movieTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    func layoutRatingView()
    {
        contentView.addSubview(ratingView)
        
        NSLayoutConstraint.activate([
            ratingView.topAnchor.constraint(equalTo: moviePoster.topAnchor, constant: 10),
            ratingView.leadingAnchor.constraint(equalTo: moviePoster.leadingAnchor, constant: 10),
            ratingView.widthAnchor.constraint(equalToConstant: 70),
            ratingView.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func layoutGenreCV()
    {
        contentView.addSubview(genreCollectionView)
        genreCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self
        genreCollectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        genreCollectionView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            genreCollectionView.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 15),
            genreCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            genreCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    
    func layoutOverview()
    {
        contentView.addSubview(overview)
        NSLayoutConstraint.activate([
            
            overview.topAnchor.constraint(equalTo: genreCollectionView.bottomAnchor, constant: 15),
            overview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            overview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
        ])
    }
    
    func layoutOverviewAfterAPI()
    {
        NSLayoutConstraint.activate([
            
            overview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
        ])
    }
    
    func layoutCastLabel()
    {
        contentView.addSubview(castLabel)
        
        NSLayoutConstraint.activate([
            castLabel.topAnchor.constraint(equalTo: overview.bottomAnchor, constant: 30),
            castLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            castLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            //castLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
        ])
    }
    
    func layoutCastCollectionView()
    {
        contentView.addSubview(castCollectionView)
        
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            castCollectionView.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 10),
            castCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            castCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            castCollectionView.heightAnchor.constraint(equalToConstant: 215),
            castCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)
        ])
    }
    
    
}
