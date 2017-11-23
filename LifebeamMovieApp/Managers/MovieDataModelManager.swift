//
//  MovieDataModelManager.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/20/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit
import CoreData

final class MovieDataModelManager: NSObject {
  
  // MARK: - Properties
  private let LOG_TAG = "MovieDataModelManager"
  private let limit: Int = Constants.DataModel.Limit
  private let dataModelName: String
  var isEmpty: Bool {
    let movieRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
    let genreRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GenreEntity")
    do {
      let movies = try moc.fetch(movieRequest) as! [MovieEntity]
      let genres = try moc.fetch(genreRequest) as! [GenreEntity]
      return (movies.count == 0 || genres.count == 0)
    } catch {
      fatalError("Failed to fetch movies or genres: \(error)")
    }
  }
  
  // MARK: - Initialization
  init(dataModelName: String) {
    self.dataModelName = dataModelName
  }
  
  // MARK: - Core data stack
  private lazy var moc: NSManagedObjectContext = {
    let moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
    moc.persistentStoreCoordinator = self.psc
    return moc
  }()
  
  private lazy var mom: NSManagedObjectModel = {
    guard let cacheURL = Bundle.main.url(forResource: dataModelName, withExtension:"momd") else {
      fatalError("Error loading model from bundle")
    }
    
    guard let mom = NSManagedObjectModel(contentsOf: cacheURL) else {
      fatalError("Error initializing mom from: \(cacheURL)")
    }
    
    return mom
  }()
  
  
  private lazy var psc: NSPersistentStoreCoordinator = {
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
    
    guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
      fatalError("Unable to resolve document directory")
    }
    
    let storeURL = docURL.appendingPathComponent("MovieDataModel.sqlite")
    
    do {
      try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    } catch {
      fatalError("Error migrating store: \(error)")
    }
    
    return psc
  }()
  
  // MARK: - Helpers
  func saveMovie(_ movie: Movie) {
    MovieEntity(movie: movie, context: moc)
    
    do {
      try moc.save()
    } catch {
      fatalError("Failure to save context: \(error)")
    }
  }
  
  func saveGenre(_ genre: Genre) {
    GenreEntity(genre: genre, context: moc)
    
    do {
      try moc.save()
    } catch {
      fatalError("Failure to save context: \(error)")
    }
  }
  
  func fetchMovies() -> [MovieEntity] {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
    do {
      let movies = try moc.fetch(request) as! [MovieEntity]
      return movies
    } catch {
      fatalError("Failed to fetch movies: \(error)")
    }
  }
  
  func fetchGenres() -> [GenreEntity] {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "GenreEntity")
    do {
      let genres = try moc.fetch(request) as! [GenreEntity]
      return genres
    } catch {
      fatalError("Failed to fetch movies: \(error)")
    }
  }
  
  func deleteMovies() {
    let movieFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
    let movieDeleteRequest = NSBatchDeleteRequest(fetchRequest: movieFetchRequest)
    
    do {
      try psc.execute(movieDeleteRequest, with: moc)
    } catch let error as NSError {
      fatalError("Failed to delete movie records: \(error)")
    }
  }
  
  func deleteAll() {
    let movieFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieEntity")
    let genreFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GenreEntity")
    let movieDeleteRequest = NSBatchDeleteRequest(fetchRequest: movieFetchRequest)
    let genreDeleteRequest = NSBatchDeleteRequest(fetchRequest: genreFetchRequest)
    
    do {
      try psc.execute(movieDeleteRequest, with: moc)
      try psc.execute(genreDeleteRequest, with: moc)
    } catch let error as NSError {
      fatalError("Failed to delete all records: \(error)")
    }
  }
}
