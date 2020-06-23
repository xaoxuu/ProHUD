//
//  TestAlertVC.swift
//  Example
//
//  Created by xaoxuu on 2019/8/12.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import ProHUD

// 模拟2秒后同步成功
func loadingSuccessAfter2Seconds() {
    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
        Alert.find("loading", last: { (a) in
            a.update { (vm) in
                vm.scene = .success
                vm.title = "同步成功"
                vm.message = nil
            }
        })
    }
}

class TestAlertVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.addSection(title: "最简单的写法") { (sec) in
            sec.addRow(title: "Alert.push(scene: .loading)") {
                Alert.push(scene: .loading)
            }
            sec.addRow(title: "Alert.push(scene: .success)") {
                Alert.push(scene: .success)
            }
            sec.addRow(title: "Alert.push(scene: .warning)") {
                Alert.push(scene: .warning)
            }
            sec.addRow(title: "Alert.push(scene: .error)") {
                Alert.push(scene: .error)
            }
            sec.addRow(title: "Alert.push(scene: .failure)") {
                Alert.push(scene: .failure)
            }
            sec.footer = "这些是自带的场景，可以重写已有场景，或者扩展新的场景。"
        }
        
        vm.addSection(title: "常用场景示例") { (sec) in
            // MARK: 场景：同步成功（写法1）
            sec.addRow(title: "场景：同步成功（写法1）") {
                Alert.push("loading") { (a) in
                    a.update { (vm) in
                        vm.scene = .loading
                        vm.title = "正在同步"
                        vm.message = "请稍等片刻"
                    }
                    a.startRotate()
                }
                loadingSuccessAfter2Seconds()
            }
            // MARK: 场景：同步成功（写法2）
            sec.addRow(title: "场景：同步成功（写法2）") {
                let a = Alert.push("loading") { (a) in
                    a.startRotate()
                }
                a.update { (vm) in
                    vm.scene = .loading
                    vm.title = "正在同步"
                    vm.message = "请稍等片刻"
                }
                loadingSuccessAfter2Seconds()
            }
            // MARK: 场景：正在同步（更新进度）
            sec.addRow(title: "场景：正在同步（更新进度）") {
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
                        for i in 0 ... 100 {
                            s.wait()
                            DispatchQueue.main.async {
                                Alert.find("progress", last: { (a) in
                                    a.update(progress: CGFloat(i)/100)
                                    print("\(CGFloat(i)/100)")
                                    if i == 100 {
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                            a.update { (vm) in
                                                vm.scene = .success
                                                vm.title = "同步成功"
                                                vm.message = nil
                                            }
                                        }
                                    }
                                })
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.03) {
                                    s.signal()
                                }
                            }
                        }
                    }
                }
            }
            // MARK: 场景：同步失败和重试
            sec.addRow(title: "场景：同步失败和重试（布局变化）") {
                Alert.push("loading", scene: .loading)
                func loading() {
                    Alert.find("loading") { (a) in
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
                    }
                }
                loading()
            }
            sec.footer = "两种写法1和写法2动画效果略微不同"
        }
        
        vm.addSection(title: "为了解决代码逻辑疏漏导致程序卡死、弹窗重叠等问题") { (sec) in
            // MARK: 极端场景：正在同步（超时未处理）
            sec.addRow(title: "极端场景：正在同步（超时未处理）", subtitle: "超时未处理的意外情况，弹窗可以手动关闭。（在config中配置所需时间）") {
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
            }
            
            
            // MARK: 极端场景：短时间内调用了多次同一个弹窗
            sec.addRow(title: "极端场景：短时间内调用了多次同一个弹窗", subtitle: "多次调用，页面弹窗应该是毫无变化的。（本例中，4秒内调用了6次）") {
                func loading(_ index: Int = 1) {
                    if Alert.find("loading").count == 0 {
                        Alert.push("loading", scene: .loading) { (a) in
                            a.update { (vm) in
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
            }
            // MARK: 极端场景：多个不同的弹窗重叠
            sec.addRow(title: "极端场景：多个不同的弹窗重叠", subtitle: "多个弹窗不得不重叠的时候，ProHUD的景深处理可以使其看起来舒服一些。") {
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
            }
            

            
        }

        vm.addSection(title: "") { (sec) in
            
            // MARK: 测试较长的标题和内容
            sec.addRow(title: "测试较长的标题和内容") {
                Alert.push() { (a) in
                    a.update { (vm) in
                        vm.scene = .confirm
                        vm.title = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                        vm.message = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                        vm.add(action: .default, title: "我知道了", handler: nil)
                    }
                }
            }
            // MARK: 测试特别长的标题和内容
            sec.addRow(title: "测试特别长的标题和内容", subtitle: "这种情况编码阶段就可以避免，所以没有做特别处理，请控制内容长度不要过长。") {
                Alert.push() { (a) in
                    a.update { (vm) in
                        vm.scene = .warning
                        vm.title = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                        vm.message = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                        vm.add(action: .default, title: "我知道了", handler: nil)
                    }
                }
            }
            // MARK: 只有标题
            sec.addRow(title: "只有标题") {
                Alert.push(scene: .default, title: "标题")
            }
            // MARK: 只有消息
            sec.addRow(title: "只有消息") {
                Alert.push(scene: .default, message: "这是消息")
            }
            // MARK: 只有消息
            sec.addRow(title: "既没有标题也没有消息") {
                Alert.push("a")
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
