//
//  RootVC.swift
//  Example
//
//  Created by xaoxuu on 2019/8/12.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

class RootVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let vc = ViewController()
        let nav = UINavigationController(rootViewController: vc)
        addChild(nav)
        view.addSubview(nav.view)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
