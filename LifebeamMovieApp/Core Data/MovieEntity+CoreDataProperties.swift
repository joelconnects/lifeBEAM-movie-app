//
//  MovieEntity+CoreDataProperties.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/21/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//
//

import Foundation
import CoreData


extension MovieEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var adult: NSNumber?
    @NSManaged public var backdropPath: String?
    @NSManaged public var genreIds: [Int]
    @NSManaged public var id: NSNumber
    @NSManaged public var originalLanguage: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var overview: String?
    @NSManaged public var popularity: NSNumber?
    @NSManaged public var posterPath: String
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String
    @NSManaged public var video: NSNumber?
    @NSManaged public var voteAverage: NSNumber?
    @NSManaged public var voteCount: NSNumber?
}
