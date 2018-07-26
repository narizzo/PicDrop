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
  var text: String? {
    didSet {
      label.text = text
    }
  }
  var textColor: UIColor? {
    didSet {
      label.textColor = textColor
    }
  }
  var labelBackgroundColor: UIColor? {
    didSet {
      label.backgroundColor = labelBackgroundColor
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    label.adjustsFontSizeToFitWidth = true
    //self.addSubview(label)
    self.contentView.addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: contentView.topAnchor),
      label.rightAnchor.constraint(equalTo: contentView.rightAnchor),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      label.leftAnchor.constraint(equalTo: contentView.leftAnchor),
      ])
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureLabelWith(text: String, textColor: UIColor, backgroundColor: UIColor) {
    self.text = text
    self.textColor = textColor
    self.labelBackgroundColor = backgroundColor
  }
  
}

// MARK: - UIInsetLabel
class UIInsetLabel: UILabel {
  
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8)
    super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
  }
  
}
