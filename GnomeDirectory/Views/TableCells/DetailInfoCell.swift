//
//  DetailInfoCell.swift
//  GnomeDirectory
//
//  Created by German Mendoza on 9/14/17.
//  Copyright © 2017 Altran. All rights reserved.
//

import UIKit

class DetailInfoCell: UITableViewCell {
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var hairLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureWith(gnome:Gnome){
        hairLabel.text = "Hair Color: \(gnome.hair_color)"
        ageLabel.text = "Age: \(gnome.age)"
        weightLabel.text = "Weight: \(gnome.weight)"
        heightLabel.text = "Height: \(gnome.height)"
    }
    
    
    
}
