//
//  HomeTableViewCell.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 07.09.24.
//

import UIKit

protocol HomeTableViewCellDelegate: AnyObject {
    func homeTableViewCellDidTapCell(_ cell: HomeTableViewCell, movie: Movie)
}

class HomeTableViewCell: UITableViewCell {
    
    static let identifier = "HomeTableViewCell"
    
    weak var delegate: HomeTableViewCellDelegate?
    
    private var movies: [Movie] = []
    
    private let collectionView: UICollectionView =
    {
       let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configure(with movies: [Movie]) {
        self.movies = movies
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let imageURL = movies[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: imageURL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movie = movies[indexPath.row]
        
        delegate?.homeTableViewCellDidTapCell(self, movie: movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let favoriteAction = UIAction(title: "Add to Favorites", subtitle: nil, image: UIImage(systemName: "star")!, identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
                    guard let self = self else { return }
                    
                    FirebasePersistenceManager.shared.updateWith(movieID: self.movies[indexPath.row].id, isMovie: self.movies[indexPath.row].title != nil, actionType: .add)
                    { error in
                        guard let _ = error else { return }
                    }
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [favoriteAction])
            }
        
        return config
    }
    
    

    
    
}

