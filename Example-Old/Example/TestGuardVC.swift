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
import WebKit

class TestGuardVC: BaseListVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm.addSection(title: "简单使用") { (sec) in
            // MARK: 删除菜单
            sec.addRow(title: "示例：删除菜单") {
                Guard.push("del") { (vc) in
                    vc.update { (vm) in
                        vm.add(action: .destructive, title: "删除") { [weak vc] in
                            Alert.push(scene: .delete) { (vc) in
                                vc.update { (vm) in
                                    vm.add(action: .destructive, title: "删除") { [weak vc] in
                                        vc?.pop()
                                    }
                                    vm.add(action: .cancel, title: "取消", handler: nil)
                                }
                            }
                            vc?.pop()
                        }
                        vm.add(action: .cancel, title: "取消", handler: nil)
                    }
                }
            }
            
            // MARK: 升级至专业版
            sec.addRow(title: "示例：升级至专业版") {
                // 可以通过id来避免重复
                Guard.push("pro") { (vc) in
                    vc.identifier = "pro"
                    vc.update { (vm) in
                        vm.add(title: "升级至专业版")
                        vm.add(subTitle: "解锁功能")
                        vm.add(message: "功能1功能2...")
                        vm.add(subTitle: "价格")
                        vm.add(message: "只需一次性付费$2999即可永久享用。")
                        vm.add(message: "只需一次性付费$2999即可永久享用。")
                        vm.add(action: .destructive, title: "购买") { [weak vc] in
                            Alert.push(scene: .buy) { (vc) in
                                vc.identifier = "confirm"
                                vc.update { (vm) in
                                    vm.add(action: .destructive, title: "购买") { [weak vc] in
                                        vc?.update({ (vm) in
                                            vm.scene = .loading
                                            vm.title = "正在付款"
                                            vm.message = "请稍等片刻"
                                            vm.remove(action: 0, 1)
                                        })
                                        vc?.startRotate()
                                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                            vc?.update({ (vm) in
                                                vm.scene = .success
                                                vm.title = "购买成功"
                                                vm.message = "感谢您的支持"
                                                vm.add(action: .default, title: "我知道了") {
                                                    vc?.pop()
                                                }
                                            })
                                        }
                                    }
                                    vm.add(action: .cancel, title: "取消", handler: nil)
                                }
                            }
                            vc?.pop()
                        }
                        vm.add(action: .cancel, title: "取消", handler: nil)
                    }
                }
            }
            
        }
        
        vm.addSection(title: "添加自定义视图") { (sec) in
            // MARK: 选项切换
            sec.addRow(title: "示例：修改背景蒙版", subtitle: "很方便地添加自定义控件") {
                Guard.push() { (vc) in
                    if #available(iOS 13.0, *) {
                        let imgv = UIImageView(image: UIImage(systemName: "photo.fill.on.rectangle.fill"))
                        vc.textStack.addArrangedSubview(imgv)
                        imgv.contentMode = .scaleAspectFit
                        imgv.snp.makeConstraints { (mk) in
                            mk.height.equalTo(80)
                        }
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    // 添加标题
                    vc.vm.add(title: "背景蒙版")
                    // 添加标题
                    vc.vm.add(subTitle: "选择一种模糊效果")
                    // 添加控件
                    let seg = UISegmentedControl(items: ["extraLight", "light", "dark", "none"])
                    seg.selectedSegmentIndex = 1
                    vc.textStack.addArrangedSubview(seg)
                    seg.snp.makeConstraints { (mk) in
                        mk.height.equalTo(40)
                    }
                    // 添加标题
                    vc.vm.add(subTitle: "设置蒙版透明度")
                    // 添加控件
                    let slider = UISlider()
                    slider.minimumValue = 0
                    slider.maximumValue = 100
                    slider.value = 100
                    vc.textStack.addArrangedSubview(slider)
                    slider.snp.makeConstraints { (mk) in
                        mk.height.equalTo(40)
                    }
                    // 添加按钮
                    vc.vm.add(action: .default, title: "OK") { [weak vc] in
                        vc?.pop()
                    }
                }
            }
             
            // MARK: 隐私协议页面
            sec.addRow(title: "示例：弹出隐私协议页面", subtitle: "也可以完全控制整个页面") {
                Guard.push("license") { (vc) in
                    // 全屏
                    vc.isFullScreen = true
                    // 添加标题
                    vc.vm.add(title: "隐私协议").snp.makeConstraints { (mk) in
                        mk.height.equalTo(44)
                    }
                    // 添加网页
                    let web = WKWebView.init(frame: .zero)
                    web.layer.masksToBounds = true
                    web.layer.cornerRadius = ProHUD.shared.config.guard.buttonCornerRadius
                    web.scrollView.showsHorizontalScrollIndicator = false
                    if let url = URL(string: "https://xaoxuu.com/wiki/prohud/") {
                        web.load(URLRequest(url: url))
                    }
                    vc.textStack.addArrangedSubview(web)
                    web.snp.makeConstraints { (mk) in
                        mk.leading.trailing.equalToSuperview()
                    }
                    // 添加文本
                    vc.vm.add(message: "请认真阅读以上内容，当您阅读完毕并同意协议内容时点击接受按钮。")
                    // 添加按钮
                    vc.vm.add(action: .default, title: "接受") { [weak vc] in
                        vc?.pop()
                    }
                }
            }
        }
        
        vm.addSection(title: "对比效果") { (sec) in
            // MARK: 对比：原生的ActionSheet
            sec.addRow(title: "对比：原生的ActionSheet") {
                let ac = UIAlertController(title: "Title", message: "message", preferredStyle: .actionSheet)
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                ac.addAction(ok)
                ac.addAction(cancel)
                ac.popoverPresentationController?.sourceView =  self.view
                self.present(ac, animated: true, completion: nil)
            }
            // MARK: 对比：原生Present效果
            sec.addRow(title: "对比：原生Present效果") {
                let vc = UIViewController()
                vc.view.backgroundColor = .white
                vc.title = "ceshi"
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    

}
