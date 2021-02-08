//
//  Home.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct Home: View {
    @ObservedObject var user: GetUser
    @ObservedObject var plants: Plants
    
    init (user : GetUser, plants: Plants){
        UINavigationBar.appearance().barTintColor = UIColor(red: 41.0/255.0, green: 110.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        self.user = user
        self.plants = plants
    }
    var body: some View {
        TabView() {
            HomeView(user: user, plants: plants).tabItem { Text("Home") }.tag(1)
            PlantTypeList(plants: self.plants).tabItem { Text("Plant Type") }.tag(2)
            NotificationsPage(user: user, plants: plants).tabItem { Text("Notifications") }.tag(3)
            AccountPage(user: user).tabItem { Text("Account") }.tag(4)
        }
    }
}

struct HomeView: View {
    @ObservedObject var user: GetUser
    @ObservedObject var plants: Plants
    @State private var showPopUp = false
    @State private var threeML = true
    @State private var sixML = false
    @State private var nineML = false
    @State var showingDetail = false

    //temperary date formatting
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, hh:mm a"
        return formatter
    }()
    
    var body: some View {
        ZStack{
            NavigationView {
                List {
                    ForEach(user.pots) {
                    pot in
                        NavigationLink(destination: PlantPage(user: user, pot: pot, plants: plants)) {
                            VStack {
                                HStack(){
                                    Image(systemName: "leaf.fill")
                                        .font(.system(size: 80))
                                    VStack(alignment: .leading) {
                                        Text(pot.plantName)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .padding(.leading)
                                        Text("Temperature: \(pot.curTemp)°F")
                                            .font(.footnote)
                                            .padding(.leading)
                                    }
                                }
                                HStack() {
                                    Text("Last watered: \n\(pot.lastWatered, formatter: Self.taskDateFormat)")
                                        .padding(.top)
                                        .frame(maxWidth: 125)
                                    Button("Water Plant") {
                                        showPopUp = true
                                       }
                                    .buttonStyle(BorderlessButtonStyle())
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                                    .cornerRadius(6)
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Hydro Pot", displayMode: .inline)
                .navigationBarItems(trailing:
                Button(action: {
                    self.showingDetail.toggle()
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(6)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }.sheet(isPresented: $showingDetail) {
                    AddPlantPage(user: user, plants: plants, showModal: $showingDetail)
                })
            }
            if $showPopUp.wrappedValue {
                ZStack {
                    Color.white
                    VStack (alignment: .leading) {
                        Text("Water Amount")
                        HStack {
                            if (threeML == true){
                                Image(systemName: "drop.fill")
                                    .font(.system(size: 40))
                            }
                            else {
                                Image(systemName: "drop")
                                    .font(.system(size: 40))
                            }
                            Text("300 mL")
                        }
                        .onTapGesture {
                            threeML = true
                            sixML = false
                            nineML = false
                        }
                        HStack {
                            if (sixML == true){
                                Image(systemName: "drop.fill")
                                    .font(.system(size: 40))
                                Image(systemName: "drop.fill")
                                    .font(.system(size: 40))
                            }
                            else {
                                Image(systemName: "drop")
                                    .font(.system(size: 40))
                                Image(systemName: "drop")
                                    .font(.system(size: 40))
                            }
                            Text("600 mL")
                        }
                        .onTapGesture {
                            threeML = false
                            sixML = true
                            nineML = false
                        }
                        HStack {
                            if (nineML == true){
                                Image(systemName: "drop.fill")
                                    .font(.system(size: 40))
                                Image(systemName: "drop.fill")
                                    .font(.system(size: 40))
                                Image(systemName: "drop.fill")
                                    .font(.system(size: 40))
                            }
                            else {
                                Image(systemName: "drop")
                                    .font(.system(size: 40))
                                Image(systemName: "drop")
                                    .font(.system(size: 40))
                                Image(systemName: "drop")
                                    .font(.system(size: 40))
                            }
                            Text("900 mL")
                        }
                        .onTapGesture {
                            threeML = false
                            sixML = false
                            nineML = true
                        }
                        HStack {
                            Button("Cancel") {
                                showPopUp = false
                               }
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                            .cornerRadius(6)
                            Button("Confirm") {
                                showPopUp = false
                               }
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                            .cornerRadius(6)
                        }
                    }.padding()
                }
                .frame(width: 300, height: 250)
                .cornerRadius(20).shadow(radius: 20)
            }
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(user: GetUser(), plants: Plants())
    }
}
