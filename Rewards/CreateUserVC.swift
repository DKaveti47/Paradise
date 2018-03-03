//
//  CreateUserVC.swift
//  Rewards
//
//  Created by Dheeraj Kaveti on 7/16/17.
//  Copyright © 2017 Dheeraj Kaveti. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateUserVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNametxtFld: UITextField!
    @IBOutlet weak var mobileTxtFld: UITextField!
    @IBOutlet weak var emailTxtFld: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func validateData() -> Bool{
    var alertString = [String]()
        if (firstNameTxtFld.text?.characters.count)! <= 1 {
            alertString.append("First Name")
        }
        if (lastNametxtFld.text?.characters.count)! <= 1 {
            alertString.append("Last Name")
        }
            if !mobileTxtFld.text!.isPhoneNumber{
                alertString.append("Phone Number")
            }
        
            if !(emailTxtFld.text?.isValidEmail())!{
                alertString.append("Email")
            }
        
        if alertString.count > 0 {
            let string = "Please enter valid " + alertString.joined(separator: " , ") + "."
            let alertController = UIAlertController(title: string, message: nil, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }else{
            return true
        }
        return false
    }
    
    @IBAction func didTapOnSignup(_ sender: Any) {
        if validateData() {
            func createNewUser(){
                let newBookRef = Database.database().reference().childByAutoId()
               // let newBookId = newBookRef.key
                let newBookData = [
                    "email": emailTxtFld.text!,
                    "firstname": firstNameTxtFld.text!,
                    "lastname":lastNametxtFld.text!,
                    "phone":mobileTxtFld.text!,
                    "date":Date().toString(style: .short),
                    "rewards":10
                    ] as [String : Any]
                newBookRef.setValue(newBookData)
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: {})
                }
            }
        }
    }
    
    @IBAction func didTapOnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: {})
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    

}
