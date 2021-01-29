//
//  Home.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct Home: View {
    @ObservedObject var user: GetUser
    
    init (user : GetUser){
        UINavigationBar.appearance().barTintColor = UIColor(red: 41.0/255.0, green: 110.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        self.user = user
    }
    var body: some View {
        TabView() {
            HomeView(user: user).tabItem { Text("Home") }.tag(1)
            PlantTypeList().tabItem { Text("Plant Type") }.tag(2)
            NotificationsPage().tabItem { Text("Notifications") }.tag(3)
            AccountPage(user: user).tabItem { Text("Account") }.tag(4)
        }
    }
}

struct HomeView: View {
    @ObservedObject var user: GetUser
    @State private var showModal = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(user.pots) {
                pot in
                    NavigationLink(destination: PlantPage(user: user)) {
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
                                Text("Last watered: \n4 days ago ")
                                    .padding(.top)
                                    .frame(maxWidth: 125)
                                Button("Water Plant") {
                                    self.showModal.toggle()
                                   }.sheet(isPresented: $showModal) {
                                    WaterModal(showModal: self.$showModal)
                                        .padding(.top)
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
            .navigationBarItems(trailing:  NavigationLink(destination: AddPlantPage(user: user)) {
                 Image(systemName: "plus")
                     .resizable()
                     .padding(6)
                     .frame(width: 30, height: 30)
                     .clipShape(Circle())
                     .foregroundColor(.white)
             } )
        }
    }
}

