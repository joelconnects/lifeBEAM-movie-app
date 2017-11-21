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
    configureNavigationBar()
    configureCollectionView()
    configureCollectionViewLayout()
  }
  
  // MARK: - View configuration
  private func configureNavigationBar() {
    self.navigationController?.navigationBar.topItem?.title = "Popular Movies".uppercased()
    self.navigationController?.navigationBar.barTintColor = .black
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 26, weight: .bold)]
  }
  
  private func configureCollectionView() {
    collectionView?.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseID)
    collectionView?.backgroundColor = .clear
  }
  
  private func configureCollectionViewLayout() {
    flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    flowLayout.minimumLineSpacing = 10
    flowLayout.minimumInteritemSpacing = 10
    
    let itemWidth = (UIScreen.main.bounds.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.left) - flowLayout.minimumLineSpacing) / 2
    let itemHeight = itemWidth
    
    flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
  }
}

// MARK: UICollectionViewDataSource
extension MoviesCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movieManager.movies.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! MoviesCollectionViewCell
    cell.prepareForReuse()
    return cell
  }
}

// MARK: UICollectionViewDelegate
extension MoviesCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let movieCell = cell as! MoviesCollectionViewCell
    movieCell.backgroundColor = .magenta
    let movie = movieManager.movies[indexPath.row]
    movieCell.titleText = movie.title
    movieCell.detailText = movieManager.generateGenresForDisplay(movie.genreIds)
  }
}
