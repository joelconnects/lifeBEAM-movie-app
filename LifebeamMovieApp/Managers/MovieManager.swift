//
//  MovieManager.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/21/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

class MovieManager {
 
  private let LOG_TAG = "MovieManager"
  
  // MARK: - Properties
  private var movieDataModelManager: MovieDataModelManager
  private var nextPageLoadInProgress: Bool = false
  private var currentPage: Int = 0
  
  lazy var movies: [Movie] = []
  lazy var genres: [Int: String] = [:]
  lazy var images: [Int: UIImage] = [:]

  private var savedPage: Int {
    get {
      return UserDefaults().integer(forKey: Constants.User.CurrentPage)
    }
    set {
      UserDefaults().set(newValue, forKey: Constants.User.CurrentPage)
    }
  }
  
  // MARK: - Initialization
  init(movieDataModelManager: MovieDataModelManager) {
    self.movieDataModelManager = movieDataModelManager
    savedPage = 0
    loadMovies()
  }

  // MARK: - Loading
  private func loadMovies(attempts: Int = 0) {
    if attempts == 3 {
      DispatchQueue.main.async {
        AlertPresenter.presentDefaultAlert(title: Constants.Alert.DefaultTitle, message: Constants.Alert.RetryFailedMessage, actionTitle: Constants.Alert.RetryFailedActionTitle, dismissalCallback: {
          Log.f(tag: self.LOG_TAG, message: "Retry reached maximum attempts and failed")
        })
      }
      return
    }
    
    loadTMDBSections { success in
      if success {
        self.movieDataModelManager.deleteAll()
        self.saveMovies()
        self.saveGenres()
        DispatchQueue.main.async {
          NotificationCenter.default.post(name: .moviesReadyToDisplay, object: nil)
        }
        
      } else if !success && !self.movieDataModelManager.isEmpty {
        self.movies = MovieEntity.convert(self.movieDataModelManager.fetchMovies())
        self.genres = GenreEntity.convert(self.movieDataModelManager.fetchGenres())
        DispatchQueue.main.async {
          NotificationCenter.default.post(name: .moviesReadyToDisplay, object: nil)
        }
        
      } else {
        Log.e(tag: self.LOG_TAG, message: "load TMDB sections failed")
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(attempts) * 1.5, execute: {
          AlertPresenter.presentDefaultAlert(title: Constants.Alert.DefaultTitle, message: Constants.Alert.DefaultMessage, actionTitle: Constants.Alert.DefaultActionTitle, dismissalCallback: {
            self.loadMovies(attempts: attempts + 1)
          })
        })
      }
    }
  }
  
  private func loadTMDBSections(completion: @escaping (Bool) -> ()) {
    let queue = DispatchQueue(label: "com.lifebeammovieapp.dispatchgroup", attributes: .concurrent)
    let group = DispatchGroup()
    var errors: Int = 0
    
    group.enter()
    queue.async (group: group) {
      self.loadDiscoverSection(completion: { error in
        if error != nil {
          Log.e(tag: self.LOG_TAG, message: "\(error!.localizedDescription)")
          errors += 1
        }
        group.leave()
      })
    }
    
    group.enter()
    queue.async (group: group) {
      self.loadGenresSection(completion: { error in
        if error != nil {
          Log.e(tag: self.LOG_TAG, message: "\(error!.localizedDescription)")
          errors += 1
        }
        group.leave()
      })
    }
    
    group.notify(queue: .main) {
      let errorsOccurred = (errors > 0) ? true : false
      completion(!errorsOccurred)
    }
  }
  
  private func loadDiscoverSection(completion: @escaping (Error?) -> ()) {
    let router = TMDBRouter(section: .discover(page: currentPage + 1))
    TMDBAPIClient.request(router, completion: { results in
      switch results {
      case .success(let result):
        if let discover = result.discover {
          self.currentPage = discover.page
          self.savedPage = discover.page
          self.movies.append(contentsOf: discover.movies)
          completion(nil)
        }
      case .failure(let error):
        completion(error)
      }
    })
  }
  
  private func loadGenresSection(completion: @escaping (Error?) -> ()) {
    let router = TMDBRouter(section: .genres)
    TMDBAPIClient.request(router, completion: { results in
      switch results {
      case .success(let result):
        if let genres = result.genres {
          self.genres = Genre.generateGenreDictionary(genres.genres)
          completion(nil)
        }
      case .failure(let error):
        completion(error)
      }
    })
  }
  
  private func loadNextPage() {
    nextPageLoadInProgress = true
    
    loadDiscoverSection { error in
      if error == nil {
        self.movieDataModelManager.deleteMovies()
        self.saveMovies()
        self.nextPageLoadInProgress = false
        DispatchQueue.main.async {
          NotificationCenter.default.post(name: .moviesReadyToDisplay, object: nil)
        }
      } else {
        Log.e(tag: self.LOG_TAG, message: "load next page failed")
        DispatchQueue.main.async {
          AlertPresenter.presentDefaultAlert(title: Constants.Alert.DefaultTitle, message: Constants.Alert.DefaultMessage, actionTitle: Constants.Alert.NextPageActionTitle, dismissalCallback: nil)
        }
      }
    }
  }
  
  // MARK: - Save
  private func saveMovies() {
    for movie in movies {
      self.movieDataModelManager.saveMovie(movie)
    }
  }
  
  private func saveGenres() {
    for (id, name) in genres {
      let genre = Genre(id: id, name: name)
      self.movieDataModelManager.saveGenre(genre)
    }
  }
  
  // MARK: - Helpers
  func requestMovies() {
    if !nextPageLoadInProgress {
      currentPage = savedPage
      loadNextPage()
    }
  }
  
  func genresForDisplay(_ genreIds: [Int]?) -> String? {
    guard let identifiers = genreIds else {
      return nil
    }
    guard !identifiers.isEmpty else {
      return nil
    }
    
    var names: [String] = []
    for id in identifiers {
      if let id = genres[id] {
        names.append(id)
      }
    }
    names.sort { $0 < $1 }
    return names.joined(separator: ", ")
  }
  
  func imageForDisplay(movie: Movie, completion: @escaping (UIImage?, Error?) -> ()) {
    let router = TMDBRouter(section: .images(path: movie.posterPath))
    TMDBAPIClient.request(router) { results in
      switch results {
      case .success(let result):
        if let imageData = result.images {
          let imageFromData = UIImage(data: imageData)
          let croppedImage = imageFromData?.cropPoster()
          self.images[movie.id] = croppedImage
          completion(croppedImage, nil)
        } else {
          completion(nil, NetworkError.parsingError)
        }
      case .failure(let error):
        completion(nil, error)
      }
    }
  }
}
