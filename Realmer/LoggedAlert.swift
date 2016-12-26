//
//  LoggedAlert.swift
//  Realmer
//
//  Created by jonathan thornburg on 12/23/16.
//  Copyright © 2016 jonathan thornburg. All rights reserved.
//

import Foundation
import RealmSwift

class LoggedAlert: Object {
    dynamic var title: String?
    dynamic var question: String?
    let responses = List<Response>()
}
