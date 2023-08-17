//
//  File.swift
//  PHDemo
//
//  Created by xaoxuu on 2022/9/9.
//

import UIKit
import ProHUD

public extension BaseViewModel {
//    static var plain: ViewModel {
//        ViewModel()
//    }
//    static var note: ViewModel {
//        ViewModel(icon: UIImage(named: "prohud.note"))
//    }
    // MARK: note
    static var note: Self {
        .init()
        .icon(.init(named: "demo.note"))
    }
    static func note(_ seconds: TimeInterval) -> Self {
        .init()
        .icon(.init(named: "demo.note"))
        .duration(seconds)
    }
    static var msg: Self {
        .init()
        .icon(.init(named: "demo.message"))
    }
    static func msg(_ seconds: TimeInterval) -> Self {
        .init()
        .icon(.init(named: "demo.message"))
        .duration(seconds)
    }
    static var delete: Self {
        .init()
        .icon(.init(named: "demo.trash"))
    }
    // MARK: confirm
    static var confirm: Self {
        .init()
        .icon(.init(named: "demo.questionmark"))
    }
    static func confirm(_ seconds: TimeInterval) -> Self {
        .init()
        .icon(.init(named: "demo.questionmark"))
        .duration(seconds)
    }
    
//    static func loading(_ seconds: TimeInterval) -> ViewModel {
//        let obj = ViewModel(icon: UIImage(named: "prohud.rainbow.circle"), duration: seconds)
//        obj.rotation = .init(repeatCount: .infinity)
//        return obj
//    }
}


extension CALayer {
    var cornerRadiusWithContinuous: CGFloat {
        set {
            cornerRadius = newValue
            if cornerCurve != .continuous {
                cornerCurve = .continuous
            }
        }
        get { cornerRadius }
    }
}


extension UIColor {
    
    /// 根据hex字符串创建颜色
    ///
    /// - Parameter hex: hex字符串
    convenience init(_ hex: String) {
        func filter(hex: String) -> NSString{
            let set = NSCharacterSet.whitespacesAndNewlines
            var str = hex.trimmingCharacters(in: set).lowercased()
            if str.hasPrefix("#") {
                str = String(str.suffix(str.count-1))
            } else if str.hasPrefix("0x") {
                str = String(str.suffix(str.count-2))
            }
            return NSString(string: str)
        }
        let hex = filter(hex: hex)
        let length = hex.length
        guard length == 3 || length == 4 || length == 6 || length == 8 else {
            print("无效的hex")
            self.init("000")
            return
        }
        func floatValue(from hex: String) -> CGFloat {
            var result = Float(0)
            Scanner(string: "0x"+hex).scanHexFloat(&result)
            var maxStr = "0xf"
            if length > 5 {
                maxStr = "0xff"
            }
            var max = Float(0)
            Scanner(string: maxStr).scanHexFloat(&max)
            result = result / max
            return CGFloat(result)
        }
        
        func substring(of hex: NSString, loc: Int) -> String {
            if length == 3 || length == 4 {
                return hex.substring(with: NSRange.init(location: loc, length: 1))
            } else if length == 6 || length == 8 {
                return hex.substring(with: NSRange.init(location: 2*loc, length: 2))
            } else {
                return ""
            }
        }
        
        let r = floatValue(from: substring(of: hex, loc: 0))
        let g = floatValue(from: substring(of: hex, loc: 1))
        let b = floatValue(from: substring(of: hex, loc: 2))
        var a = CGFloat(1)
        if length == 4 || length == 8 {
            a = floatValue(from: substring(of: hex, loc: 3))
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
}
