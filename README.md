# EventBus

一个 Swift 版本的 EventBus。

已有功能：

- [x] 发布事件 
- [x] 订阅/取消订阅事件
- [x] 指定事件处理的队列
- [x] 线程安全
- [x] 使用哈希表保存数据实现 O(1) 的查找性能


未完成功能：
- [] 事件合并
- [] 粘性事件
 
## 用法

### 自定义事件对象

```swift
struct XXXEvent: Event {

}
```

### 订阅事件

#### 在主队列处理事件

```swift
EventBus.shared.subscribe(XXXEvent.self, for: self) { [unowned self] event in
    // 事件处理代码
}
```

#### 在指定队列处理事件

```swift
EventBus.shared.subscribe(XXXEvent.self, for: self, on: .global()) { [unowned self] event in
    // 事件处理代码
    }
}
```

### 取消订阅事件

```swift
deinit {
     EventBus.shared.unsubscribe(target: self)
}
```

### 发布事件

```swift
EventBus.shared.publish(XXXEvent())
```

