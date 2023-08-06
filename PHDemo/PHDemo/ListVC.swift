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
    
    lazy var header: TableHeaderView = TableHeaderView(text: "ProHUD")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableHeaderView = header
        tableView.sectionHeaderHeight = 32
        tableView.sectionFooterHeight = 8
        
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
