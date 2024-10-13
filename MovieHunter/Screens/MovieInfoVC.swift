//
//  UserInfoVC.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 13.08.24.
//

import UIKit

class MovieInfoVC: UIViewController, CastCollectionViewDelegate {
    
    var movie: Movie!
    
    var genres: [String] = []
    
    let emptyStarImageView = UIImage(systemName: "star")
    let filledStarImageView = UIImage(systemName: "star.fill")
    
    var youtubeKey: String?
    
    var persistanceAction = PersistenceActionType.add

    let scrollView = UIScrollView()
    let contentView = UIView()
    var moviePoster = MHAvatarImageView(frame: .zero)
    let movieTitleLabel = MHTitleLabel(textAlignment: .left, fontSize: 25)
    let ratingView = RatingView()
    var genreCollectionView = AutoSizingCollectionView(frame: .zero, collectionViewLayout: CustomCollectionViewLayout())
    
    let overview = OverviewLabel()
    
    let castLabel = MHTitleLabel(textAlignment: .left, fontSize: 20)
    var castCollectionView = CastCollectionView(frame: .zero)
    
    let trailerButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    
        castCollectionView.delegate = self
                    
        let favButton = UIBarButtonItem(image: emptyStarImageView, style: .done, target: self, action: #selector(saveToFavorites))
        navigationItem.rightBarButtonItem = favButton
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(back))
        navigationItem.leftBarButtonItem = backButton
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(trailerTapped))
        trailerButton.addGestureRecognizer(tapGesture)
        
        layoutUI()
        setData()
        
        genreCollectionView.reloadData()
    }
    
    @objc func trailerTapped()
    {
        guard let youtubeKey else { return }
        print("nem")
        let youtubeAppURL = URL(string: "youtube://\(youtubeKey)")!
        let youtubeWebURL = URL(string: "https://www.youtube.com/watch?v=\(youtubeKey)")!
        
        if UIApplication.shared.canOpenURL(youtubeAppURL) {
            UIApplication.shared.open(youtubeAppURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(youtubeWebURL, options: [:], completionHandler: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.setNavigationBarHidden(false, animated: true)
        getCredits()
        getTrailer()
        getStarImage()
    }
    
    func PersonDidTapped(personID: Int) {
        let personVC = PersonVC()
        personVC.personID = personID
        navigationController?.pushViewController(personVC, animated: true)
    }
    
    @objc func back()
    {
        navigationController?.popViewController(animated: true)
    }
    
    func setData()
    {
        title = movie.release_date != nil ? "Movie Details" : "TV Series Details"
        overview.text = movie.overview
        
        if let genre_ids = movie.genre_ids
        {
            genres = genre_ids.map{ movie.release_date != nil ? genresDictionary[$0]! : genresDictionaryTV[$0]!}
        } else
        {
            if let movieGenres = movie.genres
            {
                for genre in movieGenres {
                    genres.append(genre.name)
                }
            }
        }

        
        // Image
        guard let posterURL = movie.poster_path else { return }
        moviePoster.downloadImage(from: ("https://image.tmdb.org/t/p/w500/" + posterURL))
        moviePoster.contentMode = .scaleToFill
        
        // Title
        movieTitleLabel.text = movie.title ?? movie.name
        castLabel.text = "Cast & Crew"
        
        // Rating
        guard let vote = movie.vote_average else { return }
        ratingView.setRatingLabel(ratingText: String(format: "%.1f", vote))
    }
    
    
    func layoutUI()
    {
        layoutScrollView()
        layoutContentView()
        layoutMoviePoster()
        layoutTrailerButton()
        layoutMovieTitleLabel()
        layoutRatingView()
        layoutGenreCV()
        layoutOverview()
        layoutCastLabel()
        layoutCastCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        movieTitleLabel.sizeToFit()
        overview.sizeToFit()
        castLabel.sizeToFit()
        
        
    }
    
    func getCredits()
    {
        if movie.name != nil
        {
            NetworkManager.shared.getCreditsTV(tvID: "\(movie.id)") { [weak self] result in
                guard let self = self else { return }
                creditsResultHandler(result: result)
            }
        }
        else {
            NetworkManager.shared.getCredits(movieID: "\(movie.id)") { [weak self] result in
                guard let self = self else { return }
                creditsResultHandler(result: result)

            }
        }
    }
    
    private func creditsResultHandler(result: Result<CastAndCrew, MHError>)
    {
        switch result {
        case .success(let credits):
            if !credits.actors.isEmpty || !credits.director.isEmpty
            {
                castCollectionView.configure(castAndCrew: credits.toCastCollectionModels())
            } else {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {return}
                    self.castLabel.removeFromSuperview()
                    self.castCollectionView.removeFromSuperview()
                    self.layoutOverviewAfterAPI()
                }
            }
            castCollectionView.configure(castAndCrew: credits.toCastCollectionModels())
        case .failure(let error):
            self.presentMHAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    func getTrailer()
    {
        NetworkManager.shared.getTrailer(isTV: movie.release_date == nil, movieID: movie.id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let trailer):
                youtubeKey = trailer?.key
            case .failure(_):
                presentMHAlertOnMainThread(title: "Something Went Wrong", message: "Some problem occurred during getting trailer.", buttonTitle: "Ok")
            }
            
        }
    }
    
    func getStarImage()
    {
        showLoadingViewFullAlpha(inView: self.view)
        
        FirebasePersistenceManager.shared.isInFavorites(movieID: movie.id, isMovie: movie.title != nil) { [weak self] isInFavs in
            guard let self = self else {return}
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.dismissLoadingView()
                self.navigationItem.rightBarButtonItem?.image = isInFavs ? filledStarImageView : emptyStarImageView
            }
            
            self.persistanceAction = isInFavs ? PersistenceActionType.remove : PersistenceActionType.add
        }
    }
    
    @objc func saveToFavorites()
    {
        showLoadingViewFullAlpha(inView: self.view)
        switch persistanceAction {
        case .add:
            
            FirebasePersistenceManager.shared.updateWith(movieID: movie.id, isMovie: movie.title != nil, actionType: .add) { [weak self] error in
                guard let self = self else {return}
                self.firebasePersistenceHandler(error: error, persistanceAction_: PersistenceActionType.add)
            }
            
        case .remove:
            
            FirebasePersistenceManager.shared.updateWith(movieID: movie.id, isMovie: movie.title != nil, actionType: .remove) { [weak self] error in
                guard let self = self else {return}
                self.firebasePersistenceHandler(error: error, persistanceAction_: PersistenceActionType.remove)
            }
        }
    }
    
    private func firebasePersistenceHandler(error: Error?, persistanceAction_: PersistenceActionType)
    {
        guard let error = error else {
            dismissLoadingView()
            persistanceAction = persistanceAction_ == .add ? .remove : .add
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.25)
                {
                    self.navigationItem.rightBarButtonItem?.image = persistanceAction_ == .add ? self.filledStarImageView : self.emptyStarImageView
                }
            }
            
            return
        }
        
        self.presentMHAlertOnMainThread(title: "Something went wrong.", message: error.localizedDescription, buttonTitle: "Ok")
    }
}


// Collection View Delegate Methods
extension MovieInfoVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.identifier, for: indexPath) as? GenreCell else {
            return UICollectionViewCell()
        }
        cell.configure(genre: genres[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let genre = genres[indexPath.item]
        let textSize = (genre as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 18, weight: .medium)])
        return CGSize(width: textSize.width + 21, height: textSize.height + 11)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}


// Custom Collection View Layout Configuration
class CustomCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        sectionInset = .zero
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView else { return nil }
        
        var attributes = [UICollectionViewLayoutAttributes]()
        var leftMargin: CGFloat = sectionInset.left
        var maxY: CGFloat = -1.0
        
        for sectionIndex in 0..<collectionView.numberOfSections {
            for itemIndex in 0..<collectionView.numberOfItems(inSection: sectionIndex) {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                if let attribute = layoutAttributesForItem(at: indexPath) {
                    if attribute.frame.maxY > maxY {
                        leftMargin = sectionInset.left
                        maxY = attribute.frame.maxY
                    }
                    attribute.frame.origin.x = leftMargin
                    leftMargin += attribute.frame.width + minimumInteritemSpacing
                    attributes.append(attribute)
                }
            }
        }
        
        return attributes
    }
}

class AutoSizingCollectionView : UICollectionView
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (!self.bounds.size.equalTo(self.intrinsicContentSize)) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize
    {
        return self.collectionViewLayout.collectionViewContentSize
    }
}
