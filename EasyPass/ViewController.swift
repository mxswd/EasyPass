//
//  ViewController.swift
//  EasyPass
//
//  Created by Maxwell on 12/05/22.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {

    var item: KeychainItem!
    @IBOutlet weak var showPassword: NSTextField!
    @IBOutlet weak var passwordField: NSSecureTextField!
    @IBOutlet weak var showButton: NSButton!
    @IBOutlet weak var lockButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        item = KeychainItem(service: "easypass", account: "default")
        passwordField.delegate = self
        passwordField.stringValue = (try? item.readItem()) ?? ""
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        DispatchQueue.main.async {
            self.view.window?.makeFirstResponder(nil)
        }
    }

    @IBAction func pressCopy(_ sender: Any) {
        let password = try! item.readItem()
        let pb = NSPasteboard.general
        pb.clearContents()
        pb.setString(password, forType: .string)
    }
    
    func controlTextDidChange(_ obj: Notification) {
        try! item.saveItem(passwordField.stringValue)
        if showButton.state == .on {
            showPassword.stringValue = passwordField.stringValue
        }
    }
    
    @IBAction func showPass(_ sender: Any) {
        if showButton.state == .on {
            showPassword.stringValue = try! item.readItem()
        } else {
            showPassword.stringValue = ""
        }
    }
    
    @IBAction func doubleClick(_ sender: Any) {
        NSAnimationContext.runAnimationGroup({ context in
            context.allowsImplicitAnimation = true
            context.duration = 1
            context.timingFunction = CAMediaTimingFunction(
                name: CAMediaTimingFunctionName.easeOut)
            lockButton.animator().rotate(byDegrees: 359)
        }, completionHandler: { [weak self] in
            self?.lockButton.animator().rotate(byDegrees: 0)
        })
    }
    
}
