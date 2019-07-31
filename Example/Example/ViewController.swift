//
//  ViewController.swift
//  Example
//
//  Created by xaoxuu on 2018/6/15.
//  Copyright © 2018 Titan Studio. All rights reserved.
//

import UIKit
import ProHUD

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
     
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let a = ProHUD.show(alert: .delete, title: "确认删除", message: "此操作不可撤销")
        
        a.addAction(style: .destructive, title: "删除") { [weak a] in
            a?.updateContent(scene: .success, title: "操作成功", message: "恭喜，您已经成功删除了xxx")
            a?.updateAction(index: 0, style: .default, title: "好的", action: {
                a?.remove()
            }).removeAction(index: 1)
//            a?.updateContent(scene: .success, title: "操作成功").removeAction(index: -1).timeout(2)
        }.addAction(style: .cancel, title: "取消", action: nil).didDisappear {
            debugPrint("didDisappear")
        }
        
//        ProHUD.show(alert: .delete, title: "克里斯蒂娜删除", message: "克里斯蒂娜疯狂拉升的反馈老实交代分开就撒开了击快乐圣诞").addAction(style: .destructive, title: "删除") {
//
//        }.addAction(style: .cancel, title: "取消", action: nil).didDisappear {
//            debugPrint("didDisappear")
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            
            
        }
    }
    
}

