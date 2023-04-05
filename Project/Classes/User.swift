//
//  User.swift
//  Project
//
//  Created by ChuantaiHu on 2023-03-31.
//

import UIKit

class User: NSObject {

    var userName:String?
    var email:String?
    var password:String?
    var birthday:String?
    var level:Int?
    
    
    func initWithData(userName un:String,theEmail e:String,password pw:String,birthday bth:String,level ll:Int){
        userName = un
        email = e
        password = pw
        birthday = bth
        level = ll
    }
}
