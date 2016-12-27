//
//  AppDelegate.swift
//  Realmer
//
//  Created by jonathan thornburg on 12/23/16.
//  Copyright © 2016 jonathan thornburg. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in
            if (oldSchemaVersion < 1) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
        })
        
        Realm.Configuration.defaultConfiguration = config
        
        return true
    }

}

