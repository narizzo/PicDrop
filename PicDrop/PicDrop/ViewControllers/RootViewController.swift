//
//  RootViewController.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 9/18/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import FirebaseAuth

class RootViewController: UIViewController {
  
  var networkManager: NetworkManager
  
  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // this code is in viewDidAppear rather than viewDidLoad because the view that is supposed to present the next vc is not ready in viewDidLoad
    if let _ = Auth.auth().currentUser {
      self.present(PostsViewController(networkManager: networkManager), animated: true)
    } else {
      self.present(SignInViewController(networkManager: networkManager), animated: true)
    }
  }
  
}
