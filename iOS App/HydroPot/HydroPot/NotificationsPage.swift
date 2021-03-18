//
//  NotificationsPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

/*
    view for the notifications page
 */
struct NotificationsPage: View {
    @ObservedObject var user: GetUser //user passed
    @ObservedObject var plants: Plants //plants list passed
    
    //date formatter
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, hh:mm a"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            //if user does not have notfications
            if(user.getOrderedNotifications().count == 0) {
                //alert them they don't
                Text("You have not received any notifications. \nBe sure you have notifications turned on in the Account tab")
                    //styling
                    .font(.system(size: UIScreen.regTextSize))
                    .bold()
                    .italic()
                    .padding()
                    .foregroundColor(.gray)
                    .navigationBarTitle("Notifications", displayMode: .inline)
            }
            //if the user does have notifications
            else {
                List {
                    //get the ordered notifications
                    ForEach(user.getOrderedNotifications()) {
                        notiePots in
                        //each notification goes to it's specific pot
                        NavigationLink(destination: PlantPage(user: user, pot: notiePots.notiesTuple.pot, plants: plants)) {
                            //card
                            VStack(alignment: .leading){
                                //get the message of the noti
                                Text(getMessage(type: notiePots.notiesTuple.notification.type, pot: notiePots.notiesTuple.pot))
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(.top, 5)
                                HStack {
                                    Spacer()
                                    //get the timestamp
                                    Text("\(notiePots.notiesTuple.notification.timeStamp, formatter: Self.taskDateFormat)")
                                    //styling
                                    .font(.system(size: UIScreen.subTextSize))

                                }
                            }.fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                .navigationBarTitle("Notifications", displayMode: .inline)
            }
        }
        //reload on the appearence of the page
        .onAppear(perform: attemptReload)
    }
    
    /// function to get the message behind a given noti
    ///
    /// - Parameters:
    ///     - type: type of notificartion
    ///     - pot: pot the notification belongs to
    ///
    /// - Returns:
    ///     - the message that goes with the given noti
    func getMessage(type: String, pot: Pot) -> String {
        
        //switch on types of notis
        switch type {
        //just watered noti string
        case "just watered":
            return "Hey \(user.name)! Your plant, \(pot.plantName), was just watered by your Hydro Pot!"
        //reservoir low string
        case "reservoir low":
            return "Hey \(user.name)! The water reservoir on your plant, \(pot.plantName), is running low! Add some water before it runs out!"
        //temperature low string
        case "temperature low":
            return "Hey \(user.name)! Your plant, \(pot.plantName), is too cold! Move it to a warmer location!"
        //temperature high string
        case "temperature high":
            return "Hey \(user.name)! Your plant, \(pot.plantName), is too hot! Move it to a cooler location!"
        //moisture low string
        case "moisture low":
            return "Hey \(user.name)! The soil on your plant, \(pot.plantName), is running a bit dry, be sure to water it soon!"
        //moisture high string
        case "moisture high":
            return "Hey \(user.name)! The soil on your plant, \(pot.plantName), is too wet!"
        //light low string
        case "light low":
            return "Hey \(user.name)! Your plant, \(pot.plantName), is receiving too little sun! Move it somewhere brighter!"
        //light high string
        case "light high":
            return "Hey \(user.name)! Your plant, \(pot.plantName), is receiving too much sun! Move it somewhere darker!"
        //if there is no recognized noti
        default:
            return "Hey \(user.name)! Your plant, \(pot.plantName), could use some attention"
        }
    }
    
    /// callback for reload function
    func attemptReload() {
        user.reload() {
        }
    }
}

/*
    preview page for notifications
 */
struct NotificationsPage_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsPage(user: GetUser(), plants: Plants())
    }
}
