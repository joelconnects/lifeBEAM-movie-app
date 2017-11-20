//
//  Logger.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/18/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import Foundation

class Log {
  
  // MARK: - Levels
  static func d(tag: String, message: String) {
    Log.log(tag: tag, logLevel: "DEBUG", message: message)
  }
  
  static func i(tag: String, message: String) {
    Log.log(tag: tag, logLevel: "INFO", message: message)
  }
  
  static func w(tag: String, message: String) {
    Log.log(tag: tag, logLevel: "WARN", message: message)
  }
  
  static func e(tag: String, message: String) {
    Log.log(tag: tag, logLevel: "ERROR", message: message)
  }
  
  static func f(tag: String, message: String) {
    Log.log(tag: tag, logLevel: "FATAL", message: message)
  }
  
  // MARK: - Helpers
  private static func log(tag: String, logLevel: String, message: String) {
    print("APP: \(Date()) \(logLevel)/\(tag): \(message)")
  }
}
