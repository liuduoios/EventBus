//
//  Event.swift
//  EventBus
//
//  Created by liuduo on 2022/8/22.
//

import Foundation

public protocol Event {
    
}

public protocol Cancellable {
    var isCanceled: Bool { get set }
}

public extension Cancellable {
    mutating func cancel() {
        isCanceled = true
    }
}
