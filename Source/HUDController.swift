//
//  HUDController.swift
//  ProHUD
//
//  Created by xaoxuu on 2019/7/29.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public class HUDController: UIViewController {
    
    /// ID标识
    public var identifier = String(Date().timeIntervalSince1970)
    
    internal var willAppearCallback: (() -> Void)?
    internal var didAppearCallback: (() -> Void)?
    internal var willDisappearCallback: (() -> Void)?
    internal var didDisappearCallback: (() -> Void)?

    /// 执行动画的图层
    internal var animateLayer: CALayer?
    internal var animation: CAAnimation?
    
    internal var progressView: ProHUD.ProgressView?
    
    /// 按钮事件
    internal var buttonEvents = [UIButton:() -> Void]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        debug(self, "init")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debug("👌", self, "deinit")
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        willAppearCallback?()
    }
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        didAppearCallback?()
    }
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        didDisappearCallback?()
    }
    
    public func viewWillAppear(_ callback: (() -> Void)?) {
        willAppearCallback = callback
    }
    public func viewDidAppear(_ callback: (() -> Void)?) {
        didAppearCallback = callback
    }
    
    public func viewWillDisappear(_ callback: (() -> Void)?) {
        willDisappearCallback = callback
    }
    public func viewDidDisappear(_ callback: (() -> Void)?) {
        didDisappearCallback = callback
    }
    
}

// MARK: - 事件
internal extension HUDController {
    
    func addTouchUpAction(for button: UIButton, action: @escaping () -> Void) {
        button.addTarget(self, action: #selector(didTappedButton(_:)), for: .touchUpInside)
        buttonEvents[button] = action
    }

    @objc func didTappedButton(_ sender: UIButton) {
        if let ac = buttonEvents[sender] {
            ac()
        }
    }
    
}

// MARK: - 动画

/// 图片动画
public protocol LoadingAnimationView: HUDController {
    var imageView: UIImageView { get }
}
public extension LoadingAnimationView {
    
    /// 更新进度（如果需要显示进度，需要先调用一次 updateProgress(0) 来初始化）
    /// - Parameter progress: 进度（0~1）
    func update(progress: CGFloat) {
        if let spv = imageView.superview {
            if progressView == nil {
                let v = ProHUD.ProgressView()
                spv.addSubview(v)
                v.snp.makeConstraints { (mk) in
                    mk.center.equalTo(imageView)
                    mk.width.height.equalTo(28)
                }
                progressView = v
            }
            if let v = progressView {
                v.updateProgress(progress: progress)
            }
        }
        
    }
}
/// 旋转动画
public protocol LoadingRotateAnimation: LoadingAnimationView {}
public extension LoadingRotateAnimation {
    
    /// 旋转动画
    /// - Parameters:
    ///   - layer: 图层
    ///   - direction: 方向
    ///   - speed: 速度
    func startRotate(_ layer: CALayer? = nil, direction: ProHUD.RotateDirection = .clockwise, speed: CFTimeInterval = 2) {
        DispatchQueue.main.async {
            let l = layer ?? self.imageView.layer
            self.animateLayer = l
            l.startRotate(direction: direction, speed: speed)
            NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    /// 停止旋转
    /// - Parameter layer: 图层
    func stopRotate(_ layer: CALayer? = nil) {
        DispatchQueue.main.async {
            self.animateLayer = nil
            (layer ?? self.imageView.layer)?.stopRotate()
            NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
}

/// 动画扩展
extension HUDController {
    @objc func didEnterBackground() {
        if let layer = animateLayer {
            animation = layer.animation(forKey: .rotateKey)
            layer.timeOffset = layer.convertTime(CACurrentMediaTime(), from: nil)
            layer.speed = 0
        }
    }
    @objc func willEnterForeground() {
        if let layer = animateLayer, let ani = animation, layer.speed == 0 {
            let pauseTime = layer.timeOffset
            layer.timeOffset = 0
            let beginTime = layer.convertTime(CACurrentMediaTime(), from: nil) - pauseTime
            layer.beginTime = beginTime
            layer.speed = 1
            layer.add(ani, forKey: .rotateKey)
        }
    }
}

