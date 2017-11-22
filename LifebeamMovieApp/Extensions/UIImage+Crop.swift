//
//  UIImage+Crop.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/22/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

extension UIImage {
  func cropPoster() -> UIImage {
    let imageRef = self.cgImage
    let squareFrame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.width)
    let squareImage = imageRef?.cropping(to: squareFrame)
    let newImage = UIImage(cgImage: squareImage!)
    return newImage
  }
}

