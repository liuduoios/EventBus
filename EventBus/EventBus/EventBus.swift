//
//  EventBus.swift
//  SwiftInfrastructureKit
//
//  Created by liuduo on 2022/7/21.
//

import Foundation

private struct EventHandler<E: Event> {
    var action: ((E) -> Void)?
    var handleQueue = DispatchQueue.main
}

public struct EventBus {
    public static var shared = EventBus()
    /// key: target
    /// value: EventType: EventHandler
    var subscriptions = [String: [String: Any]]()
    let operationQueue = DispatchQueue(label: "eventbus.operationQueue", attributes: [])
    
    public func publish<E: Event>(_ event: E) {
        operationQueue.sync {
            for (_, subscriberPairs) in subscriptions {
                let eventType = keyForEventType(type(of: event))
                if let handler = subscriberPairs[eventType] as? EventHandler<E> {
                    if event is Cancellable {
                        if (event as! Cancellable).isCanceled { return }
                    }
                    handler.handleQueue.async {
                        handler.action?(event)
                    }
                }
            }
        }
    }
    
    mutating public func subscribe<E: Event>(_ eventType: E.Type,
                                             for target: AnyObject,
                                             on queue: DispatchQueue = .main,
                                             action: @escaping (E) -> Void) {
        operationQueue.sync {
            let handler = EventHandler<E>(action: action, handleQueue: queue)
            
            let targetKey = keyForTarget(target)
            let eventKey = keyForEventType(eventType)
            
            if var subscriberPairs = subscriptions[targetKey] {
                subscriberPairs[eventKey] = handler
                subscriptions[targetKey] = subscriberPairs
            } else {
                subscriptions[targetKey] = [eventKey: handler]
            }
        }
    }
    
    mutating public func unsubscribe(target: AnyObject) {
        operationQueue.sync {
            let targetKey = keyForTarget(target)
            subscriptions[targetKey] = nil
        }
    }
    
    mutating public func unsubscribeAll() {
        operationQueue.sync {
            subscriptions.removeAll()
        }
    }
    
    public func printAllSubscribeInfo() {
        for (subscriber, subscriptionList) in subscriptions {
            print("订阅者：\(subscriber)")
            for (eventType, _) in subscriptionList {
                print("\t订阅了事件类型：\(eventType)")
            }
        }
    }
    
    private func keyForTarget(_ target: AnyObject) -> String {
        return addressOf(target)
    }
    
    private func keyForEventType<E: Event>(_ eventType: E.Type) -> String {
        return String(reflecting: eventType)
    }
    
    /// 获取对象地址的字符串形式
    private func addressOf(_ object: AnyObject) -> String {
        let pointer = Unmanaged.passUnretained(object).toOpaque()
        return pointer.debugDescription
    }
}
