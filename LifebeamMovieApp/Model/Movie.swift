//
//  Movie.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/19/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

struct Movie: Decodable {
  
  // MARK: - Properties
  let adult: Bool?
  let backdropPath: String?
  let genreIds: [Int]
  let id: Int
  let originalLanguage: String?
  let originalTitle: String?
  let overview: String?
  let popularity: Double?
  let posterPath: String
  let releaseDate: String?
  let title: String
  let video: Bool?
  let voteAverage: Double?
  let voteCount: Int?
  
  // MARK: - Coding keys
  enum CodingKeys: String, CodingKey {
    case adult
    case backdropPath = "backdrop_path"
    case genreIds = "genre_ids"
    case id
    case originalLanguage = "original_language"
    case originalTitle = "original_title"
    case overview
    case popularity
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case title
    case video
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
  }
  
  // MARK: - Helpers
  static func convert(_ cachedMovies: [CachedMovie]) -> [Movie] {
    var movies = [Movie]()
    
    for cachedMovie in cachedMovies {
      var mAdult: Bool?
      if let cAdult = cachedMovie.adult {
        mAdult = Bool(truncating: cAdult)
      }
      
      var mPopularity: Double?
      if let cPopularity = cachedMovie.popularity {
        mPopularity = Double(truncating: cPopularity)
      }
      
      var mVideo: Bool?
      if let cVideo = cachedMovie.video {
        mVideo = Bool(truncating: cVideo)
      }
      
      var mVoteAverage: Double?
      if let cVoteAverage = cachedMovie.voteAverage {
        mVoteAverage = Double(truncating: cVoteAverage)
      }
      
      var mVoteCount: Int?
      if let cVoteCount = cachedMovie.voteCount {
        mVoteCount = Int(truncating: cVoteCount)
      }
      
      let movie = Movie(
        adult: mAdult,
        backdropPath: cachedMovie.backdropPath,
        genreIds: cachedMovie.genreIds,
        id: Int(truncating: cachedMovie.id),
        originalLanguage: cachedMovie.originalLanguage,
        originalTitle: cachedMovie.originalTitle,
        overview: cachedMovie.overview,
        popularity: mPopularity,
        posterPath: cachedMovie.posterPath,
        releaseDate: cachedMovie.releaseDate,
        title: cachedMovie.title,
        video: mVideo,
        voteAverage: mVoteAverage,
        voteCount: mVoteCount)
      
      movies.append(movie)
    }
    
    return movies
  }
}
