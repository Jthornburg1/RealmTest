//
//  Response.swift
//  Realmer
//
//  Created by jonathan thornburg on 12/23/16.
//  Copyright © 2016 jonathan thornburg. All rights reserved.
//

import Foundation
import RealmSwift

class Response: Object {
    
    dynamic var answer: String?
    dynamic var date: Date?
    dynamic var uid: String?
    var alert: LoggedAlert?
}
