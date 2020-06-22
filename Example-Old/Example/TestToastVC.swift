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
                "场景：正在同步（更新进度）",
                "场景：同步成功",
                "场景：同步失败",
                "场景：设备电量过低",
                "传入指定图标",
                "禁止手势移除",
                "组合使用示例",
                "避免重复发布同一条信息",
                "根据id查找并修改实例",
                "测试较长的标题和内容",
                "测试特别长的标题和内容",
                "测试只有title",
                "测试只有message",
                "自定义旋转的图片"]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row == 0 {
            Toast.push(scene: .loading, title: "正在同步", message: "请稍等片刻") { (vm) in
                vm.identifier = "loading"
            }.startRotate()
            simulateSync()
        } else if row == 1 {
            Toast.push("progress") { (t) in
                t.update { (vm) in
                    vm.scene = .loading
                    vm.title = "正在同步"
                    vm.message = "请稍等片刻"
                }
                t.startRotate()
                t.update(progress: 0)
                let s = DispatchSemaphore(value: 1)
                DispatchQueue.global().async {
                    for i in 0 ... 5 {
                        s.wait()
                        DispatchQueue.main.async {
                            Toast.find("progress", last: { (t) in
                                t.update(progress: CGFloat(i)/5)
                                print("\(CGFloat(i)/5)")
                                if i == 5 {
                                    t.update { (vm) in
                                        vm.scene = .success
                                        vm.title = "同步成功"
                                        vm.message = "xxx"
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
       } else if row == 2 {
            let t = Toast.push(scene: .success, title: "同步成功", message: "点击查看详情")
            t.didTapped { [weak self, weak t] in
                self?.presentEmptyVC(title: "详情")
                t?.pop()
            }
        } else if row == 3 {
            Toast.push(scene: .error, title: "同步失败", message: "请稍后重试。点击查看详情") { (vc) in
                vc.update { (vm) in
                    vm.duration = 0
                }
                vc.didTapped { [weak self, weak vc] in
                    self?.presentEmptyVC(title: "这是错误详情")
                    vc?.pop()
                }
            }
        } else if row == 4 {
            Toast.push(scene: .warning, title: "设备电量过低", message: "请及时对设备进行充电，以免影响使用。")
            
        } else if row == 5 {
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
        } else if row == 6 {
            Toast.push(scene: .default, title: "禁止手势移除", message: "这条消息无法通过向上滑动移出屏幕。5秒后自动消失，每次拖拽都会刷新倒计时。") { (vc) in
                vc.isRemovable = false
                vc.update { (vm) in
                    vm.duration = 5
                }
            }
        } else if row == 7 {
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
        } else if row == 8 {
            if let t = Toast.find("aaa").last {
                t.pulse()
                t.update() { (vm) in
                    vm.title = "已经存在了"
                }
            } else {
                Toast.push(title: "这是一条id为aaa的横幅", message: "避免重复发布同一条信息") { (t) in
                    t.identifier = "aaa"
                    t.update { (vm) in
                        vm.scene = .warning
                        vm.duration = 0
                    }
                }
            }
        } else if row == 9 {
            Toast.push("aaa") { (t) in
                t.update { (vm) in
                    vm.scene = .success
                    vm.title = "找到了哈哈"
                    vm.message = "根据id查找并修改实例"
                }
                t.pulse()
            }
        } else if row == 10 {
            Toast.push() { (a) in
                a.update { (vm) in
                    vm.title = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                    vm.message = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                   
                }
            }
        } else if row == 11 {
            Toast.push() { (a) in
                a.update { (vm) in
                    vm.title = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                    vm.message = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                  
                }
            }
        } else if row == 12 {
            Toast.push() { (a) in
                a.update { (vm) in
                    vm.scene = .warning
                    vm.title = "正在同步看到了你撒地"
                  
                }
            }
        } else if row == 13 {
            Toast.push() { (a) in
                a.update { (vm) in
                    vm.scene = .warning
                    vm.message = "正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过正在同步看到了你撒地方快乐撒的肌肤轮廓啊就是；来的跨省的人格人格离开那地方离开过"
                  
                }
            }
        } else if row == 14 {
            
            Toast.push(scene: .privacy, title: "正在授权", message: "请稍等片刻") { (t) in
                t.identifier = "loading"
                let imgv = UIImageView(image: UIImage(named: "prohud.rainbow.circle"))
                t.imageView.addSubview(imgv)
                imgv.snp.makeConstraints { (mk) in
                    mk.center.equalToSuperview()
                    mk.width.height.equalTo(18)
                }
                t.startRotate(imgv.layer, speed: 4)
            }
            simulateSync()
        }
    }
    
    func simulateSync() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            Toast.find("loading", last: { (t) in
                t.update { (vm) in
                    vm.scene = .success
                    vm.title = "同步成功"
                    vm.message = "啊哈哈哈哈哈哈哈哈"
                }
            })
        }
    }
    
}
