//
//  TMDBAPIClient.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/18/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

struct TMDBRouter {
  
  // MARK: - Properties
  private let baseUrl: String = "https://api.themoviedb.org"
  private let path: String = "/3/discover/movie"
  private let queryKey: String = "?api_key=\(Secrets.TMDB.APIKey)"
  private let queryDefault: String = "&language=en-US&sort_by=popularity.desc&page="
  private let method: HTTPMethod = .get
  private var page: Int
  
  var urlRequest: URLRequest? {
    guard let url = URL(string: baseUrl + path + queryKey + queryDefault + "\(page)") else {
      return nil
    }
    let urlRequest = URLRequest(url: url)
    return urlRequest
  }
  
  // MARK: - Initialization
  init(page: Int) {
    self.page = page
  }
}

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
          let result = try JSONSerialization.jsonObject(with: data, options: [])
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
