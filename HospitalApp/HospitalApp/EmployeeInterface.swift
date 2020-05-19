//
//  EmployeeInterface.swift
//  HospitalApp
//
//  Created by Alex on 19.05.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

class EmployeeInterface{
    var emplID: Int = 0
    var currentCallID: Int = 0
    
    var db: DBHelper
    
    init(db: DBHelper, id:Int){
        self.db = db
        self.emplID = id
    }
    
    func finishCall(diagnos: String, hosp: Bool){
        db.finishCall(callId: currentCallID, diagnos: diagnos, hosp: hosp)
    }
    func getFreeCall() -> Call{
        let call = db.getFreeCall(brigID: Int(db.getBrigadeId(id: emplID)))
        currentCallID = call.id
        return call
    }
    func getID()-> Int{
        return emplID
    }
}
