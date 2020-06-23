//
//  BaseListVC.swift
//  Example
//
//  Created by xaoxuu on 2019/8/12.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

typealias Callback = () -> Void

struct Table {
    var sections = [Section]()
    mutating func addSection(title: String, callback: @escaping (inout Section) -> Void) {
        var sec = Section()
        sec.header = title
        callback(&sec)
        sections.append(sec)
    }
}
struct Section {
    var header = ""
    var footer = ""
    var rows = [Row]()
    mutating func addRow(title: String, subtitle: String? = nil, callback: @escaping Callback) {
        rows.append(Row(title: title, subtitle: subtitle, callback: callback))
    }
}
struct Row {
    var title: String
    var subtitle: String?
    var callback: Callback
}

class BaseListVC: UIViewController {

    
    var ts = [[String]]()
    var cs = [[Callback]]()
    
    var vm = Table()
    var secs = [Section]()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (mk) in
            mk.edges.equalToSuperview()
        }
    }
    
    
}

extension BaseListVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.sections[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let c = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = c
        } else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.textColor = .gray
            cell.detailTextLabel?.numberOfLines = 0
            
        }
        cell.textLabel?.text = vm.sections[indexPath.section].rows[indexPath.row].title
        cell.detailTextLabel?.text = vm.sections[indexPath.section].rows[indexPath.row].subtitle
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return vm.sections[section].header
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return vm.sections[section].footer
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        vm.sections[indexPath.section].rows[indexPath.row].callback()
    }
    
}

