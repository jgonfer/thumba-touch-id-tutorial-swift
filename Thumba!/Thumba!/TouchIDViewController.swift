//
//  ViewController.swift
//  Thumba!
//
//  Created by jgonzalez on 16/12/16.
//  Copyright © 2016 Netquest. All rights reserved.
//

import UIKit

class TouchIDViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    let kMsgShowFinger = "Show me your finger 👍"
    let kMsgShowReason = "🌛 Try to dismiss this screen 🌜"
    let kMsgFingerOK = "Login successful! ✅"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

