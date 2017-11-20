//
//  TMDBRouter.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/19/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

struct TMDBRouter {
  
  // MARK: - Properties
  private let baseUrl: String = "https://api.themoviedb.org"
  private let path: String = "/3/discover/movie"
  private let queryKey: String = "?api_key=\(Secrets.TMDB.APIKey)"
  private let queryDefault: String = "&include_video=false&include_adult=false&language=en-US&sort_by=popularity.desc&page="
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
