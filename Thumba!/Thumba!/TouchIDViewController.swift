//
//  ViewController.swift
//  Thumba!
//
//  Created by jgonzalez on 16/12/16.
//  Copyright © 2016 Netquest. All rights reserved.
//

import UIKit
import LocalAuthentication

class TouchIDViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var message: UILabel!
    
    let kMsgShowFinger = "Show me your finger 👍"
    let kMsgShowReason = "🌛 Try to dismiss this screen 🌜"
    let kMsgFingerOK = "Login successful! ✅"
    
    var context = LAContext()
    
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
        var policy: LAPolicy?
        // Depending the iOS version we've selected properly policy system that the user is able to do
        if #available(iOS 9.0, *) {
            // iOS 9+ users with Biometric and Passcode verification
            policy = .deviceOwnerAuthentication
        } else {
            // iOS 8 users with Biometric and Custom (Fallback button) verification
            context.localizedFallbackTitle = "Fuu!"
            policy = .deviceOwnerAuthenticationWithBiometrics
        }
        
        guard let _ = policy else {
            image.image = UIImage(named: "TouchID_off")
            message.text = "Unexpected error! 😱"
            return
        }
        
        var err: NSError?
        
        // Check if the user is able to use the policy we've selected previously
        guard context.canEvaluatePolicy(policy!, error: &err) else {
            image.image = UIImage(named: "TouchID_off")
            // Print the localized message received by the system
            message.text = err?.localizedDescription
            return
        }
        
        // Great! The user is able to use his/her Touch ID 👍
        image.image = UIImage(named: "TouchID_on")
        message.text = kMsgShowFinger
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

