//
//  TestToastVC.swift
//  Example
//
//  Created by xaoxuu on 2019/8/12.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import ProHUD

// 模拟15秒后同步成功
func loadingSuccessAfter15Seconds() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
        Toast.find("loading") { (a) in
            a.update { (vm) in
                vm.scene = .success
                vm.title = "同步成功"
                vm.message = "啊哈哈哈哈哈哈哈哈"
            }
        }
    }
}


class TestToastVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        vm.addSection(title: "简单的例子") { (sec) in
            // MARK: 场景：正在加载（没有进度显示）
            sec.addRow(title: "场景：正在加载（没有进度显示）") {
                Toast.push(scene: .loading).startRotate()
                loadingSuccessAfter15Seconds()
            }
            // MARK: 场景：正在加载（有进度显示）
            sec.addRow(title: "场景：正在加载（有进度显示）") {
                if Toast.find("progress").count == 0 {
                    Toast.push("progress", scene: .loading) { (t) in
                        t.update { (vm) in
                            vm.title = "笑容正在加载"
                            vm.message = "这通常不会太久"
                        }
                        t.startRotate()
                        t.update(progress: 0)
                        updateProgress { (pct) in
                            t.update(progress: pct)
                            if pct >= 1 {
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                    t.update { (vm) in
                                        vm.scene = .success
                                        vm.icon = UIImage(named: "Feel1")
                                        vm.title = "加载成功"
                                        vm.message = "阿哈哈哈哈.jpg"
                                    }
                                }
                            }
                        }
                    }
                }
            }
            // MARK: 场景：同步成功
            sec.addRow(title: "场景：同步成功") {
                let t = Toast.push(scene: .success, title: "同步成功", message: "点击查看详情")
                t.didTapped { [weak self, weak t] in
                    self?.presentEmptyVC(title: "详情")
                    t?.pop()
                }
            }
            // MARK: 场景：同步失败
            sec.addRow(title: "场景：同步失败") {
                Toast.push(scene: .error, title: "同步失败", message: "请稍后重试。点击查看详情") { (vc) in
                    vc.update { (vm) in
                        vm.duration = 0
                    }
                    vc.didTapped { [weak self, weak vc] in
                        self?.presentEmptyVC(title: "这是错误详情")
                        vc?.pop()
                    }
                }
            }
            // MARK: 场景：设备电量过低
            sec.addRow(title: "场景：设备电量过低", subtitle: "这条消息正文部分显示多行") {
                Toast.push(scene: .warning, title: "设备电量过低", message: "请及时对设备进行充电，以免影响使用。\n为了您的续航，我们已经为您限制了设备的峰值性能。") { (vc) in
                    vc.vm.duration = 0
                }
            }
        }
        
        vm.addSection(title: "实用的例子") { (sec) in
            // MARK: 避免重复发布同一条信息
            sec.addRow(title: "避免重复发布同一条信息 (id=aaa)", subtitle: "为一个实例指定 identifier 可以避免重复出现。") {
                Toast.push("aaa") { (vc) in
                    vc.update { (vm) in
                        vm.scene = .warning
                        vm.message = "这则消息不会同时出现在多条横幅中。"
                        vm.duration = 0
                    }
                    vc.pulse()
                }
            }
            // MARK: 根据 identifier 查找并修改实例
            sec.addRow(title: "根据 identifier 查找并修改实例 (id=aaa)", subtitle: "在本例中，如果找不到就不进行处理。") {
                // 本例和上例唯一的区别是 push -> find
                Toast.find("aaa") { (t) in
                    t.update { (vm) in
                        vm.scene = .success
                        vm.title = "找到了哈哈"
                        vm.message = "根据 identifier 查找并修改实例"
                        vm.duration = 0
                    }
                    t.pulse()
                }
            }
            // MARK: 传入指定图标
            sec.addRow(title: "传入指定图标", subtitle: "虽然您对实例具有有完全的自由，但是更建议提前在场景中设置好对应的图片。") {
                Toast.push(scene: .default, title: "传入指定图标测试", message: "这是消息内容") { (vc) in
                    vc.update { (vm) in
                        if #available(iOS 13.0, *) {
                            vc.imageView.tintColor = .brown
                            vm.icon = UIImage(systemName: "icloud.and.arrow.down")
                        } else {
                            vm.icon = UIImage(named: "icloud.and.arrow.down")
                        }
                    }
                }
            }
            // MARK: 禁止手势移除
            sec.addRow(title: "禁止手势移除", subtitle: "常用于优先级低但是必须用户处理的事件。") {
                Toast.push(scene: .default, title: "禁止手势移除", message: "这条消息无法通过向上滑动移出屏幕。5秒后自动消失，每次拖拽都会刷新倒计时。") { (vc) in
                    vc.isRemovable = false
                    vc.update { (vm) in
                        vm.duration = 5
                    }
                }
            }
            // MARK: 组合使用示例
            sec.addRow(title: "和弹窗组合使用示例", subtitle: "如果有一个横幅消息需要用户做出选择怎么办？可以点击的时候弹出一个弹窗来。") {
                Toast.push(scene: .message, title: "好友邀请", message: "你收到一条好友邀请，点击查看详情。", duration: 10) { (vc) in
                    vc.identifier = "xxx"
                    vc.didTapped { [weak vc] in
                        vc?.pop()
                        Alert.push(scene: .confirm, title: "好友邀请", message: "用户xxx想要添加你为好友，是否同意？") { (vc) in
                            vc.update { (vm) in
                                vm.add(action: .default, title: "接受") { [weak vc] in
                                    vc?.pop()
                                    Toast.push(scene: .success, title: "好友添加成功", message: "这是消息内容")
                                }
                                vm.add(action: .cancel, title: "拒绝") {
                                    
                                }
                            }
                        }
                    }
                }
            }
            
            // MARK: 自定义要旋转的图片
            sec.addRow(title: "自定义要旋转的图片", subtitle: "添加了自定义视图，在更新的时候记得要视情况移除。") {
                Toast.push(scene: .privacy, title: "正在授权", message: "请稍等片刻") { (t) in
                    t.identifier = "loading"
                    let imgv = UIImageView(image: UIImage(named: "prohud.rainbow.circle"))
                    t.imageView.addSubview(imgv)
                    imgv.tag = 1
                    imgv.snp.makeConstraints { (mk) in
                        mk.center.equalToSuperview()
                        mk.width.height.equalTo(18)
                    }
                    t.startRotate(imgv.layer, speed: 4)
                    t.vm.duration = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    Toast.find("loading") { (a) in
                        a.imageView.viewWithTag(1)?.removeFromSuperview()
                        a.update { (vm) in
                            vm.scene = .success
                            vm.title = "授权成功"
                            vm.message = "啊哈哈哈哈哈哈哈哈"
                        }
                    }
                }
            }
            
        }

        
        vm.addSection(title: "极端场景") { (sec) in
            
            // MARK: 测试较长的标题和内容
            sec.addRow(title: "测试较长的标题和内容") {
                Toast.push() { (a) in
                    a.update { (vm) in
                        vm.title = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                        vm.message = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                       
                    }
                }
            }
            // MARK: 测试特别长的标题和内容
            sec.addRow(title: "测试特别长的标题和内容", subtitle: "可以在配置中设置 titleMaxLines/bodyMaxLines 来避免出现这种情况。") {
                Toast.push() { (a) in
                    a.update { (vm) in
                        vm.title = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                        vm.message = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                      
                    }
                }
            }
            // MARK: 只有标题
            sec.addRow(title: "只有标题部分的效果", subtitle: "这种情况请控制文字不要太少，否则不美观。") {
                Toast.push() { (a) in
                    a.update { (vm) in
                        vm.title = "坐和放宽，我们正在帮你搞定一切，这通常不会太久。"
                    }
                }
            }
            // MARK: 只有正文
            sec.addRow(title: "只有正文部分的效果", subtitle: "这种情况请控制文字不要太少，否则不美观。") {
                Toast.push() { (a) in
                    a.update { (vm) in
                        vm.message = "坐和放宽，我们正在帮你搞定一切，这通常不会太久。\n不幸的是，它花费的时间比通常要长。"
                    }
                }
            }
            
            
        }
        
        
    }
    
}
