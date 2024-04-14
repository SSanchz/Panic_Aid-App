//
//  NotificationsHandler.swift
//  NotificationsApp
//
//  Created by Tihomir RAdeff on 20.02.24.
//

import Foundation
import UserNotifications

class NotificationsHandler {
    
    static func createNotification(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "Panic Pulse"
        content.body = message //this is a custom message for the notification
        content.sound = UNNotificationSound.default
        
        //turn on after 5 seconds
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "1000", content: content, trigger: trigger)
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { error in
            if error != nil {
                print("Error showing the notification!")
            }
        }
    }
    
}
