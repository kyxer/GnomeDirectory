//
//  Helpers.swift
//  GnomeDirectory
//
//  Created by German Mendoza on 9/14/17.
//  Copyright © 2017 Altran. All rights reserved.
//

import UIKit

class Helpers {

    static func configureNavigationBarBackground(navigationController:UINavigationController?, color:UIColor, tintColor:UIColor){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.tintColor = tintColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: tintColor]
        
        
    }
    
}
