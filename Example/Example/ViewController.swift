//
//  ViewController.swift
//  Example
//
//  Created by xaoxuu on 2018/6/15.
//  Copyright © 2018 Titan Studio. All rights reserved.
//

import UIKit
import ProHUD
import SnapKit

class ViewController: BaseListVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "ProHUD"
    }
    
    override var titles: [String] {
        return ["Toast", "Alert", "Guard"]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let vc = TestToastVC()
            vc.title = titles[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = TestAlertVC()
            vc.title = titles[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = TestGuardVC()
            vc.title = titles[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

