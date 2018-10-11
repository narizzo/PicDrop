//
//  PostsVC+TinderImageViewManagerDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/20/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import Foundation

extension PostsViewController: TinderImageViewManagerDelegate {
  
  func tinderImageViewManager(_ tinderImageViewManager: TinderImageViewManager, didVote vote: PostVote, for post: PartialPost) {
    networkManager.vote(on: post, with: vote)
    self.feedNextPostToTinderImageViewManager()
  }
}
