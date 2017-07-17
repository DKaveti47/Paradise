//
//  UserObject.swift
//  Rewards
//
//  Created by Dheeraj Kaveti on 7/16/17.
//  Copyright © 2017 Dheeraj Kaveti. All rights reserved.
//

import UIKit

class UserObject: NSObject {
    var firstName:String!
    var lastName:String!
    var email:String!
    var phNumber:String!
    var rewards:Int!
    var lasRewardsUsedDate:Date!
    var dateCreated:String!
    
    func convertDictToObj(dict:[String:Any]){
        self.email = dict["email"] as! String
        self.firstName = dict["firstname"] as! String
        self.lastName = dict["lastname"] as! String
        self.phNumber = dict["phone"] as! String
        self.dateCreated = dict["date"] as! String
        self.rewards = dict["rewards"] as! Int
    }
    
}
