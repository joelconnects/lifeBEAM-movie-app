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
  case images(path: String)
}

struct TMDBRouter {
  
  // MARK: - Properties
  private let baseUrl: String = "https://api.themoviedb.org"
  private let baseImageUrl: String = "https://image.tmdb.org"
  private let apiKey: String = "?api_key=\(Secrets.TMDB.APIKey)"
  private let method: HTTPMethod = .get
  let section: TMDBRouterSection
  
  var urlRequest: URLRequest? {
    var url: URL?
    switch section {
    case .discover, .genres:
      url = URL(string: baseUrl + path() + apiKey + query())
    case .images:
      url = URL(string: baseImageUrl + path() + query())
    }
    
    guard let validUrl = url else {
      return nil
    }
    
    let urlRequest = URLRequest(url: validUrl)
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
    case .images:
      return "/t/p/w500/"
    }
  }

  private func query() -> String {
    switch section {
    case .discover(let page):
      return "&include_video=false&include_adult=false&language=en-US&sort_by=popularity.desc&page=\(page)"
    case .genres:
      return "&language=en-US"
    case .images(let path):
      return path
    }
  }
}
