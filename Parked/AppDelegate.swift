//
//  AppDelegate.swift
//  Parked
//
//  Created by Mihaela Miches on 1/5/17.
//  Copyright © 2017 me. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Location.shared.start()
    
        return true
    }

}

