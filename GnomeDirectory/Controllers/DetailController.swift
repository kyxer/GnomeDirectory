//
//  DetailController.swift
//  GnomeDirectory
//
//  Created by German Mendoza on 9/14/17.
//  Copyright © 2017 Altran. All rights reserved.
//

import UIKit

class DetailController: UIViewController {
    
    lazy var tableView:UITableView = {
        let table = UITableView()
        table.register(UINib(nibName:"DetailFirstCell", bundle:nil), forCellReuseIdentifier: self.firstIdentifier)
        table.register(UINib(nibName:"DetailInfoCell", bundle:nil), forCellReuseIdentifier: self.infoIdentifier)
        table.register(UINib(nibName:"DetailHeaderCell", bundle:nil), forHeaderFooterViewReuseIdentifier: self.headerIdentifier)
        table.register(UINib(nibName:"DetailListCell", bundle:nil), forCellReuseIdentifier: self.listIdentifier)
        table.delegate = self
        table.dataSource = self
        table.tableFooterView = UIView(frame:CGRect.zero)
        table.rowHeight = UITableViewAutomaticDimension
        table.estimatedRowHeight = 200
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let firstIdentifier = "firstIdentifier"
    let infoIdentifier = "infoIdentifier"
    let headerIdentifier = "headerIdentifier"
    let listIdentifier = "listIdentifier"
    var gnome:Gnome = Gnome() {
        didSet {
            setup()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
    }
    
    func setupNavigationBar(){
        Helpers.configureNavigationBarBackground(navigationController: navigationController, color: UIColor.black, tintColor: .white)
        navigationItem.title = gnome.name
    }
    
    func setup(){
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

extension DetailController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1:
            return 1
        case 2:
            return gnome.professions.count
        case 3:
            return gnome.friends.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1,2,3:
            return 50
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! DetailHeaderCell
        switch section {
        case 1:
            header.configureWith(title: "Information")
        case 2:
            header.configureWith(title: "Professions")
        case 3:
            header.configureWith(title: "Friends")
        default:
            print("")
            break
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: firstIdentifier, for: indexPath) as! DetailFirstCell
            cell.configureWith(gnome: gnome)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: infoIdentifier, for: indexPath) as! DetailInfoCell
            cell.configureWith(gnome: gnome)
            return cell
        case 2:
            let item = gnome.professions[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: listIdentifier, for: indexPath) as! DetailListCell
            cell.configureWith(title: item)
            return cell
        case 3:
            let item = gnome.friends[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: listIdentifier, for: indexPath) as! DetailListCell
            cell.configureWith(title: item)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
