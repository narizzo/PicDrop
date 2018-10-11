//
//  PostsVC+PostsViewDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

extension PostsViewController: PostsViewDelegate {
  
  func postsViewTakePhoto(_ postsView: PostsView) {
    operationQueue.addOperation(
      PresentTakePictureVcOperation(viewController: self,
                                    networkManager: networkManager,
                                    locationManager: locationManager))
  }
}
