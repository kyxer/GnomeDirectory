//
//  Extensions.swift
//  GnomeDirectory
//
//  Created by German Mendoza on 9/14/17.
//  Copyright © 2017 Altran. All rights reserved.
//

import UIKit


extension UIApplication {
    
    var statusBarView:UIView? {
        return value(forKey:"statusBar") as? UIView
    }
    
}
