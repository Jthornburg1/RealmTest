//
//  SettingsVC.swift
//  Realmer
//
//  Created by Jon Thornburg on 12/27/16.
//  Copyright © 2016 jonathan thornburg. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class SettingsVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var appSettings: AppSettings?
    var textFields: [UITextField]?
    var realm: Realm?
    var redoTapped = false
    
    @IBOutlet weak var alertModeText: UITextField!
    @IBOutlet weak var fixedIntervalTimeText: UITextField!
    @IBOutlet weak var randomIntervalMax: UITextField!
    @IBOutlet weak var randomIntervalMin: UITextField!
    @IBOutlet weak var responseTimeText: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        
        userNameText.delegate = self
        
        alertModeText.tag = 0
        fixedIntervalTimeText.tag = 1
        randomIntervalMax.tag = 2
        randomIntervalMin.tag = 3
        responseTimeText.tag = 4
        userNameText.tag = 5
        
        textFields = [alertModeText, fixedIntervalTimeText, randomIntervalMin, randomIntervalMax, responseTimeText, userNameText]
        
        appSettings = realm!.objects(AppSettings.self).first
        
        setTextView()
    }
    
    func setTextView() {
        if let settings = appSettings {
            textView.text = "\n\tAlertMode = \(settings.alertMode!)\n\tFixedIntervalTime = \(settings.fixedIntervalTime)\n\tRandomIntervalMax = \(settings.randomIntervalMax)\n\tRandomeIntervalMin = \(settings.randomIntervalMin)\n\tResponseTime = \(settings.responseTime)\n\tUserName = \(settings.username!)"
        }
    }
    
    @IBAction func redoTapped(_ sender: Any) {
        if redoTapped == false {
            do {
                try realm!.write {
                    realm!.delete(self.appSettings!)
                    textView.text = ""
                    for textf in textFields! {
                        textf.isUserInteractionEnabled = true
                        textf.text = ""
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            redoTapped = true
        }
    }
    @IBAction func submitTapped(_ sender: Any) {
        appSettings = AppSettings()
        if let mode = alertModeText.text {
            appSettings!.alertMode = mode
        }
        if let fxnttm = fixedIntervalTimeText.text {
            if let fxinttime = Int(fxnttm) {
                appSettings!.fixedIntervalTime = fxinttime
            }
        }
        if let rdnttm = randomIntervalMax.text {
            if let rdnttime = Int(rdnttm) {
                appSettings!.randomIntervalMax = rdnttime
            }
        }
        if let rdmn = randomIntervalMin.text {
            if let rdmin = Int(rdmn) {
                appSettings!.randomIntervalMin = rdmin
            }
        }
        if let rspstm = responseTimeText.text {
            if let rspstime = Int(rspstm) {
                appSettings!.responseTime = rspstime
            }
        }
        if let usrnm = userNameText.text {
            appSettings!.username = usrnm
        }
        
        for textf in textFields! {
            if textf.text == nil || textf.text == "" {
                showEmptyTextAlert()
                break
            }
        }
        
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(appSettings!)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        for textf in textFields! {
            textf.isUserInteractionEnabled = false
        }
        setTextView()
        redoTapped = false
    }
    
    func showEmptyTextAlert() {
        let alert = UIAlertController(title: "Empty Texts", message: "Complete all texts", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 5 {
            textField.resignFirstResponder()
        }
        return true
    }
}
