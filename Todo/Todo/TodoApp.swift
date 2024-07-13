//
//  TodoApp.swift
//  Todo
//
//  Created by Анастасия on 22.06.2024.
//

import SwiftUI
import CocoaLumberjackSwift

@main
struct TodoApp: App {
    init() {
        DDLog.add(DDOSLogger.sharedInstance)
        DDLogInfo("DDLog added")
    }
    
    var body: some Scene {
        WindowGroup {
            MyDoingsView()
        }
    }
}
