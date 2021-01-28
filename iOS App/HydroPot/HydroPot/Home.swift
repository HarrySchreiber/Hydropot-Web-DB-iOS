//
//  Home.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct Home: View {
    @ObservedObject var user: GetUser
    
    var body: some View {
        TabView() {
            HomeView().tabItem { Text("Home") }.tag(1)
            PlantTypeList().tabItem { Text("Plant Type") }.tag(2)
            NotificationsPage().tabItem { Text("Notifications") }.tag(3)
            AccountPage(user: user).tabItem { Text("Account") }.tag(4)
        }
    }
}

struct HomeView: View {
    var body: some View {
        GroupBox(label: Text("Plant Name")) {
            Text("Last Watered")
        }
    }
}

