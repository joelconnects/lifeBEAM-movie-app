//
//  GenreEntity+CoreDataClass.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/21/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//
//

import Foundation
import CoreData

@objc(GenreEntity)
public class GenreEntity: NSManagedObject {
  
  @discardableResult
  convenience init?(genre: Genre, context: NSManagedObjectContext) {
    guard let entity = NSEntityDescription.entity(forEntityName: "GenreEntity", in: context) else {
      return nil
    }
    self.init(entity: entity, insertInto: context)
    self.id = Int64(genre.id)
    self.name = genre.name
  }
  
  class func convert(_ savedGenres: [GenreEntity]) -> [Int: String] {
    var genres = [Int: String]()
    for savedGenre in savedGenres {
      let genre = Genre(id: Int(savedGenre.id), name: savedGenre.name)
      genres[genre.id] = genre.name
    }
    return genres
  }
}
