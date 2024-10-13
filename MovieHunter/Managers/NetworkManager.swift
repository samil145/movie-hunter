import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let movieBaseURL = "https://api.themoviedb.org/3/search/movie?query="
    private let creditsBaseURL = "https://api.themoviedb.org/3/movie/"
    private let personBaseURL = "https://api.themoviedb.org/3/person/"
    let bearerToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0YmJlODdlMDBjMWM2NzkwODIwMWM5NGI2OTcyYzM5ZiIsIm5iZiI6MTcyMzIyMzY5MS45MDg3NjIsInN1YiI6IjVhZDgzOTdmMGUwYTI2NDMzZjAwY2I4NiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.784Q42rdxeDoIio-d4aXRheXk_gs3NspgBU8hqYMU14"
    
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getMovies(for movieTitle: String, page: Int, completed: @escaping (Result<[Movie], MHError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        var allMovies: [Movie] = []
        var fetchError: MHError?

        // First API call (page)
        dispatchGroup.enter()
        fetchMovies(from: movieBaseURL + "\(movieTitle)&page=\(page)") { result in
            switch result {
            case .success(let movies):
                allMovies.append(contentsOf: movies)
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        // Second API call (page + 1)
        dispatchGroup.enter()
        fetchMovies(from: movieBaseURL + "\(movieTitle)&page=\(page + 1)") { result in
            switch result {
            case .success(let movies):
                allMovies.append(contentsOf: movies)
            case .failure(let error):
                fetchError = error
            }
            dispatchGroup.leave()
        }
        
        // Notify when both tasks are completed
        dispatchGroup.notify(queue: .main) {
            if let error = fetchError {
                completed(.failure(error))
            } else {
                completed(.success(allMovies))
            }
        }
    }
    
    func getTrailer(isTV: Bool = false, movieID: Int, completed: @escaping (Result<Trailer?, MHError>) -> Void)
    {
        let endpoint = isTV ? "https://api.themoviedb.org/3/tv/\(movieID)/videos" : "https://api.themoviedb.org/3/movie/\(movieID)/videos"
        
        performAPICall(endpoint: endpoint) { (result: Result<TrailerResponse, MHError>) in
            switch result {
            case .success(let trailerResponse):
                
                let trailer = trailerResponse.results.filter { trailer in
                    return trailer.official && trailer.site == "YouTube" && trailer.type == "Trailer"
                }.first
                
                completed(.success(trailer))
                
            case .failure(let error):
                completed(.failure(.invalidData))
            }
        }
    }
    
    
    func getCredits(movieID: String, completed: @escaping (Result<CastAndCrew, MHError>) -> Void)
    {
        let endpoint = creditsBaseURL + "\(movieID)/credits?language=en-US"
        
        performAPICall(endpoint: endpoint) {  [weak self] (result: Result<CreditsResponse, MHError>) in
            guard let self = self else { return }
            switch result {
            case .success(let creditsResponse):
                
                completed(.success(self.handleCreditsResponse(creditsResponse: creditsResponse)))
                
            case .failure(let error):
                completed(.failure(.invalidData))
            }
        }
    }
    
    func getCreditsTV(tvID: String, completed: @escaping (Result<CastAndCrew, MHError>) -> Void)
    {
        let endpoint = "https://api.themoviedb.org/3/tv/" + "\(tvID)/credits?language=en-US"
        
        performAPICall(endpoint: endpoint) { [weak self] (result: Result<CreditsResponse, MHError>) in
            guard let self = self else { return }
            switch result {
            case .success(let creditsResponse):
                
                completed(.success(self.handleCreditsResponse(creditsResponse: creditsResponse)))
                
            case .failure(let error):
                completed(.failure(.invalidData))
            }
        }
    }
    
    func getPerson(personID: Int, completed: @escaping (Result<Person, MHError>) -> Void)
    {
        let endpoint = personBaseURL + "\(personID)?language=en-US"
        
        performAPICall(endpoint: endpoint) { (result: Result<Person, MHError>) in
            switch result {
            case .success(let person):
                completed(.success(person))
            case .failure(let error):
                completed(.failure(.invalidData))
            }
        }
    }
    
    func getTrendingMovies(completed: @escaping (Result<[Movie], MHError>) -> Void) {
        
        let endpoint = "https://api.themoviedb.org/3/trending/movie/day?language=en-US&page=1"
        
        getHomeAPIs(endpoint: endpoint, isTV: false, completed: completed)
    
    }
    
    func getTrendingTvs(completed: @escaping (Result<[Movie], MHError>) -> Void) {
        
        let endpoint = "https://api.themoviedb.org/3/trending/tv/day?language=en-US&page=1"
        
        getHomeAPIs(endpoint: endpoint, isTV: true, completed: completed)
    
    }
    
    func getUpcomingMovies(completed: @escaping (Result<[Movie], MHError>) -> Void) {
        
        let endpoint = "https://api.themoviedb.org/3/movie/upcoming?language=en-US&page=1"
    
        getHomeAPIs(endpoint: endpoint, isTV: false, completed: completed)
    }
    
    func getPopular(completed: @escaping (Result<[Movie], MHError>) -> Void) {
        let endpoint = "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1"
        
        getHomeAPIs(endpoint: endpoint, isTV: false, completed: completed)
    }
    
    func getTopRated(completed: @escaping (Result<[Movie], MHError>) -> Void) {
        
        let endpoint = "https://api.themoviedb.org/3/movie/top_rated?language=en-US&page=1"
        
        getHomeAPIs(endpoint: endpoint, isTV: false, completed: completed)
    
    }
    
    func getDiscoverMovies(completed: @escaping (Result<[Movie], MHError>) -> Void)
    {
        let endpoint = "https://api.themoviedb.org/3/discover/movie?language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate"
        
        getHomeAPIs(endpoint: endpoint, isTV: false, completed: completed)
    }
    
    func getHomeAPIs(endpoint: String, isTV: Bool, completed: @escaping (Result<[Movie], MHError>) -> Void)
    {
        
        performAPICall(endpoint: endpoint) { (result: Result<MovieResponse, MHError>) in
            switch result {
            case .success(let movieResponse):
                
                let filteredMovies = movieResponse.results.filter { movie in
                    guard let overview = movie.overview else { return false }
                    return (movie.release_date != nil || movie.first_air_date != nil) && (movie.title != nil || movie.name != nil) && movie.poster_path != nil && !overview.isEmpty && movie.genre_ids != nil
                }.sorted{ $0.vote_count > $1.vote_count }
                
                completed(.success(filteredMovies))
                
            case .failure(let error):
                completed(.failure(.invalidData))
            }
        }
    }
    
    func getMovieFromID(from ID: Int, isMovie: Bool, completed: @escaping (Result<Movie, MHError>) -> Void) {
        
        let endpoint = isMovie ? "https://api.themoviedb.org/3/movie/\(ID)?language=en-US" : "https://api.themoviedb.org/3/tv/\(ID)?language=en-US"
        
        performAPICall(endpoint: endpoint) { (result: Result<Movie, MHError>) in
            switch result {
            case .success(let movie):
                completed(.success(movie))
            case .failure(let error):
                completed(.failure(.invalidData))
            }
        }
    }
    
    
    
    private func fetchMovies(from urlString: String, completed: @escaping (Result<[Movie], MHError>) -> Void) {
        
        
        performAPICall(endpoint: urlString) { (result: Result<MovieResponse, MHError>) in
            switch result {
            case .success(let movieResponse):
                
                if movieResponse.results.count < 20 { MovieListVC.hasMoreMovies = false }
                
                let filteredMovies = movieResponse.results.filter { movie in
                    guard let overview = movie.overview else { return false }
                    return movie.release_date != nil && movie.title != nil && movie.poster_path != nil && !overview.isEmpty && movie.genre_ids != nil
                }.sorted{ $0.vote_count > $1.vote_count }
                
                completed(.success(filteredMovies))
                
            case .failure(let error):
                completed(.failure(.invalidData))
            }
        }
    }
    
    
    func performAPICall<T: Codable>(endpoint: String, completed: @escaping (Result<T, MHError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidMovieTitle))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Headers
        request.addValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(T.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    private func handleCreditsResponse(creditsResponse: CreditsResponse) -> CastAndCrew
    {
        let actors = Array(creditsResponse.cast.filter { actor in
            guard let id = actor.id, let name = actor.name, let roleName = actor.character, let posterURL = actor.profile_path, let gender = actor.gender else { return false }
            return !name.isEmpty && !posterURL.isEmpty
        }.prefix(5))
        
        
        let directors = creditsResponse.crew.filter{ director in
            guard let id = director.id, let name = director.name, let posterURL = director.profile_path, let job = director.job else { return false }
            return director.job == "Director"
        }
        
        let actorsAndDirector = CastAndCrew(actors: actors, director: directors)
        return actorsAndDirector
    }
}
