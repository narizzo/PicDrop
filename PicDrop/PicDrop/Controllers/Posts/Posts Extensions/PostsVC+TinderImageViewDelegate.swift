//
//  PostsVC+TinderImageViewDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension PostsViewController: TinderImageViewDelegate {
  func didTap(on tinderImageView: TinderImageView) {
    toggleHUD()
  }
  
  func didSwipeLeft(on tinderImageView: TinderImageView) {
    photoDownloadManager.downloadNextPost()
    
  }
  
  func didSwipeRight(on tinderImageView: TinderImageView) {
    photoDownloadManager.downloadNextPost()
  }
  
  
}
