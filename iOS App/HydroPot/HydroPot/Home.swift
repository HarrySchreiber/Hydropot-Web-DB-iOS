//
//  Home.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct Home: View {
    var body: some View {
        TabView() {
            HomeView().tabItem { Text("Home") }.tag(1)
            PlantTypeList().tabItem { Text("Plant Type") }.tag(2)
            NotificationsPage().tabItem { Text("Notifications") }.tag(3)
            AccountPage().tabItem { Text("Account") }.tag(4)
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

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
