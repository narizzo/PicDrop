//
//  PostsVC+SettingsMenu.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension PostsViewController: UICollectionViewDelegate {
  // TODO
}

extension PostsViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return settingsMenuOptions.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Reuse.settingValueCell, for: indexPath)
    if let cell = cell as? SettingValueCell {
      cell.setText(to: settingsMenuOptions[indexPath.row]) // will repeat options for sections -> Collapse menu into 1 section?
    }
    cell.backgroundColor = UIColor.red
    return cell
  }
  
}

class SettingValueCell: UICollectionViewCell {
  
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

class UIInsetLabel: UILabel {
  
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
    super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
  }
  
}
