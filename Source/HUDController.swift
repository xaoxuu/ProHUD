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
    public var animateLayer: CALayer?
    internal var animation: CAAnimation?
    
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

extension HUDController {
    @objc func pauseAnimation() {
        if let layer = animateLayer {
            animation = layer.animation(forKey: .rotateKey)
            layer.timeOffset = layer.convertTime(CACurrentMediaTime(), from: nil)
            layer.speed = 0
        }
    }
    @objc func resumeAnimation() {
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

public protocol RotateAnimation: HUDController {
    var imageView: UIImageView { get }
    var animateLayer: CALayer? { get set }
}

public extension RotateAnimation {
    
    func rotate(_ layer: CALayer? = nil, direction: ProHUD.RotateDirection = .clockwise, speed: CFTimeInterval = 2) {
        DispatchQueue.main.async {
            let l = layer ?? self.imageView.layer
            self.animateLayer = l
            l.startRotate(direction: direction, speed: speed)
            NotificationCenter.default.addObserver(self, selector: #selector(self.pauseAnimation), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.resumeAnimation), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    func rotate(_ layer: CALayer? = nil, _ flag: Bool) {
        DispatchQueue.main.async {
            self.animateLayer = nil
            (layer ?? self.imageView.layer)?.endRotate()
            NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
}
