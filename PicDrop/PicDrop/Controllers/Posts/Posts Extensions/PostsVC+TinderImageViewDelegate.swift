//
//  PostsVC+TinderImageViewDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension PostsViewController: TinderImageViewDelegate {
  func TinderImageViewTapped() {
    toggleHUD()
  }
  
  func TinderImageViewSwipedLeft() {
    photoDownloadManager.downloadNextPost()
    
  }
  
  func TinderImageViewSwipedRight() {
    photoDownloadManager.downloadNextPost()
  }
  
  
}
