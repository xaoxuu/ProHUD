# ProHUD

<br>

**一个易于上手又完全可定制化的专业HUD库**（内含Toast、Alert、Sheet三件套）

文档：<https://xaoxuu.com/wiki/prohud/>

<br>



## 特性

**易于上手**

- 用极少的参数就可以创建并显示一个实例。
- 用相似的接口调用**Toast**、**Alert**、**Sheet**。

**功能丰富**

- 具有完善的实例管理（多实例共存方案、查找与更新方案）。
- 可对已发布的实例进行数据更新。
- 横竖屏和iPad布局优化。

**完全可定制化**

- 支持只使用ProHUD的容器，而容器内容可完全自定义。
- 程序初始化时配置自定义UI样式，调用的时候只需要关注数据。
- 易于扩展，可以很方便的添加任意控件。


## Toast（顶部通知横幅）

通知条控件，用于非阻塞性事件通知。显示效果如同原生通知，默认会自动消失，可以支持手势移除，有多条通知可以平铺并列显示。

### 方式一：传入ViewModel生成实例

这种方式创建的实例在调用`push()`之后才会显示出来，结构为： 

```swift
let 实例 = Toast(视图模型)
实例.push()
```

也可以连在一起写，例如：

```swift
Toast(.message("要显示的消息内容")).push()
```

#### 如何创建ViewModel

ViewModel有多种创建方式，也可以自行扩展更多常用场景，例如：

```swift
// 纯文本
let vm = .message("要显示的消息内容")
// 持续2s的文本
let vm = .message("要显示的消息内容").duration(2)
// 标题 + 正文
let vm = .title("标题").message("正文")
```

内置了几种常见的场景扩展，例如正在加载的场景：
```swift
static var loading: ViewModel {
    let obj = ViewModel(icon: UIImage(inProHUD: "prohud.windmill"))
    obj.rotation = .init(repeatCount: .infinity)
    return obj
}
static func loading(_ seconds: TimeInterval) -> ViewModel {
    let obj = ViewModel(icon: UIImage(inProHUD: "prohud.windmill"), duration: seconds)
    obj.rotation = .init(repeatCount: .infinity)
    return obj
}
```

使用的时候可以：
```swift
// 无限持续时间
let vm = .loading
// 无限持续时间, 带有文字
let vm = .loading.message("正在加载")
// 持续10s
let vm = .loading(10)
// 持续10s, 带有文字
let vm = .loading(10).message("正在加载")
```

### 方式二：以闭包形式创建并显示实例

对于复杂实例，建议以这种方式使用，例如给实例增加事件响应：

```swift
let title = "您收到了一条消息"
let message = "点击通知横幅任意处即可回复"
Toast { toast in
    toast.vm = .msg.title(title).message(message)
    toast.onTapped { toast in
        toast.pop()
        Alert(.success(1).message("操作成功")).push()
    }
}
```

也可以增加多个按钮，横向平铺，在这个例子中，左侧图标位置自定义为头像：
```swift
let title = "您收到了一条好友申请"
let message = "丹妮莉丝·坦格利安申请添加您为好友，是否同意？"
Toast(.title(title).message(message)) { toast in
    toast.isRemovable = false
    toast.vm.icon = UIImage(named: "avatar")
    toast.imageView.layer.masksToBounds = true
    toast.imageView.layer.cornerRadius = toast.config.iconSize.width / 2
    toast.add(action: "拒绝", style: .destructive) { toast in
        // 按钮点击事件回调
        ...
    }
    toast.add(action: "同意") { toast in
        // 按钮点击事件回调
        toast.pop()
        Alert(.success(1).message("Good choice!")).push()
    }
}
```

### 如果存在就更新，不存在就创建新的实例

例如弹出一个loading，有多个地方需要更新这个loading，为了避免重复弹出多个实例，可以使用 `lazyPush` 方法：

```swift
Toast.lazyPush(identifier: "loading") { toast in
    toast.vm = .loading.title("正在加载\(i)").message("这条消息不会重复显示多条")
}
```

### 如果存在就更新，不存在就忽略指令

如果要对一个已经存在的实例进行更新，假如实例已经结束显示了，那就不进行任何操作，这时候可以使用 `find` 方法：

```swift
Toast.find(identifier: "loading") { toast in
    toast.vm = .success(2).message("加载成功")
}
```

## Alert（页面中心弹窗）

弹窗控件，用于强阻塞性交互，用户必须做出选择或者等待结果才能进入下一步，当多个实例出现时，会以堆叠的形式显示，新的实例会在覆盖旧的实例上层。

Alert和Toast一样有两种创建方法，不再赘述。

### 修改实例内容

在实例弹出后仍然可以修改实例内容：

```swift
// 持有实例的情况下：
Alert(.note) { alert in
    alert.vm.message = "可以动态增加、删除、更新文字"
    alert.add(action: "增加标题") { alert in
        alert.vm.title = "这是标题"
        alert.reloadTextStack()
    }
    alert.add(action: "增加正文") { alert in
        alert.vm.message = "可以动态增加、删除、更新文字"
        alert.reloadTextStack()
    }
    alert.add(action: "删除标题", style: .destructive) { alert in
        alert.vm.title = nil
        alert.reloadTextStack()
    }
    alert.add(action: "删除正文", style: .destructive) { alert in
        alert.vm.message = nil
        alert.reloadTextStack()
    }
    alert.add(action: "取消", style: .gray)
}
// 未持有实例时，可通过 identifier 查找并更新：
Alert.find(identifier: "my-alert") { alert in
    alert.vm.title = "这是标题"
    alert.reloadTextStack()
}
```

### 按钮的增删改查

```swift
Alert(.note) { alert in
    alert.vm.message = "可以动态增加、删除按钮"
    alert.add(action: "在底部增加按钮", style: .filled(color: .systemGreen)) { alert in
        alert.add(action: "哈哈1", identifier: "haha1")
    }
    alert.add(action: "在当前按钮下方增加", style: .filled(color: .systemIndigo), identifier: "add") { alert in
        alert.insert(action: .init(identifier: "haha2", style: .light(color: .systemOrange), title: "哈哈2", handler: nil), after: "add")
    }
    alert.add(action: "修改当前按钮文字", identifier: "edit") { alert in
        alert.update(action: "已修改", for: "edit")
    }
    alert.add(action: "删除「哈哈1」", style: .destructive) { alert in
        alert.remove(actions: .identifiers("haha1"))
    }
    alert.add(action: "删除「哈哈1」和「哈哈2」", style: .destructive) { alert in
        alert.remove(actions: .identifiers("haha1", "haha2"))
    }
    alert.add(action: "删除全部按钮", style: .destructive) { alert in
        alert.remove(actions: .all)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.pop()
        }
    }
    alert.add(action: "取消", style: .gray)
}
```

### 添加自定义控件

```swift
Alert { alert in
    alert.vm.title = "自定义控件"
    // 图片
    let imgv = UIImageView(image: UIImage(named: "landscape"))
    imgv.contentMode = .scaleAspectFill
    imgv.clipsToBounds = true
    imgv.layer.cornerRadiusWithContinuous = 12
    alert.add(subview: imgv).snp.makeConstraints { make in
        make.height.equalTo(120)
    }
    // seg
    let seg = UISegmentedControl(items: ["开发", "测试", "预发", "生产"])
    seg.selectedSegmentIndex = 0
    alert.add(subview: seg).snp.makeConstraints { make in
        make.height.equalTo(40)
        make.width.equalTo(400)
    }
    // slider
    let slider = UISlider()
    slider.minimumValue = 0
    slider.maximumValue = 100
    slider.value = 50
    alert.add(subview: slider)
    alert.add(spacing: 24)
    alert.add(action: "取消", style: .gray)
}
```


## Sheet（底部操作表）

操作表控件，用于弱阻塞性交互。显示区域为从屏幕底部向上弹出的新图层，可以放置丰富的内容，自由度较高。

### 布局

操作表控件空间较大，可以放置更多的文字、按钮和其它任何控件。

```swift
Sheet { sheet in
    sheet.add(title: "ProHUD")
    sheet.add(subTitle: "什么是操作表控件")
    sheet.add(message: "操作表控件，用于弱阻塞性交互。显示区域为从屏幕底部向上弹出的新图层，可以放置丰富的内容，自由度较高。")
    sheet.add(spacing: 24)
    sheet.add(action: "确认", style: .destructive) { sheet in
        Alert(.confirm) { alert in
            alert.vm.title = "处理点击事件"
            alert.add(action: "我知道了")
        }
    }
    sheet.add(action: "取消", style: .gray)
}
```

同样支持添加任意其它视图：

```swift
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
}
```

### 拦截背景点击事件

有时候如果不希望点击背景直接`pop`掉，可以实现 `onTappedBackground` 以拦截背景点击事件

```swift
Sheet { sheet in
    sheet.add(title: "ProHUD")
    sheet.add(message: "点击背景将不会dismiss，必须在下方做出选择才能关掉")
    sheet.add(spacing: 24)
    sheet.add(action: "确认")
    sheet.add(action: "取消", style: .gray)
} onTappedBackground: { sheet in
    print("点击了背景")
    Toast.lazyPush(identifier: "alert") { toast in
        toast.vm = .error
        toast.vm.title = "点击了背景"
        toast.vm.message = "点击背景将不会dismiss，必须在下方做出选择才能关掉"
        toast.vm.duration = 2
    }
}
```

## 个性化设置

### 完全自定义布局

ProHUD支持完全自定义布局，即将整个容器交给使用者来布局，在 `Alert.Configuration.shared` 中配置了 `reloadData` 规则之后，实例在显示前以及更新内容时都会进入此函数，执行自定义的 `reloadData` 代码。也可以指定部分 `identifier` 走自定义布局代码，其余走内置布局代码，例如：

```swift
Alert.Configuration.shared { config in
    config.reloadData { vc in
        if vc.identifier == "custom" {
            return true
        }
        return false
    }
}
Alert { alert in
    alert.identifier = "custom"
    alert.contentView.backgroundColor = .systemYellow
    alert.view.addSubview(alert.contentView)
    alert.contentView.layer.cornerRadiusWithContinuous = 32
    alert.contentView.snp.makeConstraints { make in
        make.width.equalTo(UIScreen.main.bounds.width - 100)
        make.height.equalTo(UIScreen.main.bounds.height - 200)
        make.center.equalToSuperview()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        alert.pop()
    }
}
```

### 个性化选项

ProHUD内置的布局也支持丰富的个性化参数，例如：

- 标题、正文、按钮字体字号
- 背景颜色、模糊效果
- 文字颜色
- 图标大小
- 卡片圆角
- Sheet组件卡片距离屏幕的边距

具体请探索 `ProHUD.Configuration` 类代码。


## 文档

<https://xaoxuu.com/wiki/prohud/>
