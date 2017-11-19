//
//  Networking.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/18/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

// MARK: - Networking types
typealias MovieResult = Result<Any>
typealias DataTaskResponse = (data: Data?, urlResponse: URLResponse?, error: Error?)
typealias DataTaskParserResult = Result<Data?>

// MARK: - Result
enum Result<T> {
  case success(T)
  case failure(Error)
}

// MARK: - HTTP Method
enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

// MARK: - Networking errors
enum NetworkError: Error {
  case badRequest
  case badResponse
  case parsingError
  case notFound
  case operationError
  case modelError
  case serverError(statusCode: Int)
  case undefined(statusCode: Int)
  case other(Error)
}

// MARK: - Result parser
struct ResultParser {
  static func parse(_ response: DataTaskResponse) -> DataTaskParserResult {
    if let error = response.error {
      return .failure(NetworkError.other(error))
    }
    guard let urlResponse = response.urlResponse as? HTTPURLResponse else {
      return .failure(NetworkError.badResponse)
    }
    if let error = self.error(forStatusCode: urlResponse.statusCode) {
      return .failure(error)
    }
    if let data = response.data {
      return .success(data)
    } else {
      return .failure(NetworkError.parsingError)
    }
  }
  
  fileprivate static func error(forStatusCode code: Int) -> NetworkError? {
    switch code {
    case 200...299:
      return nil
    case 404, 410:
      return .notFound
    case 500...599:
      return .serverError(statusCode: code)
    default:
      return .undefined(statusCode: code)
    }
  }
}
