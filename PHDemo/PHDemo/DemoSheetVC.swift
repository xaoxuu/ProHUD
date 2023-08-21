//
//  DemoSheetVC.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/3.
//

import UIKit
import ProHUD

class DemoSheetVC: ListVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Sheet"
        header.detailLabel.text = "操作表控件，用于弱阻塞性交互。显示区域为从屏幕底部向上弹出的新图层，可以放置丰富的内容，自由度较高。"
        
        list.add(title: "默认布局") { section in
            section.add(title: "标题 + 正文 + 按钮") {
                Sheet { sheet in
                    sheet.add(title: "ProHUD")
                    sheet.add(subTitle: "什么是操作表控件")
                    sheet.add(message: "操作表控件，用于弱阻塞性交互。显示区域为从屏幕底部向上弹出的新图层，可以放置丰富的内容，自由度较高。")
                    sheet.add(spacing: 24)
                    sheet.add(action: "确认", style: .destructive) { sheet in
                        Alert(.confirm) { alert in
                            alert.title = "处理点击事件"
                            alert.add(action: "我知道了")
                        }
                    }
                    sheet.add(action: "取消", style: .gray)
                }
            }
            section.add(title: "放置自定义控件") {
                Sheet { sheet in
                    sheet.add(title: "ProHUD")
                    // 图片
                    let imgv = UIImageView(image: UIImage(named: "landscape"))
                    imgv.contentMode = .scaleAspectFill
                    imgv.clipsToBounds = true
                    imgv.layer.cornerRadiusWithContinuous = 16
                    sheet.add(subview: imgv).snp.makeConstraints { make in
                        make.height.equalTo(200)
                    }
                    // seg
                    let seg = UISegmentedControl(items: ["开发", "测试", "预发", "生产"])
                    seg.selectedSegmentIndex = 0
                    sheet.add(subview: seg).snp.makeConstraints { make in
                        make.height.equalTo(40)
                        make.width.equalTo(400)
                    }
                    // slider
                    let slider = UISlider()
                    slider.minimumValue = 0
                    slider.maximumValue = 100
                    slider.value = 50
                    sheet.add(subview: slider).snp.makeConstraints { make in
                        make.height.equalTo(50)
                    }
                    
                    sheet.add(spacing: 50)
                }
            }
            
        }
        
        list.add(title: "事件管理") { section in
            section.add(title: "拦截背景点击事件") {
                Sheet { sheet in
                    sheet.add(title: "ProHUD")
                    sheet.add(message: "点击背景将不会dismiss，必须在下方做出选择才能关掉")
                    sheet.add(spacing: 24)
                    sheet.add(action: "确认")
                    sheet.add(action: "取消", style: .gray)
                    sheet.onTappedBackground { sheet in
                        Toast(
                            .error
                            .lazyIdentifier()
                            .title("点击了背景")
                            .message("点击背景将不会dismiss，必须在下方做出选择才能关掉")
                            .duration(2)
                        )
                    }
                }
            }
        }
        
        list.add(title: "自定义样式") { section in
            section.add(title: "堆叠样式") {
                Sheet { sheet in
                    sheet.config.stackDepthEffect = true
                    sheet.config.windowEdgeInset = 0
                    sheet.add(title: "ProHUD")
                    sheet.add(subTitle: "堆叠样式")
                    sheet.add(message: "这个效果目前有个小BUG，切后台之后显示会有点问题，如果有解决方案请麻烦去社区反馈一下，谢谢～")
                    sheet.add(spacing: 24)
                    sheet.add(action: "去反馈", style: .destructive) { sheet in
                        guard let url = URL(string: "https://github.com/xaoxuu/ProHUD") else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url)
                        }
                    }
                    sheet.add(action: "取消", style: .gray)
                }
            }
            section.add(title: "圆角半径 & 屏幕边距") {
                Sheet { sheet in
                    sheet.add(title: "圆角半径 & 屏幕边距")
                    
                    sheet.add(subTitle: "圆角半径")
                    let s1 = UISlider()
                    s1.minimumValue = 0
                    s1.maximumValue = 40
                    s1.value = Float(sheet.config.cardCornerRadius ?? 40)
                    sheet.add(subview: s1).snp.makeConstraints { make in
                        make.height.equalTo(50)
                    }
                    if #available(iOS 14.0, *) {
                        s1.addAction(.init(handler: { [unowned s1] act in
                            sheet.config.cardCornerRadius = CGFloat(s1.value)
                            sheet.contentView.layer.cornerRadiusWithContinuous = sheet.config.cardCornerRadius ?? 40
                        }), for: .valueChanged)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    sheet.add(subTitle: "屏幕边距")
                    let s2 = UISlider()
                    s2.minimumValue = 0
                    s2.maximumValue = 40
                    s2.value = Float(sheet.config.windowEdgeInset)
                    sheet.add(subview: s2).snp.makeConstraints { make in
                        make.height.equalTo(50)
                    }
                    if #available(iOS 14.0, *) {
                        s2.addAction(.init(handler: { [unowned s2] act in
                            sheet.config.windowEdgeInset = CGFloat(s2.value)
                            sheet.reloadData()
                        }), for: .valueChanged)
                    } else {
                        // Fallback on earlier versions
                    }
                    
                    sheet.add(spacing: 24)
                    sheet.add(action: "OK", style: .gray)
                }
            }
            
            section.add(title: "卡片背景样式") {
                Sheet { sheet in
                    sheet.title = "卡片背景样式"
                    sheet.add(action: "白色") { sheet in
                        sheet.contentMaskView.backgroundColor = .white
                        sheet.contentMaskView.effect = .none
                    }
                    sheet.add(action: "橙色") { sheet in
                        sheet.contentMaskView.backgroundColor = .systemOrange
                        sheet.contentMaskView.effect = .none
                    }
                    sheet.add(action: "毛玻璃 light") { sheet in
                        sheet.contentMaskView.backgroundColor = .clear
                        sheet.contentMaskView.effect = UIBlurEffect(style: .light)
                    }
                    sheet.add(action: "毛玻璃 dark") { sheet in
                        sheet.contentMaskView.backgroundColor = .clear
                        sheet.contentMaskView.effect = UIBlurEffect(style: .dark)
                    }
                }
            }
            
            
            section.add(title: "自定义卡片背景") {
                Sheet { sheet in
                    sheet.add(title: "ProHUD")
                    sheet.add(spacing: 24)
                    sheet.add(action: "OK")
                    sheet.config.contentViewMask { mask in
                        mask.effect = .none
                        mask.backgroundColor = .clear
                    }
                    sheet.onViewWillAppear { vc in
                        guard let sheet = vc as? SheetTarget else { return }
                        let imgv = UIImageView(image: UIImage(named: "landscape"))
                        imgv.contentMode = .scaleAspectFill
                        imgv.clipsToBounds = true
                        imgv.layer.cornerRadiusWithContinuous = 16
                        sheet.contentView.insertSubview(imgv, at: 0)
                        imgv.snp.makeConstraints { make in
                            make.edges.equalToSuperview()
                            make.height.equalTo(300)
                        }
                    }
                }
            }
            
            
            section.add(title: "透明背景") {
                Sheet { sheet in
                    sheet.backgroundView.backgroundColor = .clear
                    sheet.add(title: "ProHUD")
                    sheet.add(spacing: 24)
                    sheet.add(action: "OK")
                }
            }
            
            section.add(title: "自定义布局") {
                Sheet { sheet in
                    let imgv = UIImageView(image: UIImage(named: "landscape"))
                    imgv.contentMode = .scaleAspectFill
                    imgv.clipsToBounds = true
                    imgv.layer.cornerRadiusWithContinuous = 16
                    sheet.set(customView: imgv).snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                        make.height.equalTo(300)
                    }
                }
            }
            
            section.add(title: "全屏Sheet") {
                Sheet { sheet in
                    sheet.config.isFullScreen = true
                    sheet.add(title: "ProHUD")
                    sheet.add(action: "OK")
                }
            }
            
        }
        
    }

}

