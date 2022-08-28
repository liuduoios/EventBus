//
//  PublisherViewController.swift
//  EventBus
//
//  Created by liuduo on 2022/8/28.
//

import UIKit

class PublisherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("PublisherViewController " + #function)
    }
    
    @IBAction func postOnMainThread(_ sender: Any) {
        EventBus.shared.publish(NormalEvent(info: Thread.current.description))
        dismiss(animated: true)
    }
    
    @IBAction func postOnSubThread(_ sender: Any) {
        DispatchQueue.global(qos: .userInitiated).async {
            EventBus.shared.publish(BackgroundEvent(info: Thread.current.description))
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func postCancellableEvent(_ sender: Any) {
        var event = CancellableEvent()
        event.cancel()
        DispatchQueue.global(qos: .userInitiated).async {
            EventBus.shared.publish(event)
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
}
