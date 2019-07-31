//
//  TestA.swift
//  ProHUDExample
//
//  Created by xaoxuu on 2019/7/23.
//  Copyright © 2019 Titan Studio. All rights reserved.
//

import UIKit

public class TestA: NSObject {

    class func test1() {
        print(self, "test1")
    }
    class func test2() {
        print(self, "test2")
    }
    
}


open class TestB: NSObject {
    
    
    class func test1() {
        print(self, "test1")
    }
    open class func test2() {
        print(self, "test2")
    }
    
    
}

class TestAA: TestA {
    
    override class func test2() {
        print(self, "test2", "override")
    }
    
}

class TestBB: TestB {
    
    override class func test2() {
        print(self, "test2", "override")
    }
}
