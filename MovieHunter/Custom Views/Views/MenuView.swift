//
//  MenuView.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 23.09.24.
//

import UIKit

protocol MenuViewDelegate: AnyObject
{
    func searchButtonTapped()
    func favButtonTapped()
    func signOutTapped()
}

class MenuView: UIView {
    
    weak var delegate: MenuViewDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "empty_profile")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .semibold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
//        label.font = .systemFont(ofSize: .init(16))
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let seperatorLine: UIView =
    {
        let line = UIView()
        line.backgroundColor = .separator
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    private var favoritesButton = UIButton(type: .custom)
    private var reviewsButton = UIButton(type: .custom)
    private var searchButton = UIButton(type: .custom)
    private var signOutButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel.text = "Unknown User"
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUsername(username: String)
    {
        self.titleLabel.text = username
    }
    
    private func setupUI()
    {
        searchButton = createMenuItem(imageName: "magnifyingglass", text: "Search")
        favoritesButton = createMenuItem(imageName: "star.fill", text: "Favorites")
        signOutButton = createMenuItem(imageName: "person.fill.badge.minus", text: "Sign Out")
        
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        favoritesButton.addTarget(self, action: #selector(favoritesButtonTapped), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        
        self.addSubview(profileImageView)
        self.addSubview(titleLabel)
        self.addSubview(seperatorLine)
        
        self.addSubview(favoritesButton)
        self.addSubview(searchButton)
        self.addSubview(signOutButton)
        
        
        NSLayoutConstraint.activate([
            
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 25),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            profileImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.22),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
        
            
            titleLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            
            seperatorLine.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            seperatorLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            seperatorLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            seperatorLine.heightAnchor.constraint(equalToConstant: 1),
            
            searchButton.topAnchor.constraint(equalTo: seperatorLine.bottomAnchor, constant: 15),
            searchButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            searchButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            searchButton.heightAnchor.constraint(equalToConstant: 44),
            
            favoritesButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 10),
            favoritesButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            favoritesButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            favoritesButton.heightAnchor.constraint(equalToConstant: 44),
            
            signOutButton.topAnchor.constraint(equalTo: favoritesButton.bottomAnchor, constant: 10),
            signOutButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            signOutButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            signOutButton.heightAnchor.constraint(equalToConstant: 44),
        ])

    }
    
    @objc func searchButtonTapped()
    {
        delegate?.searchButtonTapped()
    }
    
    @objc func favoritesButtonTapped()
    {
        delegate?.favButtonTapped()
    }
    
    @objc func signOut()
    {
        delegate?.signOutTapped()
    }
    
    private func createMenuItem(imageName: String, text: String) -> UIButton
    {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.text = text
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.13),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        
        
        return view
    }
    
    internal func hideViews()
    {
        self.subviews.forEach { $0.isHidden = true }
    }
    
    internal func showViews()
    {
        self.subviews.forEach { $0.isHidden = false }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.borderWidth = 0.1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
}
