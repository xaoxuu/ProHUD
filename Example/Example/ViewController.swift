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
        
        
        ProHUD.configAlert { (alert) in
            alert.minimizeTimeout = 1
            
        }
        
    }
     
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        ProHUD.show(alert: .delete, title: "确认删除", message: "此操作不可撤销").timeout(nil)
        
        ProHUD.show(alert: .loading, title: "确认删除", message: "此操作不可撤销").timeout(nil)
        
        ProHUD.show(alert: .confirm, title: "确认删除", message: "此操作不可撤销").timeout(3)
        
//
//        a.addAction(style: .destructive, title: "删除") { [weak a] in
//            a?.updateContent(scene: .success, title: "操作成功", message: "恭喜，您已经成功删除了xxx")
//            a?.updateAction(index: 0, style: .default, title: "好的", action: {
//                a?.remove()
//            }).removeAction(index: 1)
////            a?.updateContent(scene: .success, title: "操作成功").removeAction(index: -1).timeout(2)
//        }.addAction(style: .cancel, title: "取消", action: nil).didDisappear {
//            debugPrint("didDisappear")
//        }
//        
//        ProHUD.show(alert: .delete, title: "克里斯蒂娜删除", message: "克里斯蒂娜疯狂拉升的反馈老实交代分开就撒开了击快乐圣诞").addAction(style: .destructive, title: "删除") {
//
//        }.addAction(style: .cancel, title: "取消", action: nil).didDisappear {
//            debugPrint("didDisappear")
//        }.addAction(style: .cancel, title: nil) {
//
//        }
        
//        let t = ProHUD.Toast(scene: .loading, title: "正在加载", message: "请稍候片刻")
//
//        let a = ProHUD.show(alert : .loading, title: "正在加载", message: "请稍候片刻")
//        a.didMinimize {
//            hud.show(t)
//        }
//        t.didTapped { [weak t] in
//            t?.remove()
//            let a2 = ProHUD.show(alert: .loading, title: "正在加载", message: "马上就要成功了")
//            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//                let a3 = ProHUD.show(alert: .error, title: "加载失败", message: "点击充实")
//                a3.addAction(style: .default, title: "重新加载") { [weak a3] in
//                    a3?.updateContent(scene: .success, title: "加载成功", message: "马上就要成功了")
//                    a3?.updateAction(index: 0, style: .default, title: "OK", action: { [weak a2, a3] in
//                        a2?.remove()
//                        a3?.remove()
//                    }).removeAction(index: 1).removeAction(index: 1)
//                }.addAction(style: .destructive, title: "终止", action: nil).addAction(style: .cancel, title: "取消", action: nil)
//
//            }
//
//        }
        
        
//        ProHUD.show(toast: .loading, title: "正在加载", message: "拉升的反馈老实交代分开就撒开了击快乐圣反馈老实交代分开就撒开了击快乐圣")
//        ProHUD.show(toast: .loading, title: "正在加载", message: "哈克里斯蒂娜疯狂拉升的反馈老实交代分开就撒开了击快乐圣诞哈克里斯蒂娜疯狂拉升的反馈老实交代分开就撒开了击快乐圣诞")
        
    }
    
}

