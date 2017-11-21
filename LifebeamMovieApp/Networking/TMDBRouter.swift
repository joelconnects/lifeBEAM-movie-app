//
//  TMDBRouter.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/19/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

enum TMDBRouterSection {
  case discover(page: Int)
  case genres
}

struct TMDBRouter {
  
  // MARK: - Properties
  private let baseUrl: String = "https://api.themoviedb.org"
  private let apiKey: String = "?api_key=\(Secrets.TMDB.APIKey)"
  private let method: HTTPMethod = .get
  let section: TMDBRouterSection
  
  var urlRequest: URLRequest? {
    guard let url = URL(string: baseUrl + path() + apiKey + query()) else {
      return nil
    }
    let urlRequest = URLRequest(url: url)
    return urlRequest
  }
  
  // MARK: - Initialization
  init(section: TMDBRouterSection) {
    self.section = section
  }
  
  // MARK: - Helpers
  private func path() -> String {
    switch section {
    case .discover:
      return "/3/discover/movie"
    case .genres:
      return "/3/genre/movie/list"
    }
  }

  private func query() -> String {
    switch section {
    case .discover(page: let page):
      return "&include_video=false&include_adult=false&language=en-US&sort_by=popularity.desc&page=\(page)"
    case .genres:
      return "&language=en-US"
    }
  }
  
}
