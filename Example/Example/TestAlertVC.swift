//
//  TestAlertVC.swift
//  Example
//
//  Created by xaoxuu on 2019/8/12.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import ProHUD

class TestAlertVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var titles: [String] {
        return ["场景：正在同步（超时）", "场景：同步成功", "场景：同步失败和重试"]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row == 0 {
            func f() {
                let a = Alert.push(scene: .loading, title: "正在同步", message: "请稍等片刻") { (vm) in
                    vm.identifier = "loading"
                }
                a.animate(rotate: true)
                a.didForceQuit { [weak self] in
                    let t = Toast.push(scene: .loading, title: "正在同步", message: "请稍等片刻（点击展开为Alert）") { (vm) in
                        vm.identifier = "loading"
                    }
                    t.animate(rotate: true)
                    t.didTapped { [weak t] in
                        t?.pop()
                        f()
                    }
                    self?.simulateSync()
                }
                simulateSync()
            }
            f()
        } else if row == 1 {
            Alert.push(scene: .loading, title: "正在同步", message: "请稍等片刻") { (vm) in
                vm.identifier = "loading"
            }.animate(rotate: true)
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                if let a = Alert.get("loading").last {
                    a.update { (vm) in
                        vm.scene = .success
                        vm.title = "同步成功"
                        vm.message = nil
                    }
                }
            }
        } else if row == 2 {
            Alert.push() { (vm) in
                vm.identifier = "loading"
            }
            func loading() {
                if let a = Alert.get("loading").last {
                    a.update { (vm) in
                        vm.scene = .loading
                        vm.title = "正在同步"
                        vm.message = "请稍等片刻"
                        vm.remove(action: 0, 1)
                    }
                    a.animate(rotate: true)
                    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                        a.update { (vm) in
                            vm.scene = .error
                            vm.title = "同步失败"
                            vm.message = "请检查网络是否通畅"
                            vm.add(action: .default, title: "重试") {
                                loading()
                            }
                            vm.add(action: .cancel, title: "取消", handler: nil)
                        }
                    }
                }
            }
            loading()
        }
    }

    func simulateSync() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            if let t = Alert.get("loading").last {
                t.update { (vm) in
                    vm.scene = .success
                    vm.title = "同步成功"
                    vm.message = "啊哈哈哈哈哈哈哈哈"
                }
            }
        }
    }
    
}
