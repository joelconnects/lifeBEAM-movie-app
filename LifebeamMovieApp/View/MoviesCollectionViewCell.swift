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
    contentView.addSubview(labelContainer)
    labelContainer.addSubview(titleLabel)
    labelContainer.addSubview(detailLabel)
  }
  
  private func configureLayout() {
    labelContainer.translatesAutoresizingMaskIntoConstraints = false
    labelContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
    labelContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
    labelContainer.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7).isActive = true
    labelContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.topAnchor.constraint(equalTo: labelContainer.topAnchor).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor).isActive = true
    titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4).isActive = true
    
    detailLabel.translatesAutoresizingMaskIntoConstraints = false
    detailLabel.leadingAnchor.constraint(equalTo: labelContainer.leadingAnchor).isActive = true
    detailLabel.trailingAnchor.constraint(equalTo: labelContainer.trailingAnchor).isActive = true
    detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5).isActive = true
    detailLabel.bottomAnchor.constraint(equalTo: labelContainer.bottomAnchor).isActive = true
  }
  
  private func configureTitleLabel() {
    titleLabel = UILabel()
    titleLabel.numberOfLines = 0
    titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
    titleLabel.textColor = .white
    titleLabel.textAlignment = .left
    titleLabel.lineBreakMode = .byTruncatingTail
  }
  
  private func configureDetailLabel() {
    detailLabel = UILabel()
    detailLabel.numberOfLines = 0
    detailLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
    detailLabel.textColor = .white
    detailLabel.textAlignment = .left
    detailLabel.lineBreakMode = .byTruncatingTail
  }
  
  // MARK: - Resuse
  override func prepareForReuse() {
    super.prepareForReuse()
    titleLabel.text = nil
    titleText = nil
    detailLabel.text = nil
    detailText = nil
  }
}
