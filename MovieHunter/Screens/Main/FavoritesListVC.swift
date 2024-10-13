//
//  FavoritesListVC.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 07.08.24.
//

import UIKit

class FavoritesListVC: UIViewController {
    
    enum Section
    {
        case main
    }
    
    var movieTitle: String!
    var movies: [Movie] = []
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureCollectionView()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.prefersLargeTitles = true
        getFavorites()
    }
    
    func configureCollectionView()
    {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
    }
    
    func configureDataSource()
    {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView) { collectionView, indexPath, movie in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.reuseID, for: indexPath) as! MovieCell
            cell.set(movie: movie)
            return cell
        }
    }
    
    func updateData()
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    func getFavorites()
    {
        FirebasePersistenceManager.shared.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let IDs):
                self.movies.removeAll()
                
                if IDs.isEmpty
                {
                    if movies.isEmpty
                    {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.updateData()
                            self.showEmptyStateView(with: "No favorite movies.", in: self.view)
                        }
                    } else
                    {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            self.updateData()
                            self.view.bringSubviewToFront(self.collectionView)
                        }
                    }
                    return
                }
                
                for id in IDs
                {
                    let originalID = id / 10
                    let isMovie = id % 10 == 1
                    NetworkManager.shared.getMovieFromID(from: originalID, isMovie: isMovie) { [weak self] result in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let movie):
                            self.movies.append(movie)
                            
                            if id == IDs.last
                            {
                                if movies.isEmpty
                                {
                                    DispatchQueue.main.async { [weak self] in
                                        guard let self = self else { return }
                                        self.updateData()
                                        self.showEmptyStateView(with: "No favorite movies.", in: self.view)
                                    }
                                } else
                                {
                                    DispatchQueue.main.async { [weak self] in
                                        guard let self = self else { return }
                                        self.updateData()
                                        self.view.bringSubviewToFront(self.collectionView)
                                    }
                                }
                            }
                        case .failure(let error):
                            self.presentMHAlertOnMainThread(title: "Something went wrong.", message: error.rawValue, buttonTitle: "Ok")
                        }
                    }
                    
                }
                

                
            case .failure(let error):
                self.presentMHAlertOnMainThread(title: "Something went wrong.", message: error.localizedDescription, buttonTitle: "Ok")
            }
            
        }
    }
}

extension FavoritesListVC: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        
        let destVC = MovieInfoVC()
        destVC.movie = movie
        navigationController?.pushViewController(destVC, animated: true)
    }
}
