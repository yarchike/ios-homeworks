//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 03.11.2024.
//

import Foundation
import UserNotifications

class LocalNotificationsService: NSObject, UNUserNotificationCenterDelegate{
    
    func registeForLatestUpdatesIfPossible(){
        registerUpdatesCategory()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert]) { granted, error in
            guard granted else {
                print("Доступ к уведомлениям не предоставлен")
                return
            }
            self.scheduleDailyNotification()
        }
    }
    
    private func scheduleDailyNotification() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Напоминание"
        content.body = "Посмотрите последние обновления"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 19
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: "DailyUpdateNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Ошибка при добавлении уведомления: \(error.localizedDescription)")
            }
        }
    }
    
    func registerUpdatesCategory() {
        let viewAction = UNNotificationAction(identifier: "VIEW_UPDATES_ACTION",
                                              title: "Посмотреть обновления",
                                              options: [.foreground])
        
        let category = UNNotificationCategory(identifier: "updates",
                                              actions: [viewAction],
                                              intentIdentifiers: [],
                                              options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "VIEW_UPDATES_ACTION" {
            print("Пользователь выбрал действие 'Посмотреть обновления'")
        }
        completionHandler()
    }
}

