//
//  EventBusTests.swift
//  EventBusTests
//
//  Created by liuduo on 2022/9/5.
//

import XCTest
@testable import EventBus

struct NormalEvent: Event {
    var info: String
}

class EventBusTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSubscribeOnMainQueue() throws {
        EventBus.shared.subscribe(NormalEvent.self, for: self) { event in
            assert(Thread.isMainThread)
            assert(event.info == "aaaa")
        }
        
        let event = NormalEvent(info: "aaaa")
        EventBus.shared.publish(event)
    }
    
    func testSubscribeOnSubQueue() throws {
        EventBus.shared.subscribe(NormalEvent.self, for: self, on: .global()) { event in
            assert(!Thread.isMainThread)
            assert(event.info == "aaaa")
        }
        
        let event = NormalEvent(info: "aaaa")
        EventBus.shared.publish(event)
    }
    
    func testRemoveSubscriber() throws {
        EventBus.shared.subscribe(NormalEvent.self, for: self, on: .global()) { event in
            assert(!Thread.isMainThread)
            assert(event.info == "aaaa")
        }
        assert(EventBus.shared.subscriptions.count == 1)
        EventBus.shared.unsubscribe(target: self)
        assert(EventBus.shared.subscriptions.count == 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
