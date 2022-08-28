//
//  CancellableEvent.swift
//  EventBus
//
//  Created by 刘铎 on 2022/8/28.
//

import Foundation

struct CancellableEvent: Event, Cancellable {
    var isCanceled = false
}
