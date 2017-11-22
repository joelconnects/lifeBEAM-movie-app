//
//  MoviesCollectionViewCell.swift
//  LifebeamMovieApp
//
//  Created by Joel Bell on 11/21/17.
//  Copyright © 2017 CraftedByCrazy. All rights reserved.
//

import UIKit

final class MoviesCollectionViewCell: UICollectionViewCell {
  
  // MARK: - Properties
  private var titleLabel: UILabel!
  private var detailLabel: UILabel!
  private var gradientImageView: UIImageView!
  private var mainImageView: UIImageView!
  
  private lazy var imageViewContainer = UIView()
  private lazy var labelContainer = UIView()
  
  var titleText: String? {
    didSet {
      titleLabel.text = titleText?.uppercased()
    }
  }
  
  var detailText: String? {
    didSet {
      detailLabel.text = detailText?.uppercased()
    }
  }
  
  // MARK: Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureContentView()
    configureMainImageView()
    configureGradientImageView()
    configureTitleLabel()
    configureDetailLabel()
    configureViewHierarchy()
    configureLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init?(coder:) is not supported")
  }
  
  // MARK: - View configuration
  private func configureViewHierarchy() {
    contentView.addSubview(imageViewContainer)
    contentView.addSubview(labelContainer)
    imageViewContainer.addSubview(mainImageView)
    imageViewContainer.addSubview(gradientImageView)
    labelContainer.addSubview(titleLabel)
    labelContainer.addSubview(detailLabel)
  }
  
  private func configureLayout() {
    imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
    imageViewContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
    imageViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    imageViewContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    imageViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    
    mainImageView.translatesAutoresizingMaskIntoConstraints = false
    mainImageView.leadingAnchor.constraint(equalTo: imageViewContainer.leadingAnchor).isActive = true
    mainImageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor).isActive = true
    mainImageView.trailingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor).isActive = true
    mainImageView.bottomAnchor.constraint(equalTo: imageViewContainer.bottomAnchor).isActive = true
    
    gradientImageView.translatesAutoresizingMaskIntoConstraints = false
    gradientImageView.leadingAnchor.constraint(equalTo: imageViewContainer.leadingAnchor).isActive = true
    gradientImageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor).isActive = true
    gradientImageView.trailingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor).isActive = true
    gradientImageView.bottomAnchor.constraint(equalTo: imageViewContainer.bottomAnchor).isActive = true
    
    labelContainer.translatesAutoresizingMaskIntoConstraints = false
    labelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
    labelContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
    labelContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
    labelContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    

    
    detailLabel.translatesAutoresizingMaskIntoConstraints = false
    detailLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor).isActive = true
    detailLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor).isActive = true
//    detailLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3).isActive = true
    detailLabel.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor).isActive = true
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.bottomAnchor.constraint(equalTo: detailLabel.topAnchor).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor).isActive = true
    //    titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4).isActive = true
  }
  
  private func configureContentView() {
    contentView.backgroundColor = UIColor.white.withAlphaComponent(0.85)
  }
  
  private func configureMainImageView() {
    mainImageView = UIImageView()
    mainImageView.contentMode = .scaleAspectFill
    mainImageView.clipsToBounds = true
  }
  
  private func configureGradientImageView() {
    gradientImageView = UIImageView(image: Theme.Images.PosterGradient)
    gradientImageView.contentMode = .scaleToFill
    gradientImageView.alpha = 0
  }
  
  private func configureTitleLabel() {
    titleLabel = UILabel()
    titleLabel.numberOfLines = 2
    titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
    titleLabel.textColor = .black
    titleLabel.textAlignment = .left
    titleLabel.lineBreakMode = .byTruncatingTail
  }
  
  private func configureDetailLabel() {
    detailLabel = UILabel()
    detailLabel.numberOfLines = 2
    detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
    detailLabel.textColor = .black
    detailLabel.textAlignment = .left
    detailLabel.lineBreakMode = .byTruncatingTail
  }
  
  // MARK: - Resuse
  override func prepareForReuse() {
    super.prepareForReuse()
    gradientImageView.alpha = 0
    mainImageView.image = nil
    
    titleLabel.text = nil
    detailLabel.text = nil
    
    titleText = nil
    detailText = nil
  }
  
  // MARK: - Helpers
  func setImage(_ image: UIImage, animated: Bool, isPlaceholder: Bool) {
    if animated {
      animatePosterContainerViews(with: image)
    } else {
      if !isPlaceholder {
        gradientImageView.alpha = 1
      }
      mainImageView.image = image
    }
  }
  
  // MARK: - Animation
  private func animatePosterContainerViews(with image: UIImage) {
    let duration = 0.3
    UIView.transition(with: mainImageView, duration: duration, options: .transitionCrossDissolve, animations: {
      self.mainImageView.image = image
    }, completion: nil)
    
    UIView.animate(withDuration: duration) {
      self.gradientImageView.alpha = 1
    }
  }
}
