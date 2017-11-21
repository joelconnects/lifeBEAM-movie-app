//
//  MoviesCollectionViewController.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/20/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

final class MoviesCollectionViewController: UICollectionViewController {
  
  // MARK: - Properties
  private let cellReuseID = "movieCell"
  private let flowLayout = UICollectionViewFlowLayout()
  private let movieManager: MovieManager
  
  // MARK: - Initialization
  
  init(movieManager: MovieManager) {
    self.movieManager = movieManager
    super.init(collectionViewLayout: flowLayout)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init?(coder:) is not supported")
  }
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCollectionView()
    configureCollectionViewLayout()
  }
  
  // MARK: - View configuration
  private func configureCollectionView() {
    collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseID)
    collectionView?.backgroundColor = .clear
  }
  
  private func configureCollectionViewLayout() {
    flowLayout.minimumLineSpacing = 10
    flowLayout.minimumInteritemSpacing = 5
    flowLayout.itemSize = CGSize(width: 100, height: 100)
  }
}

// MARK: UICollectionViewDataSource
extension MoviesCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movieManager.movies.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath)
    return cell
  }
}

// MARK: UICollectionViewDelegate
extension MoviesCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    cell.backgroundColor = .magenta
  }
}
