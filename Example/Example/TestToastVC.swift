//
//  TestToastVC.swift
//  Example
//
//  Created by xaoxuu on 2019/8/12.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import ProHUD

class TestToastVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var titles: [String] {
        return ["场景：正在同步",
                "场景：同步成功",
                "场景：同步失败",
                "场景：设备电量过低",
                "传入指定图标",
                "禁止手势移除",
                "组合使用示例"]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row == 0 {
            Toast.push(scene: .loading, title: "正在同步", message: "请稍等片刻") { (vm) in
                vm.identifier = "loading"
            }.animate(rotate: true)
            simulateSync()
        } else if row == 1 {
            let t = Toast.push(scene: .success, title: "同步成功", message: "点击查看详情")
            t.didTapped { [weak self, weak t] in
                self?.presentEmptyVC(title: "详情")
                t?.pop()
            }
        } else if row == 2 {
            let t = Toast.push(scene: .error, title: "同步失败", message: "请稍后重试。点击查看详情") { (vm) in
                vm.duration = 0
            }
            t.didTapped { [weak self, weak t] in
                self?.presentEmptyVC(title: "这是错误详情")
                t?.pop()
            }
            
        } else if row == 3 {
            Toast.push(scene: .warning, title: "设备电量过低", message: "请及时对设备进行充电，以免影响使用。")
            
        } else if row == 4 {
            Toast.push(scene: .default, title: "传入指定图标测试", message: "这是消息内容") { (vm) in
                vm.icon = UIImage(named: "icon_download")
            }
        } else if row == 5 {
            Toast.push(scene: .default, title: "禁止手势移除", message: "这条消息无法通过向上滑动移出屏幕。5秒后自动消失，每次拖拽都会刷新倒计时。") { (vm) in
                vm.removable = false
                vm.duration = 5
            }
        } else if row == 6 {
            let t = Toast.push(scene: .default, title: "好友邀请", message: "你收到一条好友邀请，点击查看详情。", duration: 10)
            
            t.didTapped { [weak t] in
                t?.pop()
                Alert.push(scene: .confirm, title: "好友邀请", message: "用户xxx想要添加你为好友，是否同意？") { (vm) in
                    let vc = vm.vc
                    vm.add(action: .default, title: "接受") {
                        vc?.pop()
                        Toast.push(scene: .success, title: "好友添加成功", message: "这是消息内容")
                    }
                    vm.add(action: .cancel, title: "拒绝") {
                        
                    }
                }
            }
        }
        
    }
    
    func simulateSync() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if let t = Toast.get("loading").last {
                t.update { (vm) in
                    vm.scene = .success
                    vm.title = "同步成功"
                    vm.message = "啊哈哈哈哈哈哈哈哈"
                }
            }
        }
    }
    
}
