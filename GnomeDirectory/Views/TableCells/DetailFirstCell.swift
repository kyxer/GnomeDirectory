//
//  DetailFirstCell.swift
//  GnomeDirectory
//
//  Created by German Mendoza on 9/14/17.
//  Copyright © 2017 Altran. All rights reserved.
//

import UIKit
import SDWebImage

class DetailFirstCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
  
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    var gnome:Gnome = Gnome()
    var container:UIView?
    
    func configureWith(gnome:Gnome){
        self.gnome = gnome
        nameLabel.text = gnome.name
        profileImageView.image = nil
        profileImageView.sd_setIndicatorStyle(.gray)
        profileImageView.sd_addActivityIndicator()
        profileImageView.sd_setImage(with: URL(string:gnome.thumbnail))
        
    }
    
    @IBAction func tappedExpandedButton(_ sender: Any) {
        
        if let controller = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController,
            let window = controller.topViewController {
            container = UIView()
            container?.backgroundColor = UIColor.black
            container?.translatesAutoresizingMaskIntoConstraints = false
            let image = UIImageView()
            image.translatesAutoresizingMaskIntoConstraints = false
            image.contentMode = .scaleAspectFit
            image.sd_setImage(with: URL(string:gnome.thumbnail))
            window.view.addSubview(container!)
            container?.topAnchor.constraint(equalTo: window.view.topAnchor).isActive = true
            container?.leftAnchor.constraint(equalTo: window.view.leftAnchor).isActive = true
            container?.rightAnchor.constraint(equalTo: window.view.rightAnchor).isActive = true
            container?.bottomAnchor.constraint(equalTo: window.view.bottomAnchor).isActive = true
            
            let button = UIButton(frame:CGRect(x:0,y:0, width:60, height:40))
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Close", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.addTarget(self, action: #selector(tappedCloseButton), for: .touchUpInside)
            container?.addSubview(image)
            container?.addSubview(button)
            
            button.topAnchor.constraint(equalTo: container!.topAnchor).isActive = true
            button.leftAnchor.constraint(equalTo: container!.leftAnchor).isActive = true
            button.widthAnchor.constraint(equalToConstant: 60).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            
            
            image.topAnchor.constraint(equalTo: container!.topAnchor).isActive = true
            image.leftAnchor.constraint(equalTo: container!.leftAnchor).isActive = true
            image.rightAnchor.constraint(equalTo: container!.rightAnchor).isActive = true
            image.bottomAnchor.constraint(equalTo: container!.bottomAnchor).isActive = true
            
        }
        
    }
    
    func tappedCloseButton(){
        container?.removeFromSuperview()
        container = nil
    }
}
