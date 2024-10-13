//
//  MovieListVC.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 08.08.24.
//

import UIKit

class MovieListVC: UIViewController {
    
    enum Section
    {
        case main
    }
    
    var containerView: UIView?
    var emptyStateView: MHEmptyStateView?
    
    var movieTitle: String?
    var movies: [Movie] = []
    var page = 1
    static var hasMoreMovies = true
    
    var inDiscover = true
    var inEmptyState = false
    var inMovies = false
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureSearchController()
        configureCollectionView()
        getDiscover()
        configureDataSource()

        navigationItem.hidesSearchBarWhenScrolling = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        MovieListVC.hasMoreMovies = true

        inMovies = !inDiscover ? true : false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func configureViewController()
    {
        view.backgroundColor = .systemBackground
//        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureCollectionView()
    {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.reuseID)
    }
    
    func configureSearchController()
    {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a movie or TV Show"
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    func getMovies(movieTitle: String, inPagination: Bool, page: Int)
    {
        showLoadingView_()
        NetworkManager.shared.getMovies(for: movieTitle, page: page) { [weak self] result in
            guard let self else {return}
            self.dismissLoadingView_()
            
            switch result
            {
            case .success(let movies):
                if self.inDiscover || (!inPagination && !self.inMovies)
                {
                    self.movies.removeAll()
                }
                if (!self.inMovies)
                {
                    self.movies.append(contentsOf: movies)
                }
                
                
                if self.movies.isEmpty
                {
                    let message = "Sorry, no movies match the title you entered."
                    DispatchQueue.main.async { self.showEmptyStateView_(with: message) }
                    return
                } else {
                    self.dismissEmptyStateView_()
                }
                
                self.inDiscover = false
                self.inMovies = false
                self.updateData()
            case .failure(let error):
                self.presentMHAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
            
        }
    }
    
    func getDiscover()
    {
        showLoadingView_()
        NetworkManager.shared.getDiscoverMovies { [weak self] result in
            guard let self = self else {return}
            self.dismissLoadingView_()
        
            switch result
            {
            case .success(let movies):
                self.movies = movies

                if self.movies.isEmpty
                {
                    let message = "Sorry, no movies match the title you entered."
                    DispatchQueue.main.async { self.showEmptyStateView_(with: message) }
                    return
                } else {
                    self.dismissEmptyStateView_()
                }
        
                self.inDiscover = true
                self.updateData()
            case .failure(let error):
                self.presentMHAlertOnMainThread(title: "Something Went Wrong", message:error.rawValue, buttonTitle: "Ok")
            }
        }
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
    
    func showLoadingView_()
    {
        if containerView == nil
        {
            containerView = UIView(frame: view.bounds)
            view.addSubview(containerView!)
            
            containerView!.backgroundColor = .systemBackground
            containerView!.alpha = 0
            
            UIView.animate(withDuration: 0.25) { self.containerView!.alpha = 0.8 }
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            containerView!.addSubview(activityIndicator)
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
            
            activityIndicator.startAnimating()
        }
    }
    
    func dismissLoadingView_()
    {
        if containerView != nil
        {
            DispatchQueue.main.async {
                self.containerView?.removeFromSuperview()
                self.containerView = nil
            }
        }
    }
    
    func showEmptyStateView_(with message: String)
    {
        if emptyStateView == nil
        {
            emptyStateView = MHEmptyStateView(message: message)
            emptyStateView!.frame = view.bounds
            view.addSubview(emptyStateView!)
            view.bringSubviewToFront(emptyStateView!)
            
            emptyStateView!.isUserInteractionEnabled = true
            
            // Create a tap gesture recognizer
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tap.cancelsTouchesInView = false
            
            // Add the gesture recognizer to the emptyStateView
            emptyStateView!.addGestureRecognizer(tap)
        }
    }

    // Add this method to your class
    @objc func dismissKeyboard() {
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    

    
    func dismissEmptyStateView_()
    {
        DispatchQueue.main.async {
            self.emptyStateView?.removeFromSuperview()
            self.emptyStateView = nil
        }
    }
}

extension MovieListVC: UICollectionViewDelegate
{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !inDiscover
        {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
            
            if offsetY > (contentHeight - height)
            {
                guard MovieListVC.hasMoreMovies, let movieTitle = movieTitle else { return }
                page+=2
                getMovies(movieTitle: movieTitle, inPagination: true, page: page)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        
        let destVC = MovieInfoVC()
        destVC.movie = movie
        navigationController?.pushViewController(destVC, animated: true)
    }
}

extension MovieListVC: UISearchResultsUpdating, UISearchBarDelegate
{
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        if text.isEmpty {
            getDiscover()
        } else
        {
            if movieTitle != text
            {
                page = 1
                MovieListVC.hasMoreMovies = true
            }
            movieTitle = text
            getMovies(movieTitle: movieTitle!, inPagination: false, page: page)
        
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        MovieListVC.hasMoreMovies = true
        page = 1
        updateData()
    }
}
