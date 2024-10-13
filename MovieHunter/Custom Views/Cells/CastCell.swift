//
//  CastCell.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 20.08.24.
//

import UIKit

class CastCell: UICollectionViewCell {
    
    static let identifier = "CastCell"
    
    var index = 0
    
    var placeholderImage = UIImage(systemName: "person.fill")!
    
    let posterImageView: MHAvatarImageView =
    {
        let imageView = MHAvatarImageView(image: UIImage(systemName: "person.fill")!)
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let nameLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let roleNameLabel: UILabel =
    {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.adjustsFontSizeToFitWidth                 = true
        label.minimumScaleFactor                        = 0.75
        label.numberOfLines = 2
        label.lineBreakMode                             = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(posterURL: "", name: "", roleName: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(posterURL: String, name: String, roleName: String)
    {
        super.init(frame: .zero)
        configure(posterURL: posterURL, name: name, roleName: roleName)
    }
    
    func configure(posterURL: String, name: String, roleName: String)
    {
        contentView.addSubview(posterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(roleNameLabel)
        
        nameLabel.text = name
        roleNameLabel.text = roleName
        
        placeholderImage = placeholderImage.withTintColor(.label)
        posterImageView.downloadImage(from: ("https://image.tmdb.org/t/p/w500/" + posterURL))
        posterImageView.contentMode = .scaleToFill
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            
            nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 7),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            roleNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            roleNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            roleNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }
    
    func configure(posterURL: String, name: String, roleName: String, forIndex index: Int)
    {
        self.index = index
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(roleNameLabel)
        
        nameLabel.text = name
        roleNameLabel.text = roleName
        
        placeholderImage = placeholderImage.withTintColor(.label)
        posterImageView.downloadImage(from: ("https://image.tmdb.org/t/p/w500/" + posterURL), forIndex: index)
        posterImageView.contentMode = .scaleToFill
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            
            nameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 7),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nameLabel.heightAnchor.constraint(equalToConstant: 16),
            
            roleNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            roleNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            roleNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
        ])
    }
    
    override func layoutSubviews() {
        roleNameLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.image = placeholderImage
        posterImageView.contentMode = .scaleAspectFit
        nameLabel.text = nil
        roleNameLabel.text = nil
    }
}
