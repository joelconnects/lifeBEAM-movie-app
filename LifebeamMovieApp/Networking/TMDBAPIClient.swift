//
//  TMDBAPIClient.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/18/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

typealias MovieResult = Result<Any> // TODO: Remove if not in use

struct TMDBAPIClient {
  
  // MARK: - Request
  static func request(_ router: TMDBRouter, completion: @escaping (Result<Any>) -> ()) {
    guard let request = router.urlRequest else {
      completion(Result.failure(NetworkError.badRequest))
      return
    }
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      let result = ResultParser.parse((data, response, error))
      
      switch result {
      case .success(let data):
        do {
          guard let data = data else {
            completion(Result.failure(NetworkError.parsingError))
            return
          }
          let result = try JSONDecoder().decode(TMDBResultParser.self, from: data)
          completion(Result.success(result))
        } catch {
          completion(Result.failure(NetworkError.parsingError))
        }
      case .failure(let error):
        completion(Result.failure(error))
      }
    }.resume()
  }
}
