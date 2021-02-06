//
//  NotificationsPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct NotificationsPage: View {
    @ObservedObject var user: GetUser
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, hh:mm a"
        return formatter
    }()
    var body: some View {
        NavigationView {
            List {
                ForEach(user.pots) {
                    pot in ForEach(pot.notifications) {
                        notie in
                        
                        NavigationLink(destination: PlantPage(user: user, pot: pot)) {
                            VStack {
                                Text(notie.type)
                                HStack {
                                    Spacer()
                                    Text("\(notie.timeStamp, formatter: Self.taskDateFormat)")
                                        .font(.footnote)
                                }
                            }.fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            }
            .navigationBarTitle("Notifications", displayMode: .inline)
        }
    }
}

struct NotificationsPage_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsPage(user: GetUser())
    }
}
