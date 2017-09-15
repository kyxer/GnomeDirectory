//
//  ErrorCell.swift
//  GnomeDirectory
//
//  Created by German Mendoza on 9/14/17.
//  Copyright © 2017 Altran. All rights reserved.
//

import UIKit

protocol ErrorCellDelegate:class {
    func didtappedRefreshButton()
}

class ErrorCell: UITableViewHeaderFooterView {
    
    weak var delegate:ErrorCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func tappedRefreshButton(_ sender: Any) {
        delegate?.didtappedRefreshButton()
    }
}
