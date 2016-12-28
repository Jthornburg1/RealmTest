//
//  AppSettings.swift
//  Realmer
//
//  Created by Jon Thornburg on 12/27/16.
//  Copyright © 2016 jonathan thornburg. All rights reserved.
//

import Foundation
import RealmSwift

class AppSettings:Object {
    dynamic var alertMode: String?
    dynamic var fixedIntervalTime = 0
    dynamic var randomIntervalMax = 0
    dynamic var randomIntervalMin = 0
    dynamic var responseTime = 0
    dynamic var username: String?
}
