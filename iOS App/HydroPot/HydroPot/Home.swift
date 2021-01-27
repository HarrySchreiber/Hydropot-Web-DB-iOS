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
            Text("Home Page").tabItem { Text("Home") }.tag(1)
            PlantTypePage().tabItem { Text("Plant Type") }.tag(2)
            NotificationsPage().tabItem { Text("Notifications") }.tag(3)
            AccountPage().tabItem { Text("Account") }.tag(4)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
