//
//  HomeController.swift
//  GnomeDirectory
//
//  Created by German Mendoza on 9/14/17.
//  Copyright © 2017 Altran. All rights reserved.
//

import UIKit

enum RequestState:String {
    case loading
    case success
    case error
}

enum HomeControllerMode:String {
    case filtered
    case normal
}

class HomeController: UIViewController {
    
    @IBOutlet weak var tableViewBottomAnchor: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshController:UIRefreshControl = {
        let controller = UIRefreshControl()
        controller.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        return controller
    }()
    
    var items:[Gnome] = []
    var gnomesFiltered:[Gnome] = []
    var gnomesOrderByLetter:[(key: String, value: [Gnome])] = []
    let cellIdentifier = "cellIdentifier"
    let errorIdentifier = "errorIdentifier"
    let loadingIdentifier = "loadingIdentifier"
    let headerIdentifier = "headerIdentifier"
    var state:RequestState = .loading
    var mode:HomeControllerMode = .normal
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        setup()
        setupNavigationBar()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup(){
        searchBar.tintColor = UIColor.white
        searchBar.delegate = self
        searchBar.placeholder = "Search Gnome By Name"
        tableView.addSubview(refreshController)
        tableView.register(UINib(nibName:"GnomeCell", bundle:nil), forCellReuseIdentifier: cellIdentifier)
        tableView.register(UINib(nibName:"ErrorCell", bundle:nil), forHeaderFooterViewReuseIdentifier: errorIdentifier)
        tableView.register(UINib(nibName:"LoadingCell", bundle:nil), forHeaderFooterViewReuseIdentifier: loadingIdentifier)
        tableView.register(UINib(nibName:"DetailHeaderCell", bundle:nil), forHeaderFooterViewReuseIdentifier: headerIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        fetchGnomes()
    }
    
    func setupNavigationBar(){
        Helpers.configureNavigationBarBackground(navigationController: navigationController, color: UIColor.black, tintColor: .white)
        navigationItem.title = "Brastlewark"
        
    }
    
    func setupLetters(){
        var outputDict = [String:[Gnome]]()
        for gnome in items {
            let initialLetter:String = gnome.name.substring(to: (gnome.name.index(gnome.name.startIndex,offsetBy: 1))).uppercased()
            var letterArray = outputDict[initialLetter] ?? [Gnome]()
            letterArray.append(gnome)
            outputDict[initialLetter] = letterArray
        }
        gnomesOrderByLetter = outputDict.sorted(by: { $0.0 < $1.0 })
        state = .success
        tableView.reloadData()
    }
    
    func refresh(){
        fetchGnomes()
    }
    
    func fetchGnomes(){
        state = .loading
        tableView.reloadData()
        
        ApiService.shared().fetchGnomes(completion: { result in
            self.items = result
            self.refreshController.endRefreshing()
            self.setupLetters()
        }, error: { error in
            self.items = []
            self.state = .error
            self.tableView.reloadData()
            self.refreshController.endRefreshing()
        })
    }
    
    func filterUserWith(searchText:String) {
        gnomesFiltered = []
        for gnome in items {
            if gnome.name.contains(searchText) {
                gnomesFiltered.append(gnome)
            }
        }
        mode = .filtered
        tableView.reloadData()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            UIView.animate(withDuration: 0.5, animations: {
                self.tableViewBottomAnchor.constant = keyboardHeight
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        UIView.animate(withDuration: 0.5, animations: {
            self.tableViewBottomAnchor.constant = 0
        })
    }

}

extension HomeController:UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchBar.setShowsCancelButton(true, animated: true)
        }
        filterUserWith(searchText:searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mode = .normal
        tableView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        view.endEditing(true)
    }
}

extension HomeController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if state == .loading {
            return 1
        }
        if mode == .normal {
            return gnomesOrderByLetter.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if state == .loading {
            return 0
        }
        if mode == .normal {
            return gnomesOrderByLetter[section].value.count
        } else {
            return gnomesFiltered.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if state == .loading {
            return 0
        }
        if mode == .normal {
            return 40
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let letter = gnomesOrderByLetter[section].key
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! DetailHeaderCell
        header.configureWith(title: letter)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if state == .loading {
            return 50
        } else if state == .error {
            return 150
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if state == .loading {
            let cell =  tableView.dequeueReusableHeaderFooterView(withIdentifier: loadingIdentifier) as! LoadingCell
            cell.startAnimating()
            return cell
        } else if state == .error {
            let cell =  tableView.dequeueReusableHeaderFooterView(withIdentifier: errorIdentifier) as! ErrorCell
            cell.delegate = self
            return cell
            
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item:Gnome
        if mode == .normal {
            item = gnomesOrderByLetter[indexPath.section].value[indexPath.row]
        } else {
            item = gnomesFiltered[indexPath.row]
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! GnomeCell
        cell.configureWith(gnome: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item:Gnome
        if mode == .normal {
            item = gnomesOrderByLetter[indexPath.section].value[indexPath.row]
        } else {
            item = gnomesFiltered[indexPath.row]
        }
        let controller = DetailController()
        controller.gnome = item
        navigationController?.show(controller, sender: nil)
    }
    
}

extension HomeController:ErrorCellDelegate {
    func didtappedRefreshButton() {
        refresh()
    }
}
