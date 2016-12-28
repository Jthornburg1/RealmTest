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
    var responseObjects: [Response]?
    var selectedIndex: Int?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        setResponses()
        
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
    }
    
    func setResponses() {
        responseObjects?.removeAll()
        responses.removeAll()
        tableView.reloadData()
        if let resps = alert?.responses {
            responseObjects = [Response]()
            for resp in resps {
                responses.append(resp.answer!)
                responseObjects?.append(resp)
                print("This alert has \(responseObjects!.count) responses.")
            }
            tableView.reloadData()
        }

    }
    
    @IBAction func saveTapped(_ sender: Any) {
        let response = Response()
        if let txt = textField.text {
            response.answer = txt
            response.uid = self.uid
            response.date = Date()
        }
        do {
            try realm.write {
                realm.add(response)
                let responses = realm.objects(Response.self).filter("uid contains '\(self.uid)'")
                alert?.responses.append(responses.first!)
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
        self.responses.append(response.answer!)
        tableView.reloadData()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func presentEditOrRemoveAlert(index: Int) {
        let alert = UIAlertController(title: "", message: "You may edit or remove this response", preferredStyle: .alert)
        let editAction = UIAlertAction(title: "Edit", style: .default) { (action) in
            do {
                try self.realm.write {
                    if let respObs = self.responseObjects {
                        respObs[self.selectedIndex!].answer = alert.textFields?.first?.text!
                        self.tableView.reloadData()
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            try! self.realm.write {
                self.realm.delete(self.responseObjects![self.selectedIndex!])
                self.setResponses()
            }
        }
        alert.addTextField { (textField) in
            textField.tag = 1
        }
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func goToSettings(_ sender: Any) {
        performSegue(withIdentifier: "showSettings", sender: self)
    }
    // TextField methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presentEditOrRemoveAlert(index: indexPath.row)
        selectedIndex = indexPath.row
    }
}
