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
    
    /// 消失回调
    internal var disappearCallback: (() -> Void)?
    
    /// 按钮事件
    fileprivate var buttonEvents = [UIButton:() -> Void]()
    
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
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disappearCallback?()
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
