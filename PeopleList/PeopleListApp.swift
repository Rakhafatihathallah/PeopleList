//
//  PeopleListApp.swift
//  PeopleList
//
//  Created by Rakha Fatih Athallah on 05/12/22.
//

import SwiftUI

@main
struct PeopleListApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                PeopleView()
                    .tabItem {
                        Symbols.person
                        Text("Home")
                    }
                SettingsView()
                    .tabItem {
                        Symbols.gear
                        Text("Settings")
                    }
            }
        }
    }
}
