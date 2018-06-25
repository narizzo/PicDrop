//
//  ViewController.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 6/24/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var actionBar: UIView!
  
  @IBOutlet weak var profile: UIButton!
  @IBOutlet weak var upvote: UIButton!
  @IBOutlet weak var downvote: UIButton!
  @IBOutlet weak var camera: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadNextPicture()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func tappedProfile(_ sender: UIButton) {
    print("profile")
  }
  
  @IBAction func tappedUpvote(_ sender: UIButton) {
    print("upvote")
  }
  
  @IBAction func tappedDownvote(_ sender: UIButton) {
    print("downvote")
  }
  
  @IBAction func tappedCamera(_ sender: UIButton) {
    performSegue(withIdentifier: "takePictureSegue", sender: nil)
  }
  
  private func loadNextPicture() {
    
  }
  
}
