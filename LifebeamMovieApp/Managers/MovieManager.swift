//
//  MovieManager.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/21/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

class MovieManager {
 
  private let LOG_TAG = "MovieManager"
  
  // MARK: - Properties
  private var movieDataModelManager: MovieDataModelManager
  lazy var movies: [Movie] = []
  lazy var genres: [Int: String] = [:]

  // MARK: - Initialization
  init(movieDataModelManager: MovieDataModelManager) {
    self.movieDataModelManager = movieDataModelManager
    
    // TODO: Remove when complete
//    movieDataModelManager.deleteAll()
//    print("stop")
  }

  // MARK: - Loading
  func loadMovies(completion: @escaping (Bool) -> ()) {
    loadTMDBSections { success in
      if success {
        Log.d(tag: self.LOG_TAG, message: "load TMDB sections success")
        self.movieDataModelManager.deleteAll()
        self.saveMovies()
        self.saveGenres()
        completion(true)
      } else if !success && !self.movieDataModelManager.isEmpty {
        Log.d(tag: self.LOG_TAG, message: "load TMDB sections !success and !isEmpty")
        self.movies = MovieEntity.convert(self.movieDataModelManager.fetchMovies())
        self.genres = GenreEntity.convert(self.movieDataModelManager.fetchGenres())
        completion(true)
      } else {
        Log.d(tag: self.LOG_TAG, message: "load TMDB sections failed")
        completion(false)
      }
    }
  }
  
  private func loadTMDBSections(completion: @escaping (Bool) -> ()) {
    let queue = DispatchQueue(label: "com.lifebeammovieapp.dispatchgroup", attributes: .concurrent, target: .main)
    let group = DispatchGroup()
    var errors: Int = 0
    
    group.enter()
    queue.async (group: group) {
      self.loadDiscoverSection(completion: { error in
        Log.d(tag: self.LOG_TAG, message: "load discover section complete")
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
        Log.d(tag: self.LOG_TAG, message: "load genre section complete")
        if error != nil {
          Log.e(tag: self.LOG_TAG, message: "\(error!.localizedDescription)")
          errors += 1
        }
        group.leave()
      })
    }
    
    group.notify(queue: DispatchQueue.main) {
      Log.d(tag: self.LOG_TAG, message: "group notification")
      let errorsOccurred = (errors > 0) ? true : false
      completion(!errorsOccurred)
    }
  }
  
  private func loadDiscoverSection(completion: @escaping (Error?) -> ()) {
    let router = TMDBRouter(section: .discover(page: 1))
    TMDBAPIClient.request(router, completion: { results in
      switch results {
      case .success(let result):
        if let discover = result.discover {
          self.movies = discover.movies
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
  func generateGenresForDisplay(_ genreIds: [Int]?) -> String? {
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
}
