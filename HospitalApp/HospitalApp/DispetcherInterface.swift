//
//  DispetcherInterface.swift
//  HospitalApp
//
//  Created by Alex on 18.05.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import UIKit

class DispetcherInterface{
    var id:Int
    var db: DBHelper
    
    
    init(id: Int, db: DBHelper) {
        self.id = id
        self.db = db
        
    }
    
    func addCall(name: String, gender: String, diagnos: String, address: String, descr: String) -> String{
        if id >= 1{
            if address == ""{
                return "Address is empty"
            }
            db.insert(id: Int(db.getNextCallId()), diagnos: diagnos, time: Date().description, hosp: false, descr: descr, patID: Int(db.getPatId(name: name, gender: gender)), brigID: 0, ready: false)
            return ""
        }
        else{
            return "Invalid id to work as dispetcher"
        }
    }
}
