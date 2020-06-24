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
        Alert.find("loading") { (a) in
            a.update { (vm) in
                vm.scene = .success
                vm.title = "同步成功"
                vm.message = nil
            }
        }
    }
}

func updateProgress(callback: @escaping (CGFloat) -> Void) {
    let s = DispatchSemaphore(value: 1)
    DispatchQueue.global().async {
        for i in 0 ... 100 {
            s.wait()
            DispatchQueue.main.async {
                callback(CGFloat(i)/100)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.03) {
                    s.signal()
                }
            }
        }
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
        
        vm.addSection(title: "常用示例") { (sec) in
            // MARK: 同步成功（写法1）
            sec.addRow(title: "正在同步（写法1）", subtitle: "创建的时候就布局好了。") {
                Alert.push("loading", scene: .sync)
                loadingSuccessAfter2Seconds()
            }
            // MARK: 同步成功（写法2）
            sec.addRow(title: "正在同步（写法2）", subtitle: "创建的时候没有布局完，发出去之后再更新布局。") {
                Alert.push("loading", scene: .sync2)
                loadingSuccessAfter2Seconds()
                // 先发出去再更新（添加文字）
                Alert.find("loading") { (vc) in
                    vc.update { (vm) in
                        vm.title = "正在同步"
                    }
                }
            }
            // MARK: 正在同步（更新进度）
            sec.addRow(title: "正在同步（有进度显示）") {
                Alert.push("progress", scene: .sync) { (a) in
                    a.update(progress: 0)
                    updateProgress { (pct) in
                        a.update(progress: pct)
                        if pct >= 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                a.update { (vm) in
                                    vm.scene = .success
                                    vm.title = "同步成功"
                                    vm.message = nil
                                }
                            }
                        }
                    }
                }
            }
            // MARK: 同步失败和重试
            sec.addRow(title: "同步失败和重试（布局变化）", subtitle: "添加、删除按钮使得窗口大小发生了变化。") {
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
            // MARK: 自定义要旋转的图片
            sec.addRow(title: "自定义要旋转的图片", subtitle: "添加了自定义视图，在更新的时候记得要视情况移除。") {
                Alert.push(scene: .privacy, title: "正在授权") { (vc) in
                    vc.identifier = "loading"
                    let imgv = UIImageView(image: UIImage(named: "prohud.rainbow.circle"))
                    vc.imageView.addSubview(imgv)
                    imgv.tag = 1
                    imgv.snp.makeConstraints { (mk) in
                        mk.center.equalToSuperview()
                        mk.width.height.equalTo(18)
                    }
                    vc.startRotate(imgv.layer, speed: 4)
                    vc.vm.duration = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    Alert.find("loading") { (vc) in
                        vc.imageView.viewWithTag(1)?.removeFromSuperview()
                        vc.update { (vm) in
                            vm.scene = .success
                            vm.title = "授权成功"
                            vm.duration = 1
                        }
                    }
                }
            }
            
            sec.footer = "写法1和写法2动画效果略微不同"
        }
        
        vm.addSection(title: "为了解决代码逻辑疏漏导致程序卡死、弹窗重叠等问题") { (sec) in
            // MARK: 极端场景：正在同步（超时未处理）
            sec.addRow(title: "极端场景：正在同步（超时未处理）", subtitle: "超时未处理的意外情况，弹窗可以手动关闭。（在config中配置所需时间）") {
                Alert.push(scene: .loading, title: "坐和放宽", message: "我们正在帮你搞定一切") { (a) in
                    a.identifier = "loading"
                    a.startRotate()
                    a.didForceQuit {
                        Toast.push(scene: .default, title: "点击了强制关闭", message: "您可以处理超时事件")
                    }
                }
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
                DispatchQueue.main.asyncAfter(deadline: .now()+4.5) {
                    Alert.push("loading", scene: .success) { (a) in
                        a.update { (vm) in
                            vm.scene = .success
                            vm.title = "测试结束"
                        }
                    }
                }
            }
            // MARK: 极端场景：多个不同的弹窗重叠
            sec.addRow(title: "极端场景：多个不同的弹窗重叠", subtitle: "多个弹窗不得不重叠的时候，ProHUD的景深处理可以使其看起来舒服一些。") {
                func a() {
                    Alert.push("a", scene: .default) { (a) in
                        a.update { (vm) in
                            vm.title = "Windows 10"
                            vm.message = "Windows 10不是為所有人設計,而是為每個人設計"
                            vm.icon = UIImage(named: "prohud.windmill")
                            vm.duration = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            b()
                        }
                    }
                }
                func b() {
                    Alert.push("b", scene: .warning) { (a) in
                        a.update { (vm) in
                            vm.title = "Windows 10"
                            vm.message = "不要说我们没有警告过你"
                            vm.duration = 0
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        c()
                    }
                }
                func c() {
                    Alert.push("c", scene: .message) { (a) in
                        a.update { (vm) in
                            vm.title = "Windows 10"
                            vm.message = "我们都有不顺利的时候"
                            vm.duration = 0
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        d()
                    }
                }
                func d() {
                    Alert.push("d", scene: .loading) { (a) in
                        a.update { (vm) in
                            vm.title = "Windows 10"
                            vm.message = "正在处理一些事情"
                            vm.duration = 0
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                        e()
                    }
                }
                func e() {
                    Alert.push("e", scene: .failure) { (a) in
                        a.update { (vm) in
                            vm.title = "更新失败"
                            vm.message = "*回到以前的版本"
                            vm.add(action: .default, title: "好的") {
                                Alert.pop("e")
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                                    Alert.pop("d")
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.6) {
                                    Alert.pop("c")
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.9) {
                                    Alert.pop("b")
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now()+1.2) {
                                    Alert.pop("a")
                                }
                            }
                        }
                    }
                }
                a()
                
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
                        vm.message = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来 的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                        vm.add(action: .default, title: "我知道了", handler: nil)
                    }
                }
            }
            // MARK: 只有标题
            sec.addRow(title: "只有标题") {
                Alert.push(scene: .message, title: "这是标题")
            }
            // MARK: 只有消息
            sec.addRow(title: "只有消息") {
                Alert.push(scene: .message, message: "这是消息")
            }
            // MARK: 只有消息
            sec.addRow(title: "既没有标题也没有消息") {
                Alert.push()
            }
        }
         
    }
    
    
}
