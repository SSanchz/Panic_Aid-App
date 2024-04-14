//
//  ViewController.swift
//  PP
//
//  Created by user248997 on 3/29/24.
//
import Foundation
import UIKit
import UserNotifications
import SwiftUI
import AVKit

class MainViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let heartRateMonitor = HeartRateMonitor()
        heartRateMonitor.startMonitoringHeartRate()
        // Do any additional setup after loading the view.
        UNUserNotificationCenter.current().delegate = self
        
        givePermission() //give notifications permission
    }
    @IBAction func Button_1(_ sender: Any) {
        let vc = UIHostingController(rootView: DBController())
        present(vc,animated: true)
    }
    
    @IBAction func Button_2(_ sender: Any) {
        let vc = UIHostingController(rootView: GRController())
        present(vc,animated: true)
    }
    
    @IBAction func Button_3(_ sender: Any) {
        let vc = UIHostingController(rootView: MDController())
        present(vc,animated: true)
    }
    
    @IBAction func Button_4(_ sender: Any) {
        let vc = UIHostingController(rootView: OtherController())
        present(vc,animated: true)
    }
    
    func givePermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                NotificationsHandler.createNotification(message: "Welcome")
            } else {
                print("Permission not granted!")
            }
        }
    }
    
    //to see the notification while the app is opened
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return .banner
    }
}

