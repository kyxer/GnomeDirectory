//
//  Gnome.swift
//  GnomeDirectory
//
//  Created by German Mendoza on 9/14/17.
//  Copyright © 2017 Altran. All rights reserved.
//

import Foundation


class Gnome:SafeJsonObject {
    
    var id:Int = 0
    var name:String = ""
    var thumbnail:String = ""
    var age:Int = 0
    var weight:Float = 0.0
    var height:Float = 0.0
    var hair_color:String = ""
    var professions:[String] = []
    var friends:[String] = []
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "id" {
            if let uwnrappedValue = value as? Int {
                id = uwnrappedValue
            }
        } else if key == "age" {
            if let uwnrappedValue = value as? Int {
                age = uwnrappedValue
            }
        } else if key == "weight" {
            if let uwnrappedValue = value as? Float {
                weight = uwnrappedValue
            }
        } else if key == "height" {
            if let uwnrappedValue = value as? Float {
                height = uwnrappedValue
            }
        } else if key == "professions" {
            if let uwnrappedValue = value as? [String] {
                professions = uwnrappedValue
            }
        } else if key == "friends" {
            if let uwnrappedValue = value as? [String] {
                friends = uwnrappedValue
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    override init(){
        super.init()
    }
    
    init(dictionary:[String:AnyObject]){
        super.init()
        setValuesForKeys(dictionary)
    }
    
}
