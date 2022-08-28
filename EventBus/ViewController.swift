//
//  ViewController.swift
//  EventBus
//
//  Created by liuduo on 2022/8/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var publisherThreadLabel: UILabel!
    @IBOutlet weak var subscriberThreadLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        EventBus.shared.subscribe(NormalEvent.self, for: self) { [unowned self] event in
            self.publisherThreadLabel.text = event.info
            self.subscriberThreadLabel.text = Thread.current.description
        }
        
        EventBus.shared.subscribe(BackgroundEvent.self, for: self, on: .global()) { [unowned self] event in
            let currentThreadInfo = Thread.current.description
            DispatchQueue.main.async {
                self.publisherThreadLabel.text = event.info
                self.subscriberThreadLabel.text = currentThreadInfo
            }
        }
    }

    deinit {
        print("ViewController " + #function)
        EventBus.shared.unsubscribe(target: self)
        EventBus.shared.printAllSubscribeInfo()
    }
}

