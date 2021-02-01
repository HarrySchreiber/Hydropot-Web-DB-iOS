//
//  NotificationsPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct NotificationsPage: View {
    @ObservedObject var user: GetUser
    var body: some View {
        NavigationView {
            List {
                ForEach(user.pots) {
                    pot in
                    NavigationLink(destination: PlantPage(user: user)) {
                        Text("Hey \(user.name)! Your plant, \(pot.plantName), was just watered by your Hydro Pot!")
                    }
                }
            }
            .navigationBarTitle("Notifications", displayMode: .inline)
            .navigationBarItems(trailing:  NavigationLink(destination: PlantPage(user: user)) {
             } )    //why does this line add styling to the list?
        }
    }
}
