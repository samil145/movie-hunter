//
//  RatingView.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 15.08.24.
//

import UIKit

class RatingView: UIView {
    
    let ratingBlurView = UIView()//UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var ratingImageView = UIImageView(image: UIImage(systemName: "star.fill"))
    let ratingLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure()
    {
        // Adding subviews
        addSubview(ratingBlurView)
        addSubview(ratingImageView)
        addSubview(ratingLabel)
        
        // Content View Properties
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius  = 10
        clipsToBounds       = true
        backgroundColor     = .clear
        
        // Blur View
        ratingBlurView.translatesAutoresizingMaskIntoConstraints = false
        ratingBlurView.layer.cornerRadius   = 10
        ratingBlurView.clipsToBounds        = true
        ratingBlurView.backgroundColor      = UIColor(red: 0.23, green: 0.23, blue: 0.24, alpha: 1)
        ratingBlurView.alpha                = 0.7
        
        // Image View
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        ratingImageView.tintColor = .systemYellow
        
        // Label
        ratingLabel.font                      = UIFont.systemFont(ofSize: 20, weight: .regular)
        ratingLabel.textAlignment             = .left
        ratingLabel.textColor                 = .white
        ratingLabel.adjustsFontSizeToFitWidth = true
        ratingLabel.minimumScaleFactor        = 0.8
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ratingBlurView.topAnchor.constraint(equalTo: topAnchor),
            ratingBlurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ratingBlurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingBlurView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            ratingImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            ratingImageView.widthAnchor.constraint(equalToConstant: 20),
            ratingImageView.heightAnchor.constraint(equalToConstant: 20),
            
            ratingLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ratingLabel.leadingAnchor.constraint(equalTo: ratingImageView.trailingAnchor, constant: 5),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ])
    }
    
    func setRatingLabel(ratingText: String)
    {
        ratingLabel.text = ratingText
    }
}
