//
//  SettingsMenu.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/23/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

class SettingsMenu: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {

  // MARK: - Data
  private let settingsMenuOptions = ["Username", "Email", "Change password", "About", "Logout"]
  
  // MARK: - Instance Variables
  private let cellHeight: CGFloat = 50
  public var menuHeight: CGFloat {
    get {
      return CGFloat(settingsMenuOptions.count) * cellHeight
    }
  }
  
  override func didMoveToSuperview() {
    guard let _ = superview else {
      return
    }
    setFlowLayout()
    setLayoutConstraints()
  }
  
  // MARK: - Inits
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Setup
  private func setup() {
    register(MenuSettingCell.self, forCellWithReuseIdentifier: Constants.Reuse.settingValueCell)
    delegate = self
    dataSource = self
  }
  
  private func setFlowLayout() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: superview!.bounds.width, height: cellHeight)
    layout.minimumLineSpacing = 0
    
    setCollectionViewLayout(layout, animated: false)
  }
  
  private func setLayoutConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      bottomAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.bottomAnchor),
      rightAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.rightAnchor),
      leftAnchor.constraint(equalTo: superview!.safeAreaLayoutGuide.leftAnchor),
      heightAnchor.constraint(equalToConstant: menuHeight)
      ])
    
    setNeedsLayout()
    layoutIfNeeded()
    
    transform = CGAffineTransform(translationX: 0, y: menuHeight)
  }
  
  // MARK: Hide/Show Menu
  func show() {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
      self.transform = CGAffineTransform(translationX: 0, y: 0)
    }, completion: nil)
  }
  
  func hide() {
    UIView.animate(withDuration: 0.15) {
      self.transform = CGAffineTransform(translationX: 0, y: self.menuHeight)
    }
  }

  // MARK: - UICollection DataSource & Delegate
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return settingsMenuOptions.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Reuse.settingValueCell, for: indexPath)
    if let cell = cell as? MenuSettingCell {
      cell.configureLabelWith(text: settingsMenuOptions[indexPath.row],
                              textColor: UIColor.white,
                              backgroundColor: UIColor.black)
    }
    return cell
  }

}

