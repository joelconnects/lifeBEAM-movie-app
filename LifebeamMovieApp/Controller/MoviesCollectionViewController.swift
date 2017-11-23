//
//  MoviesCollectionViewController.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/20/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit



final class MoviesCollectionViewController: UICollectionViewController {
  
  private let LOG_TAG = "MoviesCollectionViewController"
  
  // MARK: - Properties
  private let cellReuseID = "movieCell"
  private let flowLayout = UICollectionViewFlowLayout()
  private let movieManager: MovieManager
  private let approachingEndThreshold = 20
  private var lastOffset: CGPoint?
  private var lastOffsetCapture: TimeInterval?
  private var isScrollingFast: Bool = false
  private var scrollingIrrelevant: Bool = true
  
  // MARK: - Initialization
  
  init(movieManager: MovieManager) {
    self.movieManager = movieManager
    super.init(collectionViewLayout: flowLayout)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init?(coder:) is not supported")
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self, name: .moviesReadyToDisplay, object: nil)
  }
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureCollectionView()
    configureCollectionViewLayout()
    
    NotificationCenter.default.addObserver(self, selector: #selector(movieManagerNotification(_:)), name: .moviesReadyToDisplay, object: nil)
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
  
  // MARK: - Notification
  @objc private func movieManagerNotification(_ notification: Notification) {
    if notification.name == .moviesReadyToDisplay {
      self.collectionView?.reloadData()
    }
  }
}

// MARK: UICollectionViewDataSource
extension MoviesCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movieManager.movies.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseID, for: indexPath) as! MoviesCollectionViewCell
    
    let movie = movieManager.movies[indexPath.row]
    
    cell.titleText = movie.title
    cell.detailText = movieManager.genresForDisplay(movie.genreIds)
    
    if let poster = movieManager.images[movie.id] {
      cell.setImage(poster, animated: false, isPlaceholder: false)
    } else {
      cell.setImage(Theme.Images.PosterPlaceholder, animated: false, isPlaceholder: true)
    }
    
    return cell
  }
}

// MARK: UICollectionViewDelegate
extension MoviesCollectionViewController {
  override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
  
    let movieCell = cell as! MoviesCollectionViewCell
    let movie = movieManager.movies[indexPath.row]

    if movieManager.images[movie.id] == nil {
      movieManager.imageForDisplay(movie: movie) { (image, error) in
        if let image = image  {
          DispatchQueue.main.async {
            if collectionView.visibleCells.contains(movieCell) && !self.isScrollingFast {
              movieCell.setImage(image, animated: true, isPlaceholder: false)
            }
          }
        } else {
          Log.e(tag: self.LOG_TAG, message: "\(error?.localizedDescription ?? "error retreiving image for display")")
        }
      }
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) else {
      return
    }
    
    let frame = collectionView.convert(cell.frame, to: collectionView.superview)
    let detailViewController = MovieDetailViewController(movie: movieManager.movies[indexPath.row], movieManager: movieManager, startingFrame: frame)
    detailViewController.modalPresentationStyle = .overCurrentContext
    present(detailViewController, animated: false, completion: nil)
  }
}

// MARK: - UIScrollViewDelegate
extension MoviesCollectionViewController {
  
  override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    for cell in collectionView!.visibleCells {
      let movieCell = cell as! MoviesCollectionViewCell
      let row = collectionView!.indexPath(for: movieCell)!.row
      let movie = movieManager.movies[row]
      
      if let image = movieManager.images[movie.id] {
        if movieCell.imageIsPlaceholder {
          movieCell.setImage(image, animated: true, isPlaceholder: false)
        }
      }
    }
  }
  
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // MARK: - Request movies
    if let indexPath = collectionView?.indexPathsForVisibleItems.sorted().last {
      let thresholdReached = (movieManager.movies.count - indexPath.row) < approachingEndThreshold
      let isScrollingDown = scrollView.panGestureRecognizer.velocity(in: scrollView).y < 0
      
      if thresholdReached && isScrollingDown {
        movieManager.requestMovies()
      }
    }

    // MARK: - Check scrolling speed
    if lastOffsetCapture == nil {
      lastOffsetCapture = Date().timeIntervalSinceReferenceDate
    }
    
    if lastOffset == nil {
      lastOffset = scrollView.contentOffset
    }
    
    let currentOffset: CGPoint = scrollView.contentOffset
    let currentTime = Date().timeIntervalSinceReferenceDate
    let timeDiff = currentTime - lastOffsetCapture!
    
    if timeDiff > 0.1 {
      let distance: CGFloat = currentOffset.y - lastOffset!.y
      let scrollSpeedNotAbs: CGFloat = (distance * 10) / 1000
      
      let scrollSpeed: CGFloat = abs(scrollSpeedNotAbs)
      if (scrollSpeed > 0.6) {
        isScrollingFast = true;
      } else {
        isScrollingFast = false;
      }
      
      lastOffset = currentOffset
      lastOffsetCapture = currentTime
    }
  }
}
