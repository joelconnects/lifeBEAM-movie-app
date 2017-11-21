//
//  CachedMovie+CoreDataClass.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/21/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CachedMovie)
public class CachedMovie: NSManagedObject {
  
  @discardableResult
  convenience init?(movie: Movie, context: NSManagedObjectContext) {
    guard let entity = NSEntityDescription.entity(forEntityName: "CachedMovie", in: context) else {
      return nil
    }
    self.init(entity: entity, insertInto: context)
    
    if let adult = movie.adult {
      self.adult = NSNumber(booleanLiteral: adult)
    }
    
    if let popularity = movie.popularity {
      self.popularity = NSNumber(value: popularity)
    }
  
    if let video = movie.video {
      self.video = NSNumber(booleanLiteral: video)
    }
    
    if let voteAverage = movie.voteAverage {
      self.voteAverage = NSNumber(value: voteAverage)
    }
    
    if let voteCount = movie.voteCount {
      self.voteCount = NSNumber(integerLiteral: voteCount)
    }
    
    self.backdropPath = movie.backdropPath
    self.genreIds = movie.genreIds
    self.id = NSNumber(integerLiteral: movie.id)
    self.originalLanguage = movie.originalLanguage
    self.originalTitle = movie.originalTitle
    self.overview = movie.overview
    self.posterPath = movie.posterPath
    self.releaseDate = movie.releaseDate
    self.title = movie.title
  }
}
