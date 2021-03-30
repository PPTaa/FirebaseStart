//
//  ViewController.swift
//  FirebaseStart
//
//  Created by leejungchul on 2021/03/30.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var dataLabel: UILabel!
    
    let db = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateLabel()
    }


    func updateLabel() {
        db.child("firstData").observeSingleEvent(of: .value) { snapshot in
            let value = snapshot.value as? String ?? ""
            DispatchQueue.main.async {
                self.dataLabel.text = value
            }
        }
    }
    
    func writeData(){
        db.ch
    }
}

