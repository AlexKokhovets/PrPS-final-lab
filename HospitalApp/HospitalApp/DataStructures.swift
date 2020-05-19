//
//  DataStructures.swift
//  HospitalApp
//
//  Created by Alex on 17.05.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation

class Administrator
{
    
    var name: String = ""
    var id: Int = 0
    
    init(id:Int, name:String)
    {
        self.id = id
        self.name = name
    }
    
}

class Employee
{
    
    var name: String = ""
    var id: Int = 0
    var position: String = ""
    var workYears: Int = 0
    
    init(id:Int, name:String, position:String, workYears:Int)
    {
        self.id = id
        self.name = name
        self.position = position
        self.workYears = workYears
    }
    
}

class Call
{
    
    var name: String = ""
    var id: Int = 0

    var address: String = ""
    var description: String = ""
    
    init(id:Int, name:String, address:String, description:String)
    {
        self.id = id
        self.name = name
        self.address = address
        self.description = description
    }
    
}
