<br>

<img src="https://img.vim-cn.com/92/807ffd8bab40497971172514294020b6501074.png" height="80px">

**简单易用，完全可定制化的HUD** （ProHUD = Toast + Alert + ActionSheet）

文档：<https://xaoxuu.com/wiki/prohud/>

<br>

|                                                             |                                                             |                                                             |                                                             |                                                              |
| ----------------------------------------------------------- | ----------------------------------------------------------- | ----------------------------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------------ |
| ![1.PNG](https://i.loli.net/2019/08/20/sgultOmRLXrwfA3.png) | ![2.PNG](https://i.loli.net/2019/08/20/a2mCq871PwfbZEG.png) | ![3.PNG](https://i.loli.net/2019/08/20/Zdz2cTphOlu3XKf.png) | ![4.PNG](https://i.loli.net/2019/08/20/87UdSGaMuevV1iF.png) | ![5.PNG](https://i.loli.net/2019/08/20/HEusSLBgG3XC1nN.png)  |
| ![6.PNG](https://i.loli.net/2019/08/20/B178IvGZgbzjiuk.png) | ![7.PNG](https://i.loli.net/2019/08/20/YSNEX3fmdtiarjZ.png) | ![8.PNG](https://i.loli.net/2019/08/20/zlDXtWKfR3pLkji.png) | ![9.PNG](https://i.loli.net/2019/08/20/NEewmBV27fhW4yI.png) | ![10.PNG](https://i.loli.net/2019/08/20/XYvCIow2faRtn9P.png) |

|                                                              |                                                              |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| ![11.PNG](https://i.loli.net/2019/08/20/nHqKmNOEejgxbrf.png) | ![12.PNG](https://i.loli.net/2019/08/20/kScIodEnmbpaT5Y.png) | ![13.PNG](https://i.loli.net/2019/08/20/2RomGEC1KfSvIP9.png) |




## 特性

#### 使用简单

- 用相似的接口调用**Toast**、**Alert**、**Guard**。

#### 功能丰富

- 用简便的方法拿到已发布的实例，避免重复发布实例。
- 可对已发布的实例进行数据更新。
- 横竖屏和iPad布局优化。
- 可对所有实例设置监听事件。
- 对多实例并存堆叠的极端情况做了优化。

#### 完全可定制化

- 字体、颜色、边距等可配置。
- 可扩展场景。
- 程序初始化时配置自定义UI样式，快速调用。
- 易于扩展，可以很方便的添加任意控件，并处理好布局。

### Toast（顶部通知横幅）

- 多个Toast并存策略（平铺）。
- 只接收一个点击事件。
- 可以预先对不同的场景配置不同的默认值（图标、持续时间）。



### Alert（页面中心弹窗）

- 多个Alert并存策略（具有景深效果的堆叠）。
- 可以预先对不同的场景配置不同的默认值（图标、持续时间）。
- 可快速创建具有预先配置的默认样式（Default、Destructive、Cancel）的按钮。
- 对已发布的实例进行文本和按钮的更新，包括新增、修改、删除文本和按钮。
- 强制退出按钮（防止超时导致页面卡死）。



### Guard（底部操作表）

- 快速创建具有预先配置的默认样式的文本元素（标题、副标题、正文）。
- 可快速创建具有预先配置的默认样式（Default、Destructive、Cancel）的按钮。


## 基本使用

以下示例中，scene、title、message等参数都是非必填项，如果不需要可以省略。


### Toast 横幅

默认提供的场景有：`default, loading, success, warning, error`。

示例1：发布一个警告

```swift
Toast.push(scene: .warning, title: "设备电量过低", message: "请及时对设备进行充电，以免影响使用。")
```

示例2：发布一个警告并设置其他属性

```swift
Toast.push(scene: .warning, title: "设备电量过低", message: "请及时对设备进行充电，以免影响使用。") { (toast) in
    // 设置identifier
    toast.identifier = "这是唯一标识"
    // 禁止通过手势将其移出屏幕
    toast.isRemovable = false
    // 监听点击事件
    toast.didTapped {
        debugPrint("点击了这条横幅")
    }
}
```



### Alert 弹窗

示例1：发布一个Loading

```swift
// 写法1（最简）
let a = Alert.push(scene: .loading, title: "正在加载", message: "请稍等片刻").rotate()

// 写法2（标准）
Alert.push() { (a) in
    a.identifier = "loading"
    a.rotate()
    a.update { (vm) in
        vm.scene = .loading
        vm.title = "正在同步"
        vm.message = "请稍等片刻"
    }
}

// 写法3（飞入效果）
let a = Alert.push() { (a) in
    a.identifier = "loading"
}
a.rotate()
a.update { (vm) in
    vm.scene = .loading
    vm.title = "正在同步"
    vm.message = "请稍等片刻"
}
```

示例2：发布一个可交互弹窗

```swift
Alert.push() { (a) in
    a.identifier = "error"
    a.update { (vm) in
        vm.scene = .error
        vm.title = "同步失败"
        vm.message = "请检查网络是否连接"
        vm.add(action: .default, title: "重试") {
            // do something
        }
        vm.add(action: .cancel, title: "取消", handler: nil)
    }
}
```


### Guard 操作表

`Guard`控件使用更加灵活：

```swift
Guard.push { (g) in
    g.update { (vm) in
        vm.add(title: "大标题")
        vm.add(subTitle: "副标题")
        vm.add(message: "正文")
        vm.add(action: .default, title: "确定") {
            // do something
        }
        vm.add(action: .destructive, title: "删除") {
            // do something
        }
        vm.add(action: .cancel, title: "取消") {

        }
    }
}
```

示例1：弹出一个删除的操作表

```swift
Guard.push() { (g) in
    g.update { (vm) in
        // 添加一个删除按钮
        vm.add(action: .destructive, title: "删除") { [weak g] in
            // 确认弹窗
            Alert.push(scene: .delete, title: "确认删除", message: "此操作不可撤销") { (a) in
                a.update { (vm) in
                    vm.add(action: .destructive, title: "删除") { [weak a] in
                        // 删除操作
                        a?.pop()
                    }
                    vm.add(action: .cancel, title: "取消", handler: nil)
                }
            }
            g?.pop()
        }
        // 添加一个取消按钮
        vm.add(action: .cancel, title: "取消", handler: nil)
    }
}
```

示例2：弹出一个全屏的隐私政策页面

```swift
Guard.push() { (vc) in
    vc.isFullScreen = true
    vc.update { (vm) in
        let titleLabel = vm.add(title: "隐私协议")
        titleLabel.snp.makeConstraints { (mk) in
            mk.height.equalTo(44)
        }
        let tv = UITextView()
        tv.backgroundColor = .white
        tv.isEditable = false
        vc.textStack.addArrangedSubview(tv)
        tv.text = "这里可以插入一个webView"
        vm.add(message: "请认真阅读以上内容，当您阅读完毕并同意协议内容时点击接受按钮。")
        vm.add(action: .default, title: "接受") { [weak vc] in
            vc?.pop()
        }
    }  
}
```

## 高级用法

### 更新已有实例

示例：获取刚才弹出的Loading，把它更新为加载成功。

```swift
Alert.find("loading", last: { (a) in
    a.update { (vm) in
        vm.scene = .success
        vm.title = "同步成功"
        vm.message = nil
    }
})
```

### 避免重复发布

示例：发布一个横幅或者弹窗，如果已经有了就更新标题。

```swift
Toast.find("aaa", last: { (t) in
    t.update() { (vm) in
        vm.title = "已经存在了"
    }
}) {
    Toast.push(title: "这是一条id为aaa的横幅", message: "避免重复发布同一条信息") { (t) in
        t.identifier = "aaa"
        t.update { (vm) in
            vm.scene = .warning
            vm.duration = 0
        }
    }
}
```


### 修改样式

你可以在AppDelegate中配置好颜色、字体、间距等

```swift
ProHUD.config { (cfg) in
    cfg.rootViewController = window!.rootViewController
    cfg.primaryLabelColor = .black // 标题颜色
    cfg.secondaryLabelColor = .darkGray // 正文颜色
    cfg.alert { (a) in
        a.titleFont = .bold(22)
        a.bodyFont = .regular(17)
        a.boldTextFont = .bold(18)
        a.buttonFont = .bold(18)
        a.forceQuitTimer = 3
        a.iconSize = .init(width: 48, height: 48)
        a.margin = 8
        a.padding = 16
    }
    cfg.toast { (t) in
        t.titleFont = .bold(18)
        t.bodyFont = .regular(16)
    }
    cfg.guard { (g) in
        g.titleFont = .bold(22)
        g.subTitleFont = .bold(20)
        g.bodyFont = .regular(17)
        g.buttonFont = .bold(18)
    }
}
```

### 场景及其扩展

你可以在一个文件中扩展场景，例如：

```swift
extension ProHUD.Scene {
    static var confirm: ProHUD.Scene {
        var scene = ProHUD.Scene(identifier: "confirm")
        scene.image = UIImage(named: "ProHUDMessage")
        return scene
    }
    static var delete: ProHUD.Scene {
        var scene = ProHUD.Scene(identifier: "delete")
        scene.image = UIImage(named: "ProHUDTrash")
        scene.title = "确认删除"
        scene.message = "此操作不可撤销"
        return scene
    }
    static var buy: ProHUD.Scene {
        var scene = ProHUD.Scene(identifier: "buy")
        scene.image = UIImage(named: "ProHUDBuy")
        scene.title = "确认付款"
        scene.message = "一旦购买拒不退款"
        return scene
    }
}
```

这样你在发布横幅或者弹窗的时候，scene参数就可以填写`.confirm, .delete, .buy`这三种了。例如：

```swift
Alert.push(scene: .delete) { (a) in
    a.update() { (vm) in
        vm.add(action: .destructive, title: "删除") { [weak a] in
            // 删除操作
            a?.pop()
        }
        vm.add(action: .cancel, title: "取消", handler: nil)
    }
}
```

这样就可以弹出一个预先配置好的确认删除样式的弹窗。


### 完全自定义布局

```swift
ProHUD.config { (cfg) in
    cfg.alert { (config) in
        config.reloadData { (vc) in
            // 这是数据模型
            vc.vm
            // 这是要弹出的vc
            vc
            // 你可以在这里完全自由布局
        }
    }
}
```



## 文档

<https://xaoxuu.com/wiki/prohud/>