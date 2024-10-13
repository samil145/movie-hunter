//
//  HomeVC.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 01.09.24.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeVC: UIViewController {
    
    enum MenuState
    {
        case open
        case close
    }
    
    private var menuState: MenuState = .close
    
    // Views
    
    var menuView    = MenuView()
    var overlayView = UIView(frame: .zero)
    let logo        = UIImage(named: "movieIcon")!.withRenderingMode(.alwaysOriginal)
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.identifier)
        return table
    }()
    
    var statusBarHeight: CGFloat = 0
    
    private var randomTrendingMovie: Movie?
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        configureNavbar()
        
        menuView.delegate = self
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.separatorStyle = .none
        
        homeFeedTable.frame = view.bounds
        homeFeedTable.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = ""
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        menuView.frame = CGRect(x: 0, y: self.statusBarHeight, width: 0, height: 0)
        
        AuthService.shared.fetchUser { [weak self] user, error in
            guard let self = self else { return }
            if error != nil
            {
                presentMHAlertOnMainThread(title: "Something Went Wrong", message: "Error occured during fetching user information. Please try again.", buttonTitle: "Ok")
                return
            }
            
            if let user = user
            {
                menuView.setUsername(username: user.username)
            }
            
        }
    }
    
    private func configureNavbar() {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        button.setImage(logo, for: .normal)
        button.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        logoContainer.addSubview(button)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoContainer)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(searchMovie))
    
        navigationController?.navigationBar.tintColor = .systemGreen
    }
    
    @objc func searchMovie()
    {
        let vc = MovieListVC()
        vc.title = "Search"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openMenu()
    {
        setupMenuView()
        menuView.hideViews()
        setupOverlayView()
        
        if let keyWindow = UIApplication.shared.connectedScenes.flatMap({ ($0 as? UIWindowScene)?.windows ?? [] }).last(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(self.menuView)
            keyWindow.addSubview(self.overlayView)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            self.menuView.showViews()
            self.menuView.frame = CGRect(x: 0, y: self.statusBarHeight, width: self.view.frame.size.width * 0.6, height: self.view.frame.size.height - self.statusBarHeight)
            self.menuView.alpha = 1
            self.view.alpha = 0.5
        } completion: { [weak self] done in
            
            guard let self = self else { return }
            
            if done {
                self.menuState = .open
            }
        }
    }
    
    @objc func handleOverlayTapGesture(_ gesture: UITapGestureRecognizer) {
        closeMenu(completed: {})
    }
    
    @objc func closeMenu(completed: @escaping () -> Void)
    {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            self.menuView.hideViews()
            self.menuView.frame = CGRect(x: 0, y: self.statusBarHeight, width: 0, height: self.view.frame.size.height - self.statusBarHeight)
            self.overlayView.alpha = 0
            self.view.alpha = 1
        } completion: { [weak self] done in
            guard let self = self else { return }
            
            if done
            {
                
                self.menuView.removeFromSuperview()
                self.overlayView.removeFromSuperview()
                
                self.menuState = .close
                
            }
            completed()
        }
    }
    
    func setupMenuView()
    {
        menuView.frame = CGRect(x: 0, y: statusBarHeight, width: 0, height: view.frame.size.height - statusBarHeight)
        menuView.alpha = 0
        menuView.backgroundColor = UIColor(named: "menuColor")
    }
    
    func setupOverlayView()
    {
        overlayView = UIView(frame: CGRect(x: view.frame.size.width * 0.6, y: 0, width: view.frame.size.width - view.frame.size.width * 0.6, height: UIScreen.main.bounds.height))
        overlayView.backgroundColor = UIColor.clear
        overlayView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOverlayTapGesture))
        overlayView.addGestureRecognizer(tapGesture)
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        

        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            
            NetworkManager.shared.getTrendingMovies { [weak self] result in
                guard let self = self else { return }
                
                completionHandler(cell: cell, result: result)
            }
            
        case Sections.TrendingTv.rawValue:
            
            NetworkManager.shared.getTrendingTvs { [weak self] result in
                guard let self = self else { return }
                
                completionHandler(cell: cell, result: result)
            }
            
        case Sections.Popular.rawValue:
            
            NetworkManager.shared.getPopular { [weak self] result in
                guard let self = self else { return }
                
                completionHandler(cell: cell, result: result)
            }
            
        case Sections.Upcoming.rawValue:
            
            NetworkManager.shared.getUpcomingMovies { [weak self] result in
                guard let self = self else { return }
                
                completionHandler(cell: cell, result: result)
            }
            
        case Sections.TopRated.rawValue:
            
            NetworkManager.shared.getTopRated { [weak self] result in
                guard let self = self else { return }
                
                completionHandler(cell: cell, result: result)
            }
            
        default:
            return UITableViewCell()

        }
        
        return cell
    }
    
    func completionHandler(cell: HomeTableViewCell, result: Result<[Movie], MHError>)
    {
        switch result {
        case .success(let movies):
            cell.configure(with: movies)
        case .failure(let error):
            self.presentMHAlertOnMainThread(title: "Something Went Wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textAlignment = .left
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x - 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
}



extension HomeVC: HomeTableViewCellDelegate {
    func homeTableViewCellDidTapCell(_ cell: HomeTableViewCell, movie: Movie) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let vc = MovieInfoVC()
            vc.movie = movie
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeVC: MenuViewDelegate {
    func searchButtonTapped() {
        closeMenu
        { [weak self] in
            guard let self = self else { return }
            let vc = MovieListVC()
            vc.title = "Search"
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func favButtonTapped() {
        closeMenu
        {[weak self] in
            guard let self = self else { return }
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 1
            }
        }
    }
    
    func signOutTapped() {
        showLoadingView()
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }

            if let error = error
            {
                presentMHAlertOnMainThread(title: "Something Went Wrong", message: error.localizedDescription, buttonTitle: "Ok")
                return
            }

            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate
            {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    sceneDelegate.checkAuth()
                    self.dismissLoadingView()
                }
            }
            
        }
    }
}
