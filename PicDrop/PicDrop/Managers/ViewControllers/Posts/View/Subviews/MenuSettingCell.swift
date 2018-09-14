//
//  MenuSettingCell.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/23/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class MenuSettingCell: UICollectionViewCell {
  
  private let label = UIInsetLabel()
  private var text: String? {
    didSet {
      label.text = text
    }
  }
  private var textColor: UIColor? {
    didSet {
      label.textColor = textColor
    }
  }
  private var labelBackgroundColor: UIColor? {
    didSet {
      label.backgroundColor = labelBackgroundColor
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    label.adjustsFontSizeToFitWidth = true
    //self.addSubview(label) // Do not directly add subviews to the cell itself.
    self.contentView.addSubview(label)
    setupGestureRecognizers()
    setupLayoutConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupLayoutConstraints() {
    label.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: contentView.topAnchor),
      label.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      label.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      ])
  }
  
  func configureLabelWith(text: String, textColor: UIColor, backgroundColor: UIColor) {
    self.text = text
    self.textColor = textColor
    self.labelBackgroundColor = backgroundColor
  }
  
  private func setupGestureRecognizers() {
    let tapGestureRecognizer = UITapGestureRecognizer()
    tapGestureRecognizer.addTarget(self, action: #selector(handleTap))
    contentView.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc private func handleTap() {
    print("Cell tapped")
  }
  
}

// MARK: - UIInsetLabel
class UIInsetLabel: UILabel {
  
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
    super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
  }
  
}
