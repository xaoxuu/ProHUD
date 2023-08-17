//
//  ListVC.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit
import ProHUD

class ListVC: UITableViewController {

    var list = ListModel()
    
    lazy var header: TableHeaderView = TableHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = header
        tableView.sectionHeaderHeight = 32
        tableView.sectionFooterHeight = 8
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = .init(title: "ProHUD", style: .done, target: self, action: #selector(self.onTappedLeftBarButtonItem(_:)))
        navigationItem.rightBarButtonItem = .init(image: .init(systemName: "questionmark.circle.fill"), style: .done, target: self, action: #selector(self.onTappedRightBarButtonItem(_:)))
        
    }
    
    
    @objc func onTappedLeftBarButtonItem(_ sender: UIBarButtonItem) {
        guard let url = URL(string: "https://github.com/xaoxuu/ProHUD") else { return }
        UIApplication.shared.open(url)
    }
    
    @objc func onTappedRightBarButtonItem(_ sender: UIBarButtonItem) {
        guard let url = URL(string: "https://xaoxuu.com/wiki/prohud/") else { return }
        UIApplication.shared.open(url)
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        list.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        list.sections[section].rows.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        list.sections[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = list.sections[indexPath.section].rows[indexPath.row].title
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        AppContext.workspace = self
        list.sections[indexPath.section].rows[indexPath.row].action()
    }
    

}
