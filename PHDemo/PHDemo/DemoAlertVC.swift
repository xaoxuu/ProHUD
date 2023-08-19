//
//  DemoAlertVC.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit
import ProHUD

class DemoAlertVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        title = "Alert"
        header.detailLabel.text = "弹窗控件，用于强阻塞性交互，用户必须做出选择或者等待结果才能进入下一步，当多个实例出现时，会以堆叠的形式显示，新的实例会在覆盖旧的实例上层。"
        
        AlertConfiguration.global { config in
            config.reloadData { vc in
                if vc.identifier == "custom" {
                    return true
                }
                return false
            }
        }
        
        list.add(title: "纯文字") { section in
            section.add(title: "只有一句话") {
                 Alert(.message("只有一句话").duration(2))
            }
            section.add(title: "标题 + 正文") {
                let title = "这是标题"
                let message = "这是正文，文字支持自动换行，可设置最小宽度和最大宽度。这个弹窗将会持续4秒。"
                Alert { alert in
                    alert.vm = .title(title).message(message).duration(4)
                }
            }
        }
        
        list.add(title: "图文弹窗") { section in
            section.add(title: "纯图标") {
                Alert(.loading(3))
            }
            section.add(title: "图标 + 文字") {
                Alert(.loading.message("正在加载")) { alert in
                    updateProgress(in: 4) { percent in
                        alert.update(progress: percent)
                    } completion: {
                        alert.update { alert in
                            alert.vm = .success.message("加载成功")
                            alert.add(action: "OK")
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                            alert.pop()
                        }
                    }
                }
            }
            section.add(title: "图标 + 标题 + 正文") {
                Alert(.error) { alert in
                    alert.vm?.title = "加载失败"
                    alert.vm?.message = "请稍后重试"
                    alert.vm?.duration = 3
                }
            }
        }
        list.add(title: "文字 + 按钮") { section in
            section.add(title: "只有一小段文字 + 无背景色按钮") {
                Alert { alert in
                    alert.config.cardMinWidth = 270
                    alert.config.cardEdgeInsets = .init(top: 0, left: 0, bottom: 16, right: 0)
                    alert.config.textEdgeInsets = .init(top: 30, left: 32, bottom: 30, right: 32)
                    alert.config.cardCornerRadius = 12
                    alert.config.customTextLabel { label in
                        label.font = .systemFont(ofSize: 15)
                    }
                    alert.config.customButton { button in
                        button.titleLabel?.font = .systemFont(ofSize: 15)
                    }
                    alert.title = "你正在使用移动网络观看"
                    alert.onViewDidLoad { vc in
                        guard let alert = vc as? AlertTarget else {
                            return
                        }
                        alert.add(contentSpacing: 30)
                        let v = UIView()
                        v.backgroundColor = UIColor("#f2f2f2")
                        alert.add(subview: v).snp.makeConstraints { make in
                            make.left.right.equalToSuperview()
                            make.height.equalTo(1)
                        }
                        alert.add(contentSpacing: 16)
                        alert.add(action: "确定", style: .plain(textColor: UIColor("#14cccc")))
                        
                    }
                }
            }
            section.add(title: "只有一段文字 + 无背景色按钮") {
                Alert { alert in
                    alert.config.cardMinWidth = 270
                    alert.config.cardEdgeInsets = .init(top: 0, left: 0, bottom: 16, right: 0)
                    alert.config.textEdgeInsets = .init(top: 30, left: 32, bottom: 30, right: 32)
                    alert.config.cardCornerRadius = 12
                    alert.config.customTextLabel { label in
                        label.font = .systemFont(ofSize: 15)
                    }
                    alert.config.customButton { button in
                        button.titleLabel?.font = .systemFont(ofSize: 15)
                    }
                    alert.title = "为了维护社区氛围，上麦用户需进行主播认证"
                    alert.onViewDidLoad { vc in
                        guard let alert = vc as? AlertTarget else {
                            return
                        }
                        alert.add(contentSpacing: 30)
                        let v = UIView()
                        v.backgroundColor = UIColor("#f2f2f2")
                        alert.add(subview: v).snp.makeConstraints { make in
                            make.left.right.equalToSuperview()
                            make.height.equalTo(1)
                        }
                        alert.add(contentSpacing: 16)
                        alert.add(action: "取消", style: .plain(textColor: UIColor("#939999")))
                        alert.add(action: "确定", style: .plain(textColor: UIColor("#14cccc")))
                    }
                }
            }
            section.add(title: "只有一段文字 + 3个无背景色按钮") {
                Alert { alert in
                    alert.config.cardMinWidth = 270
                    alert.config.cardEdgeInsets = .zero
                    alert.config.textEdgeInsets = .init(top: 30, left: 32, bottom: 30, right: 32)
                    alert.config.cardCornerRadius = 12
                    alert.config.customTextLabel { label in
                        label.font = .systemFont(ofSize: 15)
                    }
                    alert.config.customButton { button in
                        button.titleLabel?.font = .systemFont(ofSize: 15)
                    }
                    alert.title = "本次消费需要你支付999软妹豆，确认支付吗？"
                    alert.config.customActionStack { stack in
                        stack.spacing = 0
                        stack.axis = .vertical // 竖排按钮
                    }
                    alert.onViewDidLoad { vc in
                        guard let alert = vc as? AlertTarget else {
                            return
                        }
                        func createLine() -> UIView {
                            let v = UIView()
                            v.backgroundColor = UIColor("#f2f2f2")
                            return v
                        }
                        let btn1 = alert.add(action: "确认，以后不需要再提醒", style: .plain(textColor: UIColor("#14cccc")))
                        btn1.contentEdgeInsets.top = 16 + 1 // 间距 + 线的高度
                        btn1.contentEdgeInsets.bottom = 16
                        let line1 = createLine()
                        btn1.insertSubview(line1, at: 0)
                        line1.snp.makeConstraints { make in
                            make.top.left.right.equalToSuperview()
                            make.height.equalTo(1)
                        }
                        
                        let btn2 = alert.add(action: "确认，每次消费前提醒", style: .plain(textColor: UIColor("#14cccc")))
                        let line2 = createLine()
                        btn2.insertSubview(line2, at: 0)
                        line2.snp.makeConstraints { make in
                            make.top.left.right.equalToSuperview()
                            make.height.equalTo(1)
                        }
                        
                        let btn3 = alert.add(action: "取消", style: .plain(textColor: UIColor("#939999")))
                        let line3 = createLine()
                        btn3.insertSubview(line3, at: 0)
                        line3.snp.makeConstraints { make in
                            make.top.left.right.equalToSuperview()
                            make.height.equalTo(1)
                        }
                        
                    }
                }
            }
            
            section.add(title: "只有一段文字 + 按钮") {
                Alert { alert in
                    alert.title = "只有一段文字"
                    alert.add(action: "取消", style: .gray)
                    alert.add(action: "默认按钮")
                }
            }
            section.add(title: "标题 + 正文 + 按钮") {
                Alert { alert in
                    alert.vm = .title("标题").message("这是一段正文，长度超出最大宽度时会自动换行")
                    alert.add(action: "取消", style: .gray)
                    alert.add(action: "删除", style: .destructive) { alert in
                        // 自定义了按钮事件之后，需要手动pop弹窗
                        alert.pop()
                    }
                }
            }
        }
        list.add(title: "图标 + 文字 + 按钮") { section in
            section.add(title: "操作成功") {
                Alert(.success(3).title("操作成功").message("这条消息将在3s后消失"))
            }
            section.add(title: "操作失败") {
                Alert { alert in
                    alert.vm = .error.title("操作失败").message("请稍后重试")
                    alert.add(action: "取消", style: .gray)
                    alert.add(action: "重试")
                }
            }
            section.add(title: "警告") {
                Alert(.warning.message("电量不足，请立即充电")) { alert in
                    let btn = alert.add(action: "我知道了", style: .filled(color: UIColor.systemYellow))
                    btn.setTitleColor(.black, for: .normal)
                }
            }
            section.add(title: "确认选择") {
                Alert(.confirm.title("请选择颜色")) { alert in
                    alert.add(action: "红色", style: .light(color: .systemRed))
                    alert.add(action: "蓝色", style: .light(color: .systemBlue))
                }
            }
            section.add(title: "确认删除") {
                Alert(.delete) { alert in
                    alert.vm?.title = "确认删除"
                    alert.vm?.message = "此操作无法撤销"
                    alert.add(action: "取消", style: .gray)
                    alert.add(action: "删除", style: .destructive)
                }
            }
        }
        list.add(title: "控件管理") { section in
            section.add(title: "按钮增删改查") {
                Alert(.note) { alert in
                    alert.vm?.message = "可以动态增加、删除按钮"
                    alert.add(action: "在底部增加按钮", style: .filled(color: .systemGreen)) { alert in
                        alert.add(action: "哈哈1", identifier: "haha1")
                    }
                    alert.add(action: "在当前按钮下方增加", style: .filled(color: .systemIndigo), identifier: "add") { alert in
                        alert.insert(action: .init(identifier: "haha2", style: .light(color: .systemOrange), title: "哈哈2", handler: nil), after: "add")
                    }
                    alert.add(action: "修改当前按钮文字", identifier: "edit") { alert in
                        alert.update(action: "已修改", for: "edit")
                    }
                    alert.add(action: "删除「哈哈1」", style: .destructive) { alert in
                        alert.remove(actions: .identifiers("haha1"))
                    }
                    alert.add(action: "删除「哈哈1」和「哈哈2」", style: .destructive) { alert in
                        alert.remove(actions: .identifiers("haha1", "haha2"))
                    }
                    alert.add(action: "删除全部按钮", style: .destructive) { alert in
                        alert.remove(actions: .all)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            alert.pop()
                        }
                    }
                    alert.add(action: "取消", style: .gray)
                }
            }
            section.add(title: "更新文字") {
                Alert(.note.message("可以动态增加、删除、更新文字")) { alert in
                    alert.add(action: "增加标题") { alert in
                        alert.vm?.title = "这是标题"
                        alert.reloadTextStack()
                    }
                    alert.add(action: "增加正文") { alert in
                        alert.vm?.message = "可以动态增加、删除、更新文字"
                        alert.reloadTextStack()
                    }
                    alert.add(action: "删除标题", style: .destructive) { alert in
                        alert.vm?.title = nil
                        alert.reloadTextStack()
                    }
                    alert.add(action: "删除正文", style: .destructive) { alert in
                        alert.vm?.message = nil
                        alert.reloadTextStack()
                    }
                    alert.add(action: "取消", style: .gray)
                }
            }
            section.add(title: "在弹出过程中增加元素") {
                Alert(.loading.title("在弹出过程中增加元素")) { alert in
                    alert.add(action: "OK", style: .gray)
                    alert.onViewWillAppear { vc in
                        guard let alert = vc as? AlertTarget else {
                            return
                        }
                        alert.vm?.message = "这是一段后增加的文字\n动画效果会有细微差别"
                        alert.reloadTextStack()
                    }
                }
            }
        }
        list.add(title: "实例管理") { section in
            section.add(title: "多层级弹窗") {
                func f(i: Int) {
                    Alert { alert in
                        alert.vm = .title("第\(i)次弹").message("每次都是一个新的实例覆盖在上一个弹窗上面，而背景不会叠加变深。")
                        alert.add(action: "取消", style: .gray)
                        alert.add(action: "增加一个") { alert in
                            f(i: i + 1)
                        }
                    }
                }
                f(i: 1)
            }
            section.add(title: "弹出loading，如果已经存在就更新") {
                func f(i: Int) {
                    Alert.lazyPush(identifier: "haha") { alert in
                        if i < 2 {
                            alert.vm = .loading.title("第\(i)次弹")
                            let btn = alert.add(action: "请稍等", identifier: "btn")
                            btn.isEnabled = false
                        } else {
                            alert.update(progress: 1)
                            alert.vm = .success.title("第\(i)次弹").message("只更新内容")
                            alert.reloadTextStack()
                            alert.update(action: "完成", style: .filled(color: .systemGreen), for: "btn")
                            alert.button(for: "btn")?.isEnabled = true
                        }
                    }
                }
                f(i: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    f(i: 2)
                }
            }
        }
        list.add(title: "放在特定页面") { [weak self] section in
            section.add(title: "放在一个VC中") {
                let vc = UIViewController()
                vc.title = "页面"
                vc.view.backgroundColor = .systemYellow
                let alert = AlertTarget(.loading.title("正在加载").message("这个弹窗被放在指定容器中"))
                alert.add(action: "返回上一页") { alert in
                    vc.dismiss(animated: true)
                }
                alert.config.enableShadow = false
                self?.present(vc, animated: true)
                vc.addChild(alert)
                vc.view.addSubview(alert.view)
                alert.view.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
        list.add(title: "自定义视图") { section in
            section.add(title: "自定义控件") {
                Alert { alert in
                    alert.title = "自定义控件"
                    // 图片
                    let imgv = UIImageView(image: UIImage(named: "landscape"))
                    imgv.contentMode = .scaleAspectFill
                    imgv.clipsToBounds = true
                    imgv.layer.cornerRadiusWithContinuous = 12
                    alert.add(action: imgv).snp.makeConstraints { make in
                        make.height.equalTo(120)
                    }
                    // seg
                    let seg = UISegmentedControl(items: ["开发", "测试", "预发", "生产"])
                    seg.selectedSegmentIndex = 0
                    alert.add(action: seg).snp.makeConstraints { make in
                        make.height.equalTo(40)
                        make.width.equalTo(400)
                    }
                    // slider
                    let slider = UISlider()
                    slider.minimumValue = 0
                    slider.maximumValue = 100
                    slider.value = 50
                    alert.add(action: slider)
                    alert.add(actionSpacing: 24)
                    alert.add(action: "取消", style: .gray)
                }
            }
            
            section.add(title: "圆角半径") {
                Alert { alert in
                    alert.title = "圆角半径"
                    let s1 = UISlider()
                    s1.minimumValue = 0
                    s1.maximumValue = 40
                    s1.value = Float(alert.config.cardCornerRadius ?? 16)
                    alert.add(action: s1).snp.makeConstraints { make in
                        make.height.equalTo(50)
                    }
                    if #available(iOS 14.0, *) {
                        s1.addAction(.init(handler: { [unowned s1] act in
                            alert.config.cardCornerRadius = CGFloat(s1.value)
                            alert.contentView.layer.cornerRadiusWithContinuous = alert.config.cardCornerRadius ?? 16
                        }), for: .valueChanged)
                    } else {
                        // Fallback on earlier versions
                    }
                    alert.add(contentSpacing: 24)
                    alert.add(action: "OK", style: .gray)
                }
            }
            
            section.add(title: "完全自定义容器") {
                Alert { alert in
                    alert.identifier = "custom"
                    alert.contentView.backgroundColor = .systemYellow
                    alert.view.addSubview(alert.contentView)
                    alert.contentView.layer.cornerRadiusWithContinuous = 32
                    alert.contentView.snp.makeConstraints { make in
                        make.width.equalTo(UIScreen.main.bounds.width - 100)
                        make.height.equalTo(UIScreen.main.bounds.height - 200)
                        make.center.equalToSuperview()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        alert.pop()
                    }
                }
            }
        }
    }

}
