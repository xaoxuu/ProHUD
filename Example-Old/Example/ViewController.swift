//
//  ViewController.swift
//  Example
//
//  Created by xaoxuu on 2018/6/15.
//  Copyright © 2018 Titan Studio. All rights reserved.
//

import UIKit
import ProHUD
import SnapKit

class ViewController: BaseListVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "\(Bundle.main.infoDictionary?["CFBundleName"] ?? "ProHUD")"

        vm.addSection(title: "测试项目") { (sec) in
            sec.addRow(title: "Toast", subtitle: "横幅控件，支持图片、标题和正文。\n不支持添加按钮，但可以接受一个点击事件。") {
                let vc = TestToastVC()
                vc.title = "Toast"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            sec.addRow(title: "Alert", subtitle: "弹窗控件，支持图片、标题、正文和按钮。\n按钮不设置事件回调时可以自动pop。") {
                let vc = TestAlertVC()
                vc.title = "Alert"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            sec.addRow(title: "Guard", subtitle: "操作表控件，原生支持标题、副标题、正文和按钮，也可以添加任意视图。") {
                let vc = TestGuardVC()
                vc.title = "Guard"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
        
        vm.addSection(title: "小提示") { (sec) in
            sec.addRow(title: "所有控件都是ViewController", subtitle: "可以监听进入、离开移除事件。\n推入、推出统一为 push/pop 操作。\n所有控件都可以在配置中完全自定义布局及样式。\n通过 identifier 来获取实例，方便进行多实例管理") {
            }
            sec.addRow(title: "基于场景的应用", subtitle: "一个场景就是一套模板，原生提供了一些常用场景，您可以覆写，也可以新建场景。\n在场景中可以指定持续时间、标题、图标、正文等数据。") {
            }
            sec.addRow(title: "样式与逻辑分离", subtitle: "您可以在场景中指定一些规则，也可以在配置中完全自定义布局样式。\n在使用的时候呢，只需要确定数据即可。") {
            }
            sec.addRow(title: "Loading图片旋转", subtitle: "可以通过调用 .startRotate() 并可传入适当参数来旋转，也可以自定义场景\n如果场景的 identifier 包含 .rotate 则会自动旋转图片") {
            }
            sec.addRow(title: "按钮默认行为", subtitle: "为了灵活性，default 和 destructive 按钮默认不会对实例进行 pop 操作，但是如果它们没有实现回调事件，则会自动 pop。cancel 按钮永远会自动 pop。") {
            }
            sec.addRow(title: "持续时间", subtitle: "设置 duration 来指定持续时间，设置为 0 可以永久持续。\n原生提供的 loading 场景持续时间为永久。\n如果弹窗添加了按钮，则持续时间会自动变成永久，除非手动设置。") {
            }
        }
        
    }
    
}

