//
//  TinderImageViewManager+TinderImageViewDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 7/31/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit

extension TinderImageViewManager: TinderImageViewDelegate {
  func tinderImageView(_ tinderImageView: TinderImageView, didVote vote: PostVote) {
    switchImageViewOrder()
    delegate?.tinderImageViewManager(self, didVote: vote)
  }
}
