//
//  AdminInterface.swift
//  HospitalApp
//
//  Created by Alex on 18.05.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

class AdminInterface{
    var persons: [Employee] = []
    var haveDriver: Bool = false
    var haveDoctor: Bool = false
    var haveNurse: Bool = false
    
    var db: DBHelper = DBHelper()
    
    init(db: DBHelper) {
        self.db = db
    }
    
    func GetNumberOfRows() -> Int{
        return persons.count
    }
    
    func GetEmplInformation(num: Int) -> String{
        var text = "Id: " + String(persons[num].id) + ", " + "Name: "
        text += String(persons[num].name) + ", Position: " + String(persons[num].position)
        
        return text
    }
    
    func CreateBrigade(time: String) -> String{
        if persons.count != 3{
            return "Brigade consist of 3 employees"
        }
        haveDriver = false
        haveNurse = false
        haveDoctor = false
        
        db.insertBrigade(id: Int(db.getNextBrigadeId()), time: time, empl: persons)
        
        persons = []
        
        return ""
    }
    
    func addEmployee(id:Int, name: String) -> String{
        let newEmpl = db.readFromEmployeeByInfo(name: name, id: String(id))[0]
        
        if newEmpl.position == "Doctor" {
            if haveDoctor{
                return "Doctor is already in brigade"
            }
            haveDoctor = true
        }
        else if newEmpl.position == "Nurse" {
            if haveNurse{
                return "Nurse is already in brigade"
            }
            haveNurse = true
        }
        else if newEmpl.position == "Driver" {
            if haveDriver{
                return "Driver is already in brigade"
            }
            haveDriver = true
        }
        persons.append(newEmpl)
        return ""
    }
}
