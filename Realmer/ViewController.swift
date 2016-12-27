//
//  ViewController.swift
//  Realmer
//
//  Created by jonathan thornburg on 12/23/16.
//  Copyright © 2016 jonathan thornburg. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var alertNames = [String]()
    var alerts: Results<LoggedAlert>!
    let realm = try! Realm()
    var selectedIndex: Int?
    var answers: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addAlertTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Alert?", message: "Add the name of your alert", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(saveAction) -> Void in
            let textField1 = alert.textFields?.first
            let textField2 = alert.textFields?[1]
            self.createLoggedAlert(title: textField1?.text!, question: textField2?.text!)
            
            self.alerts = self.realm.objects(LoggedAlert.self)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textfield) in
        }
        alert.addTextField { (textfield) in
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

    }
    
    // TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let al = alerts {
            return al.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        cell?.textLabel?.text = self.alerts[indexPath.row].title!
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowResponses", sender: self)
    }
    
    // Segue callback function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ResponsesVC
        if let selIndex = selectedIndex {
            vc.alert = alerts[selIndex]
        }
    }
    
    func createLoggedAlert(title: String?, question: String?) {
        let realm = try! Realm()
        let loggedAlert = LoggedAlert()
        if let title = title {
            loggedAlert.title = title
        }
        if let qstn = question {
            loggedAlert.question = qstn
        }
        do {
            
            try realm.write {
                realm.add(loggedAlert)
            }
            
        } catch let error as NSError {
            print("Realm is unable to save the LoggedAlert: \(error), \(error.userInfo)")
        }
    }
}

