//
//  ViewController.swift
//  HospitalApp
//
//  Created by Alex on 17.05.2020.
//  Copyright © 2020 Alex. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    let cellReuseIdentifier = "cell"
    
    var db: DBHelper = DBHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        table.delegate = self
        table.dataSource = self

        self.errorLabel.text = ""
        self.dispetcherView.isHidden = true
        self.dispetcherError.text = ""
    }
    
    
    
    // MARK: - Authorization stack
    
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var segmentEmployeeType: UISegmentedControl!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var registerView: UIView!
    
    
    @IBAction func logIn(_ sender: Any) {
        errorLabel.text = ""
        
        let username = userNameField.text
        let id = idField.text
        
        if username == ""{
            errorLabel.text = "Error: username is empty"
        }
        else if id == ""{
            errorLabel.text = "Error id is empty"
        }
        else{
            switch(segmentEmployeeType.selectedSegmentIndex){
            case 0:
                if (db.readFromAdminByInfo(name: username!, id: id!).count != 0){
                    registerView.isHidden = true
                    adminView.isHidden = false
                }
                else{
                    errorLabel.text = "Error entered data is invalid"
                }
                break
            case 1:
                if (db.readFromEmployeeByInfo(name: username!, id: id!).count != 0){
                    registerView.isHidden = true
                    employeeView.isHidden = false
                    EI = EmployeeInterface(db: db, id: Int(_: id!)!)
                    brigadeNum.text = "Brigade: " + String(db.getBrigadeId(id: EI.getID()))
                    
                    employeeNameField.text = ""
                    employeeAddressLable.text = ""
                    employeeDescriptionLabel.text = ""
                }
                else{
                    errorLabel.text = "Error entered data is invalid"
                }
                break
            case 2:
                if (db.readFromDispetcherByInfo(name: username!, id: id!).count != 0){
                    registerView.isHidden = true
                    self.dispetcherView.isHidden = false
                    DI = DispetcherInterface(id: Int(_: id!)!, db: db)
                }
                else{
                    errorLabel.text = "Error entered data is invalid"
                }
                break
            default:
                break
            }
        }
    }
    
    
    // MARK: - Dispetcher stack
    var DI: DispetcherInterface = DispetcherInterface(id: 0, db: DBHelper())
    
    @IBOutlet weak var dispetcherView: UIView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var diagnosField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var dispetcherError: UILabel!
    
    @IBAction func addCall(_ sender: Any) {
        let name = nameField.text
        let gender = genderField.text
        let diagnos = diagnosField.text
        let address = addressField.text
        let descr = descriptionField.text
        
        dispetcherError.text = DI.addCall(name: name!, gender: gender!, diagnos: diagnos!, address: address!, descr: descr!)
    }
    
    // MARK: - Admin stack

    @IBOutlet weak var adminView: UIView!
    
    @IBOutlet weak var adminNameField: UITextField!
    @IBOutlet weak var adminIdField: UITextField!
    @IBOutlet weak var adminError: UILabel!
    @IBOutlet weak var timeField: UITextField!
    
    var AI: AdminInterface = AdminInterface(db: DBHelper())
    
    @IBAction func addEmployee(_ sender: Any) {
        adminError.text = ""
        
        let id = adminIdField.text
        let name = adminNameField.text
        if id == "" || name == ""{
            adminError.text = "Field must be not empty"
            return
        }
        adminError.text = AI.addEmployee(id: Int(_: id!)!, name: name!)
        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return AI.GetNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        cell.textLabel?.text = AI.GetEmplInformation(num: indexPath.row)
        
        return cell
    }
    
    @IBAction func createBrigade(_ sender: Any) {
        adminError.text = AI.CreateBrigade(time: timeField.text!)
        table.reloadData()
    }
    
    // MARK: - Employee stack
    
    @IBOutlet weak var employeeView: UIView!
    @IBOutlet weak var employeeNameField: UILabel!
    @IBOutlet weak var employeeAddressLable: UILabel!
    @IBOutlet weak var employeeDescriptionLabel: UILabel!
    
    @IBOutlet weak var brigadeNum: UILabel!
    @IBOutlet weak var employeeDiagnosField: UITextField!
    @IBOutlet weak var hospSwitch: UISwitch!
    
    var EI: EmployeeInterface = EmployeeInterface(db: DBHelper(), id: 0)
    
    func getNextCall(){
        employeeNameField.text = ""
        employeeAddressLable.text = ""
        employeeDescriptionLabel.text = ""
        
        let call = EI.getFreeCall()
        if(call.id != 0){
            employeeNameField.text = call.name
            employeeAddressLable.text = call.address
            employeeDescriptionLabel.text = call.description
            
            
        }
        else{
            employeeNameField.text = "No patients in queue"
        }
    }
    
    @IBAction func acceptButton(_ sender: Any) {
        if employeeAddressLable.text != ""{
            let diagnos = employeeDiagnosField.text
            let hosp = hospSwitch.isOn
            
            EI.finishCall(diagnos: diagnos!, hosp: hosp)
        }
        getNextCall()
    }
}

