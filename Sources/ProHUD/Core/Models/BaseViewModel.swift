//
//  BaseViewModel.swift
//
//
//  Created by xaoxuu on 2022/8/29.
//

import UIKit

public protocol HUDViewModelType {}

/// 数据模型
open class BaseViewModel: NSObject, HUDViewModelType {
    
    /// 在创建target之前临时暂存的id
    private var tmpStoredIdentifier: String?
    
    /// 创建target时将指定为此值
    @objc open var identifier: String? {
        set {
            tmpStoredIdentifier = newValue
            if let id = tmpStoredIdentifier, id.count > 0 {
                vc?.identifier = id
            }
        }
        get {
            if let vc = vc {
                return vc.identifier
            } else {
                return tmpStoredIdentifier
            }
        }
    }
    
    /// 图标
    @objc open var icon: UIImage?
    @objc var iconURL: URL?
    
    /// 图标旋转动画
    open var rotation: Rotation?
    
    /// 标题
    @objc open var title: String?
    
    /// 消息正文
    @objc open var message: String?
    
    @objc open var tintColor: UIColor?
    
    /// 持续时间（为空代表根据场景不同的默认配置，为0代表无穷大）
    open var duration: TimeInterval?
    
    weak var vc: BaseController? {
        didSet {
            if let id = tmpStoredIdentifier {
                vc?.identifier = id
            }
        }
    }
    
    @objc required public override init() {
        
    }
    
    public convenience init(icon: UIImage? = nil, duration: TimeInterval? = nil) {
        self.init()
        self.icon = icon
        self.duration = duration
    }
    
    private var timeoutTimer: Timer?
    
    func restartTimer() {
        cancelTimer()
        if let duration = duration {
            if duration > 0 {
                let timer = Timer(timeInterval: duration, repeats: false, block: { [weak self] t in
                    if let vc = self?.vc as? any HUDTargetType {
                        vc.pop()
                    }
                })
                RunLoop.main.add(timer, forMode: .common)
                timeoutTimer = timer
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    if let vc = self.vc as? any HUDTargetType {
                        vc.pop()
                    }
                }
            }
        }
    }
    
    func cancelTimer() {
        timeoutTimer?.invalidate()
        timeoutTimer = nil
    }
    
}

// MARK: - convenience func
public extension BaseViewModel {
    
    // MARK: identifier
    
    /// 设置唯一标识符（不传参数则以代码位置作为唯一标识符）
    /// - Parameters:
    ///   - identifier: 指定的唯一标识符
    /// - Returns: 唯一标识符
    @discardableResult func identifier(_ identifier: String? = nil, file: String = #file, line: Int = #line) -> Self {
        self.identifier = identifier ?? (file + "#\(line)")
        return self
    }
    
    /// 设置唯一标识符（不传参数则以代码位置作为唯一标识符）
    /// - Parameters:
    ///   - identifier: 指定的唯一标识符
    /// - Returns: 唯一标识符
    @discardableResult static func identifier(_ identifier: String? = nil, file: String = #file, line: Int = #line) -> Self {
        .init().identifier(identifier, file: file, line: line)
    }
    
    // MARK: icon
    
    @discardableResult func icon(_ image: UIImage?) -> Self {
        self.icon = image
        return self
    }
    
    @discardableResult func icon(_ imageURL: URL?) -> Self {
        self.iconURL = imageURL
        return self
    }
    
    @discardableResult func icon(_ imageURLStr: String) -> Self {
        if let url = URL(string: imageURLStr) {
            return icon(url)
        } else {
            return icon(.init(named: imageURLStr))
        }
    }
    
    static func icon(_ imageURLStr: String) -> Self {
        .init().icon(imageURLStr)
    }
    static func icon(_ imageURL: URL) -> Self {
        .init().icon(imageURL)
    }
    static func icon(_ image: UIImage?) -> Self {
        .init().icon(image)
    }
    
    // MARK: text
    
    @discardableResult func title(_ text: String?) -> Self {
        self.title = text
        return self
    }
    
    static func title(_ text: String?) -> Self {
        .init()
        .title(text)
    }
    
    @discardableResult func message(_ text: String?) -> Self {
        self.message = text
        return self
    }
    
    static func message(_ text: String?) -> Self {
        .init()
        .message(text)
    }
    
    // MARK: others
    
    @discardableResult func duration(_ seconds: TimeInterval?) -> Self {
        self.duration = seconds
        return self
    }
    
    @discardableResult func rotation(_ rotation: Rotation?) -> Self {
        self.rotation = rotation
        return self
    }
    
    @discardableResult func tintColor(_ tintColor: UIColor?) -> Self {
        self.tintColor = tintColor
        return self
    }
    
}

// MARK: - example scenes
public extension BaseViewModel {
    
    // MARK: loading
    static var loading: Self {
        .init()
        .icon(.init(inProHUD: "prohud.windmill"))
        .rotation(.default)
    }
    static func loading(_ seconds: TimeInterval) -> Self {
        .init()
        .icon(.init(inProHUD: "prohud.windmill"))
        .rotation(.default)
        .duration(seconds)
    }
    // MARK: success
    static var success: Self {
        .init()
        .icon(.init(inProHUD: "prohud.checkmark"))
    }
    static func success(_ seconds: TimeInterval) -> Self {
        .init()
        .icon(.init(inProHUD: "prohud.checkmark"))
        .duration(seconds)
    }
    // MARK: warning
    static var warning: Self {
        .init()
        .icon(.init(inProHUD: "prohud.exclamationmark"))
    }
    static func warning(_ seconds: TimeInterval) -> Self {
        .init()
        .icon(.init(inProHUD: "prohud.exclamationmark"))
        .duration(seconds)
    }
    // MARK: error
    static var error: Self {
        .init()
        .icon(.init(inProHUD: "prohud.xmark"))
    }
    static func error(_ seconds: TimeInterval) -> Self {
        .init()
        .icon(.init(inProHUD: "prohud.xmark"))
        .duration(seconds)
    }
    // MARK: failure
    static var failure: Self { error }
    static func failure(_ seconds: TimeInterval) -> Self { error(seconds) }
    
}
