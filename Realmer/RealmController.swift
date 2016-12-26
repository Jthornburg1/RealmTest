//
//  RealmController.swift
//  Realmer
//
//  Created by jonathan thornburg on 12/25/16.
//  Copyright © 2016 jonathan thornburg. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmController {
    
    public static let shared = RealmController()
    
    private init(){}
    
    func getLoggedAlerts() -> Results<LoggedAlert> {
        let realm = try! Realm()
        let results = realm.objects(LoggedAlert)
        return results
    }
}
