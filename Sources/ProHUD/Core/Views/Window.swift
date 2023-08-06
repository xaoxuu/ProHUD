//
//  Window.swift
//  
//
//  Created by xaoxuu on 2022/9/1.
//

import UIKit
import SnapKit

class Window: UIWindow {
    
    lazy var backgroundView: UIView = {
        let v = UIView()
        v.backgroundColor = .black.withAlphaComponent(0.6)
        v.alpha = 0
        return v
    }()
    
    var usingBackground: Bool { false }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    lazy var vc: UIViewController = {
        UIViewController()
    }()
    
    func setup() {
        makeKeyAndVisible()
        resignKey()
        backgroundColor = .clear
        if usingBackground {
            insertSubview(backgroundView, at: 0)
            backgroundView.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
        rootViewController = vc
    }
    
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
