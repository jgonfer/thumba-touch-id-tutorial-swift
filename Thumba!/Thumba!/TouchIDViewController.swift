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
    @IBOutlet weak var refresh: UIButton!
    
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
        
        // The Refresh button will let us to repeat the login process so many times as we want
        refresh.alpha = 0
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
            showUnexpectedErrorMessage()
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
        
        loginProcess(policy: policy!)
    }
    
    private func loginProcess(policy: LAPolicy) {
        // Start evaluation process with a callback that is executed when the user ends the process successfully or not
        context.evaluatePolicy(policy, localizedReason: kMsgShowReason, reply: { (success, error) in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5, animations: {
                    self.refresh.alpha = 1
                })
                
                guard success else {
                    guard let error = error else {
                        self.showUnexpectedErrorMessage()
                        return
                    }
                    switch(error) {
                    case LAError.authenticationFailed:
                        self.message.text = "There was a problem verifying your identity."
                    case LAError.userCancel:
                        self.message.text = "Authentication was canceled by user."
                    // Fallback button was pressed and an extra login step should be implemented for iOS 8 users.
                    // By the other hand, iOS 9+ users will use the pasccode verification implemented by the own system.
                    case LAError.userFallback:
                        self.message.text = "The user tapped the fallback button (Fuu!)"
                    case LAError.systemCancel:
                        self.message.text = "Authentication was canceled by system."
                    case LAError.passcodeNotSet:
                        self.message.text = "Passcode is not set on the device."
                    case LAError.touchIDNotAvailable:
                        self.message.text = "Touch ID is not available on the device."
                    case LAError.touchIDNotEnrolled:
                        self.message.text = "Touch ID has no enrolled fingers."
                    // iOS 9+ functions
                    case LAError.touchIDLockout:
                        self.message.text = "There were too many failed Touch ID attempts and Touch ID is now locked."
                    case LAError.appCancel:
                        self.message.text = "Authentication was canceled by application."
                    case LAError.invalidContext:
                        self.message.text = "LAContext passed to this call has been previously invalidated."
                    // MARK: IMPORTANT: There are more error states, take a look into the LAError struct
                    default:
                        self.message.text = "Touch ID may not be configured"
                        break
                    }
                    return
                }
                
                // Good news! Everything went fine 👏
                self.message.text = self.kMsgFingerOK
            }
        })
    }
    
    private func showUnexpectedErrorMessage() {
        image.image = UIImage(named: "TouchID_off")
        message.text = "Unexpected error! 😱"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: IBAction Functions
    
    @IBAction func resetContextState(_ sender: UIButton) {
        // Initialize our context object just in this example, in a real app it shouldn't be necessary. In fact, we should avoid this initialization
        // The reason is because once our LAContext detects that the login was successfully done, it won't let us repeat the login process again
        context = LAContext()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.refresh.alpha = 0
        })
        
        updateUI()
    }
}

