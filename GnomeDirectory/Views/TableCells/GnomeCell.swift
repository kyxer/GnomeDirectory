//
//  GnomeCell.swift
//  GnomeDirectory
//
//  Created by German Mendoza on 9/14/17.
//  Copyright © 2017 Altran. All rights reserved.
//

import UIKit

class GnomeCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureWith(gnome:Gnome){
        nameLabel.text = gnome.name
        let count = gnome.professions.count - 1
        var professions = "Professions: "
        for (key,profession) in gnome.professions.enumerated() {
            if count == key {
                professions+=" \(profession)"
            } else {
                professions+=" \(profession),"
            }
            
        }
        detailLabel.text = professions
    }
}
