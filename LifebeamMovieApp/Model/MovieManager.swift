//
//  MovieManager.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/21/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

//typealias LoadedMovieResult = Result<[Movie]>

class MovieManager {
 
  // MARK: - Properties
  private var movieCacheManager: MovieCacheManager
  lazy var movies: [Movie] = []

  // MARK: - Initialization
  init(cacheManager: MovieCacheManager) {
    movieCacheManager = cacheManager
//    movieCacheManager.emptyCache()
  }

  // MARK: - Helpers
  func loadMovies(completion: @escaping (Error?) -> ()) {
    if movieCacheManager.isEmpty {
      let router = TMDBRouter(page: 1)
      TMDBAPIClient.request(router, completion: { results in
        switch results {
        case .success(let result):
          for movie in result.movies {
            self.movieCacheManager.save(movie)
          }
          self.movies = result.movies
          completion(nil)
        case .failure(let error):
          completion(error)
        }
      })
    } else {
      let cachedMovies = movieCacheManager.fetch()
      movies = Movie.convert(cachedMovies)
      completion(nil)
    }
  }
}
