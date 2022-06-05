//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by GiN Eugene on 5/6/2022.
//

import Foundation
import UserNotifications

class LocalNotificationsService {
    
    func registeForLatestUpdatesIfPossible() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Доступ к уведомлениям получен")
                center.removeAllPendingNotificationRequests()
                
                let content = UNMutableNotificationContent()
                content.title = "Check last updates"
                content.body = "Check last updates"
                content.categoryIdentifier = "alarm"
                content.userInfo = ["CustomData": "qwerty"]
                content.sound = .default
                
                var dateComponents = DateComponents()
                dateComponents.hour = 16
                dateComponents.minute = 53
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "last_updates", content: content, trigger: trigger)
                
                center.add(request)
            }
            else {
                print("Доступ не получен")
            }
        }
    }
}
