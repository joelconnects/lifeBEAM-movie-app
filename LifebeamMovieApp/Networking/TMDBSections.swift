//
//  TMDBResultsParser.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/19/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

typealias TMDBSections = (discover: TMDBDiscover?, genres: TMDBGenres?, images: Data?)
typealias TMDBSectionResults = Result<TMDBSections>

struct TMDBDiscover: Decodable {
  
  // MARK: - Properties
  let page: Int
  let totalResults: Int
  let totalPages: Int
  let movies: [Movie]
  
  // MARK: - Coding keys
  enum CodingKeys: String, CodingKey {
    case page
    case totalResults = "total_results"
    case totalPages = "total_pages"
    case movies = "results"
  }
}

struct TMDBGenres: Decodable {

  // MARK: - Properties
  let genres: [Genre]
}
