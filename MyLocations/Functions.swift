//
//  Functions.swift
//  MyLocations
//
//  Created by Aurelijus Lape on 24/06/2019.
//  Copyright © 2019 Aurelijus Lape. All rights reserved.
//

import Foundation

func afterDelay(_ timeInterval: TimeInterval, run: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval, execute: run)
}

let applicationDocumentsDirectory: URL = {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}()

let CoreDataSaveFailedNotification = Notification.Name(rawValue: "CoreDataSaveFailedNotification")

func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: CoreDataSaveFailedNotification, object: nil)
}
