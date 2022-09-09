//
//  Configuration.swift
//  
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

public class Configuration: NSObject {
    
    /// 是否允许log输出
    public static var enablePrint = true

    /// 根控制器，默认可以自动获取，如果获取失败请主动设置
    public var rootViewController: UIViewController?

    /// iOS13必须设置此值，默认可以自动获取，如果获取失败请主动设置
    @available(iOS 13.0, *)
    private static var sharedWindowScene: UIWindowScene?

    /// iOS13必须设置此值，默认可以自动获取，如果获取失败请主动设置
    @available(iOS 13.0, *)
    public var windowScene: UIWindowScene? {
        set {
            Self.sharedWindowScene = newValue
        }
        get {
            return Self.sharedWindowScene
        }
    }
    
    public lazy var dynamicBackgroundColor: UIColor = {
        if #available(iOS 13.0, *) {
            let color = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .init(white: 0.15, alpha: 1)
                } else {
                    return .init(white: 1, alpha: 1)
                }
            }
            return color
            } else {
            // Fallback on earlier versions
        }
        return .init(white: 1, alpha: 1)
    }()
    
    /// 动态颜色（适配iOS13）
    public lazy var dynamicTextColor: UIColor = {
        if #available(iOS 13.0, *) {
            let color = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return .init(white: 1, alpha: 1)
                } else {
                    return .init(white: 0.1, alpha: 1)
                }
            }
            return color
        } else {
            // Fallback on earlier versions
        }
        return .init(white: 0.1, alpha: 1)
    }()
    
    /// 主标签文本颜色
    public lazy var primaryLabelColor: UIColor = {
        dynamicTextColor.withAlphaComponent(0.9)
    }()

    /// 次级标签文本颜色
    public lazy var secondaryLabelColor: UIColor = {
        return dynamicTextColor.withAlphaComponent(0.8)
    }()
    
    
    // MARK: 卡片样式
    /// 最大宽度（用于优化横屏或者iPad显示）
    public var cardMaxWidth: CGFloat?
    var cardMaxWidthByDefault: CGFloat {
        cardMaxWidth ?? .minimum(UIScreen.main.bounds.width * 0.72, 400)
    }
    
    public var cardMaxHeight: CGFloat?
    var cardMaxHeightByDefault: CGFloat {
        cardMaxHeight ?? (UIScreen.main.bounds.height - 100)
    }
    /// 最小宽度
    public var cardMinWidth = CGFloat(32)
    /// 最小高度
    public var cardMinHeight = CGFloat(32)
    
    /// 卡片圆角
    public var cardCornerRadius: CGFloat?
    var cardCornerRadiusByDefault: CGFloat { cardCornerRadius ?? 16 }
    
    /// 余量：元素与元素之间的距离
    public var margin = CGFloat(8)
    /// 填充：元素内部控件距离元素边界的距离
    public var padding = CGFloat(16)
    
    /// 颜色
    public var tintColor: UIColor?
    
    // MARK: 图标样式
    /// 图标尺寸
    public var iconSize = CGSize(width: 48, height: 48)
    
    // MARK: 文本样式
    /// 标题字体
    public var titleFont: UIFont?
    var titleFontByDefault: UIFont { titleFont ?? .boldSystemFont(ofSize: 20) }
    
    /// 标题最多行数
    public var titleMaxLines = Int(5)
    
    /// 加粗字体（如果只有标题或者只有正文，则显示这种字体）
    public var boldTextFont: UIFont?
    var boldTextFontByDefault: UIFont { boldTextFont ?? .boldSystemFont(ofSize: 18) }
    
    /// 正文字体
    public var bodyFont: UIFont?
    var bodyFontByDefault: UIFont { bodyFont ?? .systemFont(ofSize: 17) }
    
    /// 正文最多行数
    public var bodyMaxLines = Int(20)
    
    // MARK: 按钮样式
    /// 按钮字体
    public var buttonFont: UIFont?
    var buttonFontByDefault: UIFont { buttonFont ?? .boldSystemFont(ofSize: 15) }
    
    /// 按钮圆角
    public var buttonCornerRadius: CGFloat?
    var buttonCornerRadiusByDefault: CGFloat { buttonCornerRadius ?? 8 }
    
    // MARK: 动画
    
    public var animateDurationForBuildIn: TimeInterval?
    var animateDurationForBuildInByDefault: CGFloat { animateDurationForBuildIn ?? 0.5 }
    
    public var animateDurationForBuildOut: TimeInterval?
    var animateDurationForBuildOutByDefault: CGFloat { animateDurationForBuildOut ?? 0.38 }
    
    public var animateDurationForReload: TimeInterval?
    var animateDurationForReloadByDefault: CGFloat { animateDurationForReload ?? 0.8 }
    
    
    // MARK: 自定义
    
    var customReloadData: ((_ vc: Controller) -> Bool)?
    
    /// 自定义刷新规则（ ⚠️ 自定义此函数之后，整个容器将不再走默认布局规则，可实现完全自定义）
    /// - Parameter callback: 自定义刷新规则代码
    public func reloadData(_ callback: @escaping (_ vc: Controller) -> Bool) {
        customReloadData = callback
    }
    
    /// 自定义内容卡片蒙版
    var customContentViewMask: ((_ mask: UIVisualEffectView) -> Void)?

    /// 设置内容卡片蒙版
    /// - Parameter callback: 自定义内容卡片蒙版代码
    public func contentViewMask(_ callback: @escaping (_ mask: UIVisualEffectView) -> Void) {
        customContentViewMask = callback
    }

}

