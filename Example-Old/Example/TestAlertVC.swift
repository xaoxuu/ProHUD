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
                "极端场景：多个不同的弹窗重叠",
                "测试较长的标题和内容",
                "测试特别长的标题和内容",
                "场景：正在同步（更新进度）"]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row == 0 {
            func f() {
                Alert.push(scene: .loading, title: "正在同步", message: "请稍等片刻") { (a) in
                    a.identifier = "loading"
                    a.startRotate()
                    a.didForceQuit {
                        let t = Toast.push(scene: .loading, title: "正在同步", message: "请稍等片刻（点击展开为Alert）") { (vm) in
                            vm.identifier = "loading"
                        }
                        t.startRotate()
                        t.didTapped { [weak t] in
                            t?.pop()
                            f()
                        }
                    }
                }
            }
            f()
        } else if row == 1 {
            Alert.push() { (a) in
                a.identifier = "loading"
                a.startRotate()
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
            a.startRotate()
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
                    a.startRotate()
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
                if let _ = Alert.find("loading").last {
                    Toast.push("loading-tip") { (t) in
                        t.update { (vm) in
                            vm.title = "此时又调用了一次相同的弹窗 x\(index)"
                        }
                        t.pulse()
                    }
                } else {
                    Alert.push("loading") { (a) in
                        a.update { (vm) in
                            vm.scene = .loading
                            vm.title = "正在加载"
                        }
                        a.startRotate()
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
                    a.startRotate()
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
        } else if row == 6 {
            Alert.push() { (a) in
                a.update { (vm) in
                    vm.scene = .confirm
                    vm.title = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                    vm.message = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                    vm.add(action: .default, title: "我知道了", handler: nil)
                }
            }
        } else if row == 7 {
            Alert.push() { (a) in
                a.update { (vm) in
                    vm.scene = .warning
                    vm.title = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                    vm.message = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                    vm.add(action: .default, title: "我知道了", handler: nil)
                }
            }
        } else if row == 8 {
            Alert.push("progress") { (a) in
                a.update { (vm) in
                    vm.scene = .loading
                    vm.title = "正在同步"
                    vm.message = "请稍等片刻"
                }
                a.startRotate()
                a.update(progress: 0)
                let s = DispatchSemaphore(value: 1)
                DispatchQueue.global().async {
                    for i in 0 ... 5 {
                        s.wait()
                        DispatchQueue.main.async {
                            Alert.find("progress", last: { (a) in
                                a.update(progress: CGFloat(i)/5)
                                print("\(CGFloat(i)/5)")
                                if i == 5 {
                                    a.update { (vm) in
                                        vm.scene = .success
                                        vm.title = "同步成功"
                                        vm.message = nil
                                    }
                                }
                            })
                            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                s.signal()
                            }
                        }
                    }
                }
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
