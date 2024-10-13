//
//  PersonVC.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 22.08.24.
//

import UIKit

class PersonVC: UIViewController {
    
    var personID: Int!
    
    let scrollView = UIScrollView()
    let contentView = UIView()

    var personImageView: MHAvatarImageView =
    {
        let imageView = MHAvatarImageView(image: UIImage(systemName: "person.fill")!)
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let personNameLabel = MHTitleLabel(textAlignment: .left, fontSize: 25)
    let bio: UILabel =
    {
        let label = UILabel()
        label.textAlignment          = .left
        label.textColor              = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font                        = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth   = true
        label.minimumScaleFactor          = 0.75
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var containerView: UIView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        layoutUI()
        getPersonDetails()
    }
    
    func layoutUI()
    {
        layoutScrollView()
        layoutContentView()
        layoutPersonPoster()
        layoutPersonNameLabel()
        layoutBio()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        personNameLabel.sizeToFit()
        bio.sizeToFit()
        //scrollView.frame = view.bounds
    }
    
    func getPersonDetails()
    {
        showLoadingViewFullAlphaBruh()
        
        NetworkManager.shared.getPerson(personID: personID) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let person):
                guard let posterURL = person.profile_path, let bio = person.biography else { return }
                setData(posterURL: posterURL, name: person.name, bio: bio)
            case .failure(let error):
                self.presentMHAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func setData(posterURL: String, name: String, bio: String)
    {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.personNameLabel.text = name
            self.bio.text = bio
            self.personImageView.contentMode = .scaleToFill
        }
            
            personImageView.downloadImage(from: ("https://image.tmdb.org/t/p/w500/" + posterURL))
            {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.dismissLoadingViewBruh()
                }
                
            }
        
    }
    
    @objc func back()
    {
        navigationController?.popViewController(animated: true)
    }
    
    func dismissLoadingViewBruh()
    {
        DispatchQueue.main.async {
            self.containerView!.removeFromSuperview()
            self.containerView = nil
        }
    }
    
    func showLoadingViewFullAlphaBruh()
    {
        containerView = UIView()
        
        containerView?.frame = view.bounds
        
        view.addSubview(containerView!)
        view.bringSubviewToFront(containerView!)
        

        
        containerView!.backgroundColor = .systemBackground
        containerView!.alpha = 1
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView!.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    
    
    
    func layoutScrollView()
    {
        scrollView.showsVerticalScrollIndicator = false
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
    
    func layoutPersonPoster()
    {
        contentView.addSubview(personImageView)

        NSLayoutConstraint.activate([
            personImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            personImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            personImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            personImageView.heightAnchor.constraint(equalTo: personImageView.widthAnchor, multiplier: 1.2)
        ])
    }
    
    func layoutPersonNameLabel()
    {
        contentView.addSubview(personNameLabel)
        
        personNameLabel.text = "No Information"
        
        personNameLabel.numberOfLines = 2
        personNameLabel.adjustsFontSizeToFitWidth = true
        personNameLabel.minimumScaleFactor = 0.5
        personNameLabel.lineBreakMode = .byTruncatingTail
        
        NSLayoutConstraint.activate([
            personNameLabel.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 15),
            personNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            personNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    func layoutBio()
    {
        contentView.addSubview(bio)
        
        bio.text = "No Information"
        
        NSLayoutConstraint.activate([
            
            bio.topAnchor.constraint(equalTo: personNameLabel.bottomAnchor, constant: 15),
            bio.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            bio.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            bio.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
