//
//  ViewController.swift
//  Example
//
//  Created by xaoxuu on 2018/6/15.
//  Copyright © 2018 Titan Studio. All rights reserved.
//

import UIKit
//import ProHUD
import SnapKit

class ViewController: BaseListVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "\(Bundle.main.infoDictionary?["CFBundleName"] ?? "ProHUD")"

        vm.addSection(title: "") { (sec) in
            sec.addRow(title: "Toast") {
                let vc = TestToastVC()
                vc.title = "Toast"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            sec.addRow(title: "Alert") {
                let vc = TestAlertVC()
                vc.title = "Alert"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            sec.addRow(title: "Guard") {
                let vc = TestGuardVC()
                vc.title = "Guard"
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
}

