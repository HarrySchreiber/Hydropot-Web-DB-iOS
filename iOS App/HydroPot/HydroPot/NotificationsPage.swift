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
            if(user.getOrderedNotifications().count == 0) {
                Text("You have not received any notifications. \nBe sure you have notifications turned on in the Account tab")
                    .font(.system(size: UIScreen.regTextSize))
                    .bold()
                    .italic()
                    .padding()
                    .foregroundColor(.gray)
                    .navigationBarTitle("Notifications", displayMode: .inline)
            } else {
                List {
                    ForEach(user.getOrderedNotifications()) {
                        notiePots in
                        
                        NavigationLink(destination: PlantPage(user: user, pot: notiePots.notiesTuple.pot, plants: plants)) {
                            VStack(alignment: .leading){
                                Text(getMessage(type: notiePots.notiesTuple.notification.type, pot: notiePots.notiesTuple.pot))
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(.top, 5)
                                HStack {
                                    Spacer()
                                    Text("\(notiePots.notiesTuple.notification.timeStamp, formatter: Self.taskDateFormat)")
                                        .font(.system(size: UIScreen.subTextSize))

                                }
                            }.fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .navigationBarTitle("Notifications", displayMode: .inline)
            }
        }
        .onAppear() {
            attemptReload()
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
            return "Hey \(user.name)! The soil on your plant, \(pot.plantName), is running a bit dry, be sure to water it soon!"
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
    
    func attemptReload() {
        user.reload() {
            // will be received at the login processed
            if user.loggedIn {
                for (index, _) in user.pots.enumerated() {
                    let tempPot = user.pots[index]
                    user.pots[index].editPlant(plantName: tempPot.plantName, plantType: tempPot.plantType, idealTempHigh: tempPot.idealTempHigh, idealTempLow: tempPot.idealTempLow, idealMoistureHigh: tempPot.idealMoistureHigh, idealMoistureLow: tempPot.idealMoistureLow, idealLightHigh: tempPot.idealLightHigh, idealLightLow: tempPot.idealLightLow, curLight: tempPot.curLight, curMoisture: tempPot.curMoisture, curTemp: tempPot.curTemp, automaticWatering: tempPot.automaticWatering, lastWatered: tempPot.lastWatered, image: tempPot.image)
                }
            }
        }
    }
}

struct NotificationsPage_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsPage(user: GetUser(), plants: Plants())
    }
}
