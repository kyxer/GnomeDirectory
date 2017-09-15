//
//  DetailListCell.swift
//  GnomeDirectory
//
//  Created by German Mendoza on 9/14/17.
//  Copyright © 2017 Altran. All rights reserved.
//

import UIKit

class DetailListCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureWith(title:String) {
        titleLabel.text = title
    }
}
