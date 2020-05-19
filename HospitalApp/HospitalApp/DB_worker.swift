//
//  DB_worker.swift
//  HospitalApp
//
//  Created by Alex on 17.05.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        //createTable()
    }

    let dbPath: String = "database.sqlite"
    var db:OpaquePointer?

    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        
        print(fileURL.path)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    
    func insert(id:Int, diagnos:String, time:String, hosp:Bool, descr:String, patID:Int, brigID:Int, ready: Bool)
    {
        let insertStatementString = "INSERT INTO Call (ID, Diagnos, Time, Hospitalization, Description, PatientID, BrigadeID, Ready) VALUES (?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (diagnos as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (time as NSString).utf8String, -1, nil)
            
            if hosp{
                sqlite3_bind_text(insertStatement, 4, ("TRUE" as NSString).utf8String, -1, nil)
            }
            else
            {
                sqlite3_bind_text(insertStatement, 4, ("FALSE" as NSString).utf8String, -1, nil)
            }
            sqlite3_bind_text(insertStatement, 5, (descr as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 6, Int32(patID))
            sqlite3_bind_int(insertStatement, 7, Int32(brigID))
            if ready{
                sqlite3_bind_text(insertStatement, 8, ("TRUE" as NSString).utf8String, -1, nil)
            }
            else
            {
                sqlite3_bind_text(insertStatement, 8, ("FALSE" as NSString).utf8String, -1, nil)
            }
            
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM person WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func readFromAdminByInfo(name: String, id: String) -> [Administrator] {
        let queryStatementString = "SELECT * FROM Administrator WHERE Administrator.ID = (?) AND Administrator.Name = (?);"
        var queryStatement: OpaquePointer? = nil
        var psns : [Administrator] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(id)!)
            sqlite3_bind_text(queryStatement, 2, (name as NSString).utf8String, -1, nil)
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                psns.append(Administrator(id: Int(id), name: name))
                print("Query Result:")
                print("\(id) | \(name)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func readFromEmployeeByInfo(name: String, id: String) -> [Employee] {
           let queryStatementString = "SELECT * FROM Employee WHERE Employee.ID = (?) AND Employee.Name = (?);"
           var queryStatement: OpaquePointer? = nil
           var psns : [Employee] = []
           
           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
               sqlite3_bind_int(queryStatement, 1, Int32(id)!)
               sqlite3_bind_text(queryStatement, 2, (name as NSString).utf8String, -1, nil)
               while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let position = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let year = sqlite3_column_int(queryStatement, 3)
                psns.append(Employee(id: Int(id), name: name, position: position, workYears: Int(year)))
                print("Query Result:")
                print("\(id) | \(name)")
               }
           } else {
               print("SELECT statement could not be prepared")
           }
           sqlite3_finalize(queryStatement)
           return psns
    }
    
    func readFromDispetcherByInfo(name: String, id: String) -> [Administrator] {
           let queryStatementString = "SELECT * FROM Dispetcher WHERE Dispetcher.ID = (?) AND Dispetcher.Name = (?);"
           var queryStatement: OpaquePointer? = nil
           var psns : [Administrator] = []
           
           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
               sqlite3_bind_int(queryStatement, 1, Int32(id)!)
               sqlite3_bind_text(queryStatement, 2, (name as NSString).utf8String, -1, nil)
               while sqlite3_step(queryStatement) == SQLITE_ROW {
                   let id = sqlite3_column_int(queryStatement, 0)
                   let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                   psns.append(Administrator(id: Int(id), name: name))
                   print("Query Result:")
                   print("\(id) | \(name)")
               }
           } else {
               print("SELECT statement could not be prepared")
           }
           sqlite3_finalize(queryStatement)
           return psns
       }
    
    func getPatId(name: String, gender: String) -> Int32 {
           let queryStatementString = "SELECT * FROM Patient WHERE Patient.Name = (?) AND Patient.Gender = (?);"
           var queryStatement: OpaquePointer? = nil

           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
               sqlite3_bind_text(queryStatement, 1, (name as NSString).utf8String, -1, nil)
               sqlite3_bind_text(queryStatement, 2, (gender as NSString).utf8String, -1, nil)
               while sqlite3_step(queryStatement) == SQLITE_ROW {
                   let id = sqlite3_column_int(queryStatement, 0)
                return id
               }
           } else {
               print("SELECT statement could not be prepared")
           }
           sqlite3_finalize(queryStatement)
           return 0
       }
    
    func getNextId() -> Int32 {
        let queryStatementString = "SELECT max(Call.ID) FROM Call;"
        var queryStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
             return id+1
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return 0
    }
    func getNextOrderId() -> Int32 {
        let queryStatementString = "SELECT max(Orders.ID) FROM Orders;"
        var queryStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
             return id+1
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return 0
    }
    func getNextCallId() -> Int32 {
        let queryStatementString = "SELECT max(Call.ID) FROM Call;"
        var queryStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
             return id+1
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return 0
    }
    
    func getNextBrigadeId() -> Int32 {
        let queryStatementString = "SELECT max(Brigade.ID) FROM Brigade;"
        var queryStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
             return id+1
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return 0
    }
    
    func insertBrigade(id:Int, time:String, empl: [Employee])
    {
        let insertStatementString = "INSERT INTO Brigade (ID, Time) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (time as NSString).utf8String, -1, nil)

            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        
        for i in 0...2{
            let insertStatementString = "INSERT INTO Orders (ID, brigadeID, employeeID) VALUES (?, ?, ?);"
            var insertStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStatement, 1, Int32(getNextOrderId()))
                sqlite3_bind_int(insertStatement, 2, Int32(id))
                sqlite3_bind_int(insertStatement, 3, Int32(empl[i].id))

                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }
    }
    
    func setCallAsReady(brigId: Int, callId: Int){
        let queryStatementString = "UPDATE Call Set Ready = TRUE, BrigadeID = (?) WHERE ID = (?);"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(brigId))
            
            sqlite3_bind_int(queryStatement, 2, Int32(callId))
            while sqlite3_step(queryStatement) == SQLITE_ROW {
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
    }
    
    func getFreeCall(brigID: Int) -> Call {
        let queryStatementString = "SELECT Call.ID, Patient.Name, Patient.Address, Call.Description from Call join Patient on Call.PatientID=Patient.ID WHERE Call.Ready == 'FALSE';"
               var queryStatement: OpaquePointer? = nil
               var psns : [Call] = []
               
               if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                   while sqlite3_step(queryStatement) == SQLITE_ROW {
                        let id = sqlite3_column_int(queryStatement, 0)
                        let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                        let address = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                        let description = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                        psns.append(Call(id: Int(id), name: name, address: address, description: description))
                   }
               } else {
                   print("SELECT statement could not be prepared")
               }
               sqlite3_finalize(queryStatement)
        if psns.count == 0{
            return Call(id: 0, name: "", address: "", description: "")
        }
        else{
            setCallAsReady(brigId: brigID, callId: psns[0].id)
               return psns[0]
        }
    }
    
    func getBrigadeId(id: Int) -> Int32 {
           let queryStatementString = "SELECT Orders.ID from Employee join Orders on Employee.ID = Orders.employeeID WHERE Employee.ID = (?);"
           var queryStatement: OpaquePointer? = nil

        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(queryStatement, 1, Int32(id))
            var brigade: Int = -1
               while sqlite3_step(queryStatement) == SQLITE_ROW {
                brigade = Int(sqlite3_column_int(queryStatement, 0))
               }
            return Int32(brigade)
           } else {
               print("SELECT statement could not be prepared")
           }
           sqlite3_finalize(queryStatement)
           return 0
       }
    
    func finishCall(callId: Int, diagnos: String, hosp:Bool){
           let queryStatementString = "UPDATE Call Set Diagnos = (?), Hospitalization = (?) WHERE ID = (?);"
           var queryStatement: OpaquePointer? = nil
           
           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_text(queryStatement, 1, (diagnos as NSString).utf8String, -1, nil)
            if hosp{
            sqlite3_bind_text(queryStatement, 2, "TRUE" , -1, nil)
            }
            else{
                sqlite3_bind_text(queryStatement, 2, "FALSE" , -1, nil)
            }
            sqlite3_bind_int(queryStatement, 3, Int32(callId))
               
               while sqlite3_step(queryStatement) == SQLITE_ROW {
               }
           } else {
               print("SELECT statement could not be prepared")
           }
           sqlite3_finalize(queryStatement)
       }
    
}
