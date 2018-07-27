//
//  PostsVC+PhotoDownloadDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/19/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

// MARK: - PhotoDownloadDelegate
extension PostsViewController: PhotoDownloadDelegate {
  
  func photoHasFinishedDownloading(_ photo: UIImage) {
    DispatchQueue.main.async {
      self.tinderImageView.setImage(to: photo)
    }
  }
  
  func noPhotosToShow() {
    print("No Photos")
  }
  
}
