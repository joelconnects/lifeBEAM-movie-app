//
//  MovieCacheManager.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/20/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit
import CoreData

final class MovieCacheManager: NSObject {
  
  // MARK: - Properties
  private let LOG_TAG = "MovieCacheManager"
  private let limit: Int = Constants.DataModel.Limit
  private let dataModelName: String
  var isEmpty: Bool {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedMovie")
    do {
      let cachedMovies = try moc.fetch(request) as! [CachedMovie]
      return cachedMovies.count == 0
    } catch {
      fatalError("Failed to fetch cached movies: \(error)")
    }
  }
  
  // MARK: - Initialization
  init(dataModelName: String) {
    self.dataModelName = dataModelName
  }
  
  // MARK: - Core data stack
  private lazy var moc: NSManagedObjectContext = {
    let moc = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
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
    
    let storeURL = docURL.appendingPathComponent("MovieCache.sqlite")
    
    do {
      try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
    } catch {
      fatalError("Error migrating store: \(error)")
    }
    
    return psc
  }()
  
  // MARK: - Helpers
  func save(_ movie: Movie) {
    CachedMovie(movie: movie, context: moc)
    
    do {
      try moc.save()
    } catch {
      fatalError("Failure to save context: \(error)")
    }
  }
  
  func fetch() -> [CachedMovie] {
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedMovie")
    do {
      let cachedMovies = try moc.fetch(request) as! [CachedMovie]
      return cachedMovies
    } catch {
      fatalError("Failed to fetch cached movies: \(error)")
    }
  }
  
  func emptyCache() {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedMovie")
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try psc.execute(deleteRequest, with: moc)
    } catch let error as NSError {
      fatalError("Failed to empty movie cache: \(error)")
    }
  }
}
