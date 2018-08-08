//
//  PostsVC+TinderImageViewDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension PostsViewController: TinderImageViewManagerDelegate {
  func tinderImageViewManager(_ tinderImageViewManager: TinderImageViewManager, didVote vote: PostVote) {
    /*  1. pop post from postQueue if it exists
        2. update post's votes in database
        3. remove corresponding photo from photo queue
     */
  }
  
}
