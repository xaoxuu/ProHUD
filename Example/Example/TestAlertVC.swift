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
        return ["极端场景：正在同步（超时未处理）",
                "场景：同步成功（写法1）",
                "场景：同步成功（写法2）",
                "场景：同步失败和重试",
                "极端场景：短时间内调用了多次同一个弹窗",
                "极端场景：多个弹窗重叠"]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row == 0 {
            func f() {
                Alert.push(scene: .loading, title: "正在同步", message: "请稍等片刻") { (a) in
                    a.identifier = "loading"
                    a.rotate()
                    a.didForceQuit { [weak self] in
                        let t = Toast.push(scene: .loading, title: "正在同步", message: "请稍等片刻（点击展开为Alert）") { (vm) in
                            vm.identifier = "loading"
                        }
                        t.rotate()
                        t.didTapped { [weak t] in
                            t?.pop()
                            f()
                        }
                        self?.simulateSync()
                    }
                }
                simulateSync()
            }
            f()
        } else if row == 1 {
            Alert.push() { (a) in
                a.identifier = "loading"
                a.rotate()
                a.update { (vm) in
                    vm.scene = .loading
                    vm.title = "正在同步"
                    vm.message = "请稍等片刻"
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                Alert.find("loading", last: { (a) in
                    a.update { (vm) in
                        vm.scene = .success
                        vm.title = "同步成功"
                        vm.message = nil
                    }
                })
            }
        } else if row == 2 {
            let a = Alert.push() { (a) in
                a.identifier = "loading"
            }
            a.rotate()
            a.update { (vm) in
                vm.scene = .loading
                vm.title = "正在同步"
                vm.message = "请稍等片刻"
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                Alert.find("loading", last: { (a) in
                    a.update { (vm) in
                        vm.scene = .success
                        vm.title = "同步成功"
                        vm.message = nil
                    }
                })
            }
        } else if row == 3 {
            Alert.push() { (a) in
                a.identifier = "loading"
            }
            func loading() {
                Alert.find("loading", last: { (a) in
                    a.update { (vm) in
                        vm.scene = .loading
                        vm.title = "正在同步"
                        vm.message = "请稍等片刻"
                        vm.remove(action: 0, 1)
                    }
                    a.rotate()
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
                })
            }
            loading()
        } else if row == 4 {
            func loading(_ index: Int = 1) {
                Alert.find("loading", last: { (a) in
                    Toast.find("loading-tip", last: { (t) in
                        t.update { (vm) in
                            vm.title = "此时又调用了一次相同的弹窗 x\(index)"
                        }
                        t.pulse()
                    }) {
                        Toast.push(title: "此时又调用了一次相同的弹窗 x\(index)", message: "页面应该是没有任何变化的") { (t) in
                            t.identifier = "loading-tip"
                            t.update { (vm) in
                                vm.scene = .default
                                
                            }
                        }
                    }
                }) {
                    Alert.push() { (a) in
                        a.identifier = "loading"
                        a.update { (vm) in
                            vm.scene = .loading
                            vm.title = "正在加载"
                        }
                        a.rotate(direction: .counterclockwise)
                    }
                }
            }
            loading(1)
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                loading(2)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                loading(3)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                loading(4)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+3.5) {
                loading(5)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+4) {
                loading(6)
            }
        } else if row == 5 {
            func f(_ i: Int) {
                Alert.push() { (a) in
                    a.rotate()
                    a.update { (vm) in
                        vm.scene = .loading
                        vm.title = "正在同步" + String(i)
                        vm.message = "请稍等片刻"
                    }
                }
            }
            f(1)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                f(2)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                f(3)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                f(4)
            }
        }
    }

    func simulateSync() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            Alert.find("loading", last: { (a) in
                a.update { (vm) in
                    vm.scene = .success
                    vm.title = "同步成功"
                    vm.message = "啊哈哈哈哈哈哈哈哈"
                }
            })
        }
    }
    
}
