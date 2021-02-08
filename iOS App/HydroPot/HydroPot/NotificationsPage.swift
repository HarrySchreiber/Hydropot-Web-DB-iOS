//
//  NotificationsPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct NotificationsPage: View {
    @ObservedObject var user: GetUser
    @ObservedObject var plants: Plants
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
                        
                        NavigationLink(destination: PlantPage(user: user, pot: pot, plants: plants)) {
                            VStack(alignment: .leading){
                                Text(getMessage(type: notie.type, pot: pot))
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
    func getMessage(type: String, pot: Pot) -> String {
        switch type {
        case "just watered":
            return "Hey \(user.name)! Your plant, \(pot.plantName), was just watered by your Hydro Pot!"
        case "reservoir low":
            return "Hey \(user.name)! The water reservoir on your plant, \(pot.plantName), is running low! Add some water before it runs out!"
        case "temperature low":
            return "Hey \(user.name)! Your plant, \(pot.plantName), is too cold! Move it to a warmer location!"
        case "temperature high":
            return "Hey \(user.name)! Your plant, \(pot.plantName), is too hot! Move it to a cooler location!"
        case "moisture low":
            return "Hey \(user.name)! The soil on your plant, \(pot.plantName), is running a bit dry, hop onto Hydro Pot to water it!"
        case "moisture high":
            return "Hey \(user.name)! The soil on your plant, \(pot.plantName), is too wet!"
        case "light low":
            return "Hey \(user.name)! Your plant, \(pot.plantName), is receiving too little sun! Move it somewhere brighter!"
        case "light high":
            return "Hey \(user.name)! Your plant, \(pot.plantName), is receiving too much sun! Move it somewhere darker!"
        default:
            return "Hey \(user.name)! Your plant, \(pot.plantName), could use some attention"
        }
    }
}



struct NotificationsPage_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsPage(user: GetUser(), plants: Plants())
    }
}
