//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by GiN Eugene on 5/6/2022.

import UserNotifications

class LocalNotificationsService {

    func registeForLatestUpdatesIfPossible() {
        self.registerUpdatesCategory()

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Push messages are allowed")
                center.removeAllPendingNotificationRequests()

                let content = UNMutableNotificationContent()
                content.title = "Check last updates"
                content.body = "You have updates"
                content.categoryIdentifier = "categoryCheckUpdates"
                content.sound = .default


                var dateComponents = DateComponents()
                dateComponents.hour = 19
                dateComponents.minute = 42

                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "last_updates", content: content, trigger: trigger)

                center.add(request)
            }
            else {
                print("Access denied")
            }
        }
    }

    func registerUpdatesCategory() {
        let center = UNUserNotificationCenter.current()

        let actionShow = UNNotificationAction(identifier: "actionUpdates", title: "Check updates", options: .foreground)
        let actionCancel = UNNotificationAction(identifier: "actionCancel", title: "Cancel", options: .destructive)
        let categoryCheckUpdates = UNNotificationCategory(identifier: "categoryCheckUpdates", actions: [actionShow, actionCancel], intentIdentifiers: [], options: [])

        center.setNotificationCategories([categoryCheckUpdates])
    }
}
