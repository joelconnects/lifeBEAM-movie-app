//
//  MovieDetailViewController.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/22/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
  
  private let LOG_TAG = "MovieDetailViewController"
  
  // MARK: - Properties
  private let movieManager: MovieManager
  private let movie: Movie
  private let startingFrame: CGRect
  
  private let contentView = UIView()
  private let headerView = UIView()
  
  private var blurEffectView: UIVisualEffectView!
  private var closeButton: UIButton!
  private var headerImageView: UIImageView!
  private var gradientImageView: UIImageView!
  private var titleLabel: UILabel!
  private var detailLabel: UILabel!
  private var detailScrollView: UIScrollView!
  
  private var scrollViewTopConstraint: NSLayoutConstraint!
  private var scrollViewBtmConstraint: NSLayoutConstraint!
  
  // MARK: - Initialization
  init(movie: Movie, movieManager: MovieManager, startingFrame: CGRect) {
    self.movieManager = movieManager
    self.movie = movie
    self.startingFrame = startingFrame
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init?(coder:) is not supported")
  }
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    configureBlurEffectView()
    configureContentView()
    configureHeaderView()
    configureDetailScrollView()
    configureCloseButton()
    configureHeaderImageView()
    configureGradientImageView()
    configureTitleLabel()
    configureDetailLabel()
    configureViewHierarchy()
    configureLayout()
    loadHeaderImage()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    startOpeningAnimation()
  }
  
  // MARK: - View configuration
  private func configureView() {
    view.backgroundColor = .clear
  }
  
  private func configureViewHierarchy() {
    view.addSubview(blurEffectView)
    view.addSubview(contentView)
    
    contentView.addSubview(headerView)
    contentView.addSubview(detailScrollView)
    contentView.addSubview(closeButton)
    
    headerView.addSubview(headerImageView)
    headerView.addSubview(gradientImageView)
    headerView.addSubview(titleLabel)
    detailScrollView.addSubview(detailLabel)
  }
  
  private func configureLayout() {
    blurEffectView.translatesAutoresizingMaskIntoConstraints = false
    blurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    closeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
    closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = true
    closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    closeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    headerView.translatesAutoresizingMaskIntoConstraints = false
    headerView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    headerView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true

    detailScrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollViewTopConstraint = detailScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
    detailScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
    detailScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    scrollViewBtmConstraint = detailScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    scrollViewTopConstraint.isActive = true
    scrollViewBtmConstraint.isActive = true

    headerImageView.translatesAutoresizingMaskIntoConstraints = false
    headerImageView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
    headerImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
    headerImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
    headerImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
    
    gradientImageView.translatesAutoresizingMaskIntoConstraints = false
    gradientImageView.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
    gradientImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor).isActive = true
    gradientImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
    gradientImageView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -15).isActive = true

    detailLabel.translatesAutoresizingMaskIntoConstraints = false
    detailLabel.topAnchor.constraint(equalTo: detailScrollView.topAnchor).isActive = true
    detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
    detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    detailLabel.bottomAnchor.constraint(equalTo: detailScrollView.bottomAnchor).isActive = true
  }

  private func configureBlurEffectView() {
    blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    blurEffectView.alpha = 0
  }
  
  private func configureContentView() {
    contentView.frame = startingFrame
    contentView.alpha = 0
    contentView.layer.cornerRadius = 20
    contentView.clipsToBounds = true
    contentView.backgroundColor = .black
  }

  private func configureHeaderView() {
    headerView.backgroundColor = .white
  }
  
  private func configureDetailScrollView() {
    detailScrollView = UIScrollView()
    detailScrollView.showsVerticalScrollIndicator = true
    detailScrollView.indicatorStyle = .white
  }
  
  private func configureCloseButton() {
    closeButton = UIButton()
    closeButton.setImage(Theme.Icons.CloseButton, for: .normal)
    closeButton.setImage(Theme.Icons.CloseButton.withRenderingMode(.alwaysTemplate), for: .highlighted)
    closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
    closeButton.tintColor = .gray
    closeButton.layer.shadowColor = UIColor.white.cgColor
    closeButton.layer.shadowOpacity = 1
    closeButton.layer.shadowOffset = CGSize.zero
    closeButton.layer.shadowRadius = 8
  }

  private func configureGradientImageView() {
    gradientImageView = UIImageView(image: Theme.Images.PosterGradient)
    gradientImageView.alpha = 0.7
  }
  
  private func configureHeaderImageView() {
    headerImageView = UIImageView()
    headerImageView.image = Theme.Images.DetailPosterPlaceholder
  }
  
  private func configureTitleLabel() {
    titleLabel = UILabel()
    titleLabel.numberOfLines = 2
    titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .heavy)
    titleLabel.textColor = .black
    titleLabel.textAlignment = .left
    titleLabel.lineBreakMode = .byTruncatingTail
    titleLabel.text = movie.title.uppercased()
  }
  
  private func configureDetailLabel() {
    detailLabel = UILabel()
    detailLabel.numberOfLines = 0
    detailLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
    detailLabel.textColor = .white
    detailLabel.textAlignment = .left
    detailLabel.lineBreakMode = .byWordWrapping
    detailLabel.text = movie.overview
  }
  
  // MARK: - Helpers
  private func loadHeaderImage() {
    movieManager.imageForDisplay(movie: movie) { (image, error) in
      if let image = image  {
        DispatchQueue.main.async {
          self.transitionHeaderImageView(with: image)
        }
      } else {
        Log.e(tag: self.LOG_TAG, message: "\(error?.localizedDescription ?? "error retreiving image for display")")
      }
    }
  }
  
  // MARK: - Animation
  private func startOpeningAnimation() {
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
    contentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
    contentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
    contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    
    scrollViewTopConstraint.constant = 20
    scrollViewBtmConstraint.constant = -20
    
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
      self.blurEffectView.alpha = 1
      self.contentView.alpha = 1
    }
  }
  
  private func transitionHeaderImageView(with image: UIImage) {
    UIView.transition(with: headerImageView, duration: 0.3, options: .transitionCrossDissolve, animations: {
      self.headerImageView.image = image
    }, completion: nil)
  }
  
  // MARK: - Actions
  @objc
  private func closeButtonTapped(_ button: UIButton) {
    UIView.animate(withDuration: 0.2) {
      self.blurEffectView.alpha = 0
    }
    dismiss(animated: true, completion: nil)
  }
}
