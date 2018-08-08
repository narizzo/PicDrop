//
//  AppDelegate.swift
//  PicDrop
//
//  Created by Nicholas Rizzo on 6/24/18.
//  Copyright © 2018 Nicholas Rizzo. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  lazy var coreDataStack = CoreDataStack(modelName: Constants.CoreData.modelName)
  lazy var cache = Cache(coreDataStack)

  // MARK: - Application Methods
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    
    print(coreDataStack.managedContext.debugDescription) // this line may have fixed invalid entity description for Post that resulted from deleting an entity in the data model that Post had a relationship to.
    
    // Configure initial view controller
    window = UIWindow(frame: UIScreen.main.bounds)
    
    guard let window = window else {
      fatalError("There is no window")
    }
    
    // setup rootViewController
    if let _ = Auth.auth().currentUser {
      window.rootViewController = PostsViewController()
    } else {
      window.rootViewController = SignInViewController()
    }
    
    // inject dependencies
    let networkController = NetworkManager(cache: cache)
    let locationManager = LocationManager()
    
    
    if let signInVC = window.rootViewController as? SignInViewController {
      signInVC.networkManager = networkController
      signInVC.locationManager = locationManager
    } else if let postsVC = window.rootViewController as? PostsViewController {
      postsVC.networkManager = networkController
      postsVC.locationManager = locationManager
    }
    
    window.makeKeyAndVisible()
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
  }
}

