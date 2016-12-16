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
    
    deinit {
        Utils.removeObserverForNotifications(observer: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    private func setupController() {
        Utils.registerNotificationWillEnterForeground(observer: self, selector: #selector(TouchIDViewController.updateUI))
        
        // Add right button in the navigation bar to repeat the login process so many times as we want
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(TouchIDViewController.updateUI))
    }
    
    func updateUI() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

