//
//  TMDBResultParser.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/19/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

struct TMDBResultParser: Decodable {
  
  private let LOG_TAG = "TMDBResultParser"
  
  // MARK: - Properties
  let page: Int
  let totalResults: Int
  let totalPages: Int
  let results: Decoder
  
  // MARK: - Coding keys
  enum CodingKeys: String, CodingKey {
    case page
    case totalResults = "total_results"
    case totalPages = "total_pages"
    case results
  }
    
  // MARK: - Initialization
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: TMDBResultParser.CodingKeys.self)
    self.page = try container.decode(Int.self, forKey: .page)
    self.totalResults = try container.decode(Int.self, forKey: .totalResults)
    self.totalPages = try container.decode(Int.self, forKey: .totalPages)
    
    var nestedContainer = try container.nestedUnkeyedContainer(forKey: .results)
    self.results = try nestedContainer.superDecoder()

    Log.d(tag: LOG_TAG, message: "results: \(results)")
  }
}
