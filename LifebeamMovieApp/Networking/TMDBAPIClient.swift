//
//  TMDBAPIClient.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/18/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

struct TMDBAPIClient {
  
  // MARK: - Request
  static func request(_ router: TMDBRouter, completion: @escaping (TMDBSectionResults) -> ()) {
    guard let request = router.urlRequest else {
      completion(Result.failure(NetworkError.badRequest))
      return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      let result = ResultParser.parse((data, response, error))
      
      switch result {
      case .success(let data):
        do {
          switch router.section {
          case .discover:
            let discover = try JSONDecoder().decode(TMDBDiscover.self, from: data)
            completion(Result.success((discover, nil)))
          case .genres:
            let genres = try JSONDecoder().decode(TMDBGenres.self, from: data)
            completion(Result.success((nil, genres)))
          }
        } catch {
          completion(Result.failure(NetworkError.parsingError))
        }
      case .failure(let error):
        completion(Result.failure(error))
      }
    }.resume()
  }
}
