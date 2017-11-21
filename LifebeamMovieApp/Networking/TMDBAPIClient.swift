//
//  TMDBAPIClient.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/18/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

typealias MovieResults = Result<TMDBResults>

struct TMDBAPIClient {
  
  // MARK: - Request
  static func request(_ router: TMDBRouter, completion: @escaping (MovieResults) -> ()) {
    guard let request = router.urlRequest else {
      completion(Result.failure(NetworkError.badRequest))
      return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      let result = ResultParser.parse((data, response, error))
      
      switch result {
      case .success(let data):
        do {
          let results = try JSONDecoder().decode(TMDBResults.self, from: data)
          completion(Result.success(results))
        } catch {
          completion(Result.failure(NetworkError.parsingError))
        }
      case .failure(let error):
        completion(Result.failure(error))
      }
    }.resume()
  }
}
