//
//  Genre.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/21/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

struct Genre: Decodable {
  
  // MARK: - Properties
  let id: Int
  let name: String
  
  // MARK: - Helpers
  static func generateGenreDictionary(_ genres: [Genre]) -> [Int: String] {
    var genreDictionary = [Int: String]()
    for genre in genres {
      genreDictionary[genre.id] = genre.name
    }
    return genreDictionary
  }
}
