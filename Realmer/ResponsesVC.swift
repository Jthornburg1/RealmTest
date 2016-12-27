//
//  Responses.swift
//  Realmer
//
//  Created by jonathan thornburg on 12/23/16.
//  Copyright © 2016 jonathan thornburg. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ResponsesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var responses = [String]()
    let realm = try! Realm()
    var alert: LoggedAlert?
    var uid = ""
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let resps = alert?.responses {
            for resp in resps {
                responses.append(resp.answer!)
            }
            tableView.reloadData()
        }
        
        uid = NSUUID().uuidString
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        if let alrt = self.alert {
            if let qstn = alrt.question {
                questionLabel.text = qstn
            } else {
                questionLabel.text = "No Question"
            }
        } else {
            questionLabel.text = "No Question"
        }
        textField.isHidden = true
    }
    @IBAction func addResponseTapped(_ sender: Any) {
        textField.isHidden = false
        let response = Response()
        if let txt = textField.text {
            response.answer = txt
            response.uid = self.uid
            response.date = Date()
        }
        do {
            try realm.write {
                realm.add(response)
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
        let responses = realm.objects(Response.self).filter("uid contains '\(self.uid)'")
        alert?.responses.append(responses.first!)
        self.responses.append(response.answer!)
        tableView.reloadData()
    }
    
    // TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = responses[indexPath.row]
        
        return cell!
    }
}
