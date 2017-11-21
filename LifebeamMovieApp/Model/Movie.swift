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
}
