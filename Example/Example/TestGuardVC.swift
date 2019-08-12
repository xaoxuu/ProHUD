//
//  TestGuardVC.swift
//  Example
//
//  Created by xaoxuu on 2019/8/12.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit
import ProHUD
import Inspire

class TestGuardVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var titles: [String] {
        return ["场景：删除菜单", "场景：升级至专业版", "场景：隐私协议页面"]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row == 0 {
            Guard.push() { (vm) in
                let vc = vm.vc
                vm.add(action: .destructive, title: "删除") { [weak vc] in
                    Alert.push(scene: .delete, title: "确认删除", message: "此操作不可撤销") { (vm) in
                        let vc = vm.vc
                        vm.add(action: .destructive, title: "删除") { [weak vc] in
                            vc?.pop()
                        }
                        vm.add(action: .cancel, title: "取消", handler: nil)
                    }
                    vc?.pop()
                }
                vm.add(action: .cancel, title: "取消", handler: nil)
            }
        } else if row == 1 {
            // 可以通过id来避免重复
            if Guard.get("pro").count == 0 {
                Guard.push() { (vm) in
                    let vc = vm.vc
                    vm.identifier = "pro"
                    vm.add(title: "升级至专业版")
                    vm.add(subTitle: "解锁功能")
                    vm.add(message: "功能1功能2...")
                    vm.add(subTitle: "价格")
                    vm.add(message: "只需一次性付费$2999即可永久享用。")
                    vm.add(action: .destructive, title: "购买") { [weak vc] in
                        Alert.push(scene: .confirm, title: "确认购买", message: "一旦购买拒不退款") { (vm) in
                            let vc = vm.vc
                            vm.add(action: .destructive, title: "购买") { [weak vc] in
                                vc?.update({ (vm) in
                                    vm.scene = .success
                                    vm.title = "购买成功"
                                    vm.message = "感谢您的支持"
                                    vm.remove(action: 1)
                                    vm.update(action: 0, style: .default, title: "我知道了") {
                                        vc?.pop()
                                    }
                                })
                            }
                            vm.add(action: .cancel, title: "取消", handler: nil)
                        }
                        vc?.pop()
                    }
                    vm.add(action: .cancel, title: "取消", handler: nil)
                }
            }
            
        } else if row == 2 {
            Guard.push() { (vm) in
                let vc = vm.vc
                vc?.isFullScreen = true
                let titleLabel = vm.add(title: "隐私协议")
                titleLabel.snp.makeConstraints { (mk) in
                    mk.height.equalTo(44)
                }
                let tv = UITextView()
                tv.backgroundColor = .white
                tv.isEditable = false
                vc?.textStack.addArrangedSubview(tv)
                tv.text = "这里可以插入一个webView"
                vm.add(message: "请认真阅读以上内容，当您阅读完毕并同意协议内容时点击接受按钮。")
                
                vm.add(action: .default, title: "接受") { [weak vc] in
                    vc?.pop()
                }
                
            }
            
        }
    }


}
