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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    label.adjustsFontSizeToFitWidth = true
    
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
  
  func setText(to text: String) {
    label.text = text
  }
  
}

// MARK: - UIInsetLabel
class UIInsetLabel: UILabel {
  
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
    super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
  }
  
}
