//
//  ViewController.swift
//  Rewards
//
//  Created by Dheeraj Kaveti on 7/16/17.
//  Copyright © 2017 Dheeraj Kaveti. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController,UITextFieldDelegate {
    var ref:DatabaseReference!
    var userObj:UserObject!
    @IBOutlet weak var checkinTextFld: UITextField!
    @IBOutlet weak var segmentBar: UISegmentedControl!
    var selectedSegment :Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //getting a reference to the node artists
        selectedSegment = 0
        ref = Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        didTapOnClear("")
        selectedSegment = segmentBar.selectedSegmentIndex
        setLblIndicatorText()
    }

    @IBAction func didTapOnSignUp(_ sender: Any) {
        self.view.endEditing(true)
        let someVC = self.storyboard?.instantiateViewController(withIdentifier: "CreateUserVC") as! CreateUserVC
        //self.navigationController?.pushViewController(someVC, animated: true)
        self.present(someVC, animated: true, completion: {})
        
    }
    
    @IBAction func didTapOnClear(_ sender: Any) {
        self.view.endEditing(true)
        self.checkinTextFld.text = ""
        
    }
    @IBAction func didTapOnSegment(_ sender: Any) {
        self.view.endEditing(true)
         selectedSegment = segmentBar.selectedSegmentIndex
        checkinTextFld.text = ""
        setLblIndicatorText()
    }
    
    @IBAction func didTapOnCheckin(_ sender: Any) {
        self.view.endEditing(true)
        if checkinTextFld.text?.characters.count == 0 {
            self.throwAlert(title: "Please enter valid Phone or Email", message: nil)
        }
        
        if selectedSegment == 0 {
            self.getUserData(byPhoneNumber: checkinTextFld.text!)
        }else{
            self.getUserData(byEmail: checkinTextFld.text!)
        }
    }
    
    func setLblIndicatorText(){
        if selectedSegment == 0 {
            self.checkinTextFld.placeholder = "Enter Your Phone Number"
        }else{
            self.checkinTextFld.placeholder = "Enter Your Email Address"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if selectedSegment == 0 {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func didTapOnNumber(_ sender: UIButton) {
        if checkinTextFld.text == nil || (checkinTextFld.text?.count)! < 10 {
            checkinTextFld.text! += "\(sender.tag)"
        }
    }
    
    @IBAction func didTapOnDelete(_ sender: UIButton) {
        if (checkinTextFld.text?.count)! > 0 {
            checkinTextFld.text = String(checkinTextFld.text!.dropLast())
        }
    }
    

}

extension ViewController{
    func getUserData(byPhoneNumber:String){
     let ref1 =    Database.database().reference().queryOrdered(byChild: "phone").queryEqual(toValue : byPhoneNumber)
        
        ref1.observe(.value, with:{ (snapshot: DataSnapshot) in
            if snapshot.children.allObjects.count == 0 {
                DispatchQueue.main.async {
                    self.throwAlert(title: "No Rewards found for phone \(byPhoneNumber).", message: "Please Sign up.")
                    return
                }
            }
            for snap in snapshot.children {
                self.userObj = UserObject()
                self.userObj.convertDictToObj(dict: (snap as! DataSnapshot).value as! [String : Any])
                break
            }
        })

    }
    
    func getUserData(byEmail:String){
        let ref1 = Database.database().reference().queryOrdered(byChild: "email").queryEqual(toValue : byEmail)
    
       ref1.observe(.value, with:{ (snapshot: DataSnapshot) in
          if snapshot.children.allObjects.count == 0 {
            DispatchQueue.main.async {
                self.throwAlert(title: "No Rewards found for email \(byEmail).", message: "Please Sign up.")
                return
            }
        }
            for snap in snapshot.children {
                self.userObj = UserObject()
                 self.userObj.convertDictToObj(dict: (snap as! DataSnapshot).value as! [String : Any])
                break
            }
        })
    }
    
    
    func throwAlert(title:String? , message:String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)

    }

}

