//
//  MovieEntity+CoreDataClass.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/21/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MovieEntity)
public class MovieEntity: NSManagedObject {
  
  @discardableResult
  convenience init?(movie: Movie, context: NSManagedObjectContext) {
    guard let entity = NSEntityDescription.entity(forEntityName: "MovieEntity", in: context) else {
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
  
  class func convert(_ savedMovies: [MovieEntity]) -> [Movie] {
    var movies = [Movie]()
    
    for savedMovie in savedMovies {
      var mAdult: Bool?
      if let cAdult = savedMovie.adult {
        mAdult = Bool(truncating: cAdult)
      }
      
      var mPopularity: Double?
      if let cPopularity = savedMovie.popularity {
        mPopularity = Double(truncating: cPopularity)
      }
      
      var mVideo: Bool?
      if let cVideo = savedMovie.video {
        mVideo = Bool(truncating: cVideo)
      }
      
      var mVoteAverage: Double?
      if let cVoteAverage = savedMovie.voteAverage {
        mVoteAverage = Double(truncating: cVoteAverage)
      }
      
      var mVoteCount: Int?
      if let cVoteCount = savedMovie.voteCount {
        mVoteCount = Int(truncating: cVoteCount)
      }
      
      let movie = Movie(
        adult: mAdult,
        backdropPath: savedMovie.backdropPath,
        genreIds: savedMovie.genreIds,
        id: Int(truncating: savedMovie.id),
        originalLanguage: savedMovie.originalLanguage,
        originalTitle: savedMovie.originalTitle,
        overview: savedMovie.overview,
        popularity: mPopularity,
        posterPath: savedMovie.posterPath,
        releaseDate: savedMovie.releaseDate,
        title: savedMovie.title,
        video: mVideo,
        voteAverage: mVoteAverage,
        voteCount: mVoteCount)
      
      movies.append(movie)
    }
    
    return movies
  }
}
