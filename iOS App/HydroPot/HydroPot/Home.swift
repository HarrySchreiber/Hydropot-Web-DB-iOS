//
//  Home.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//
import SwiftUI

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = screenWidth
    static let imageMultiplier = 4 //10692 //80
    static let regTextMultiplier = 18.8 //10692 //17
    static let titleTextMultiplier = 14.5 //8262 //22
    static let subTextMultiplier = 24.6 //13982 //13
    static let lastWateredMultiplier = 2.56 //1454 //125
    static let boarderPaddingMultiplier = 32 //18176 //10
}

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
            HomeView(user: user, plants: plants).tabItem {
                Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                Text("Home") }.tag(1)
            PlantTypeList(plants: self.plants).tabItem { Image(systemName: "magnifyingglass")
                Text("Plant Type") }.tag(2)
            NotificationsPage(user: user, plants: plants).tabItem {
                Image(systemName: "bell.fill")
                Text("Notifications") }.tag(3)
            AccountPage(user: user).tabItem {
                Image(systemName: "person.crop.circle.fill")
                      Text("Account") }.tag(4)
        }
    }
}

struct HomeView: View {
    @ObservedObject var user: GetUser
    @ObservedObject var plants: Plants
    @State private var showPopUp = false
    @State var potSelected = Pot(plantName: "", plantType: "", idealTempHigh: 0, idealTempLow: 0, idealMoistureHigh: 0, idealMoistureLow: 0, idealLightHigh: 0, idealLightLow: 0, lastWatered: Date(), records: [], notifications: [], resLevel: 0, curTemp: 0, curLight: 0, curMoisture: 0, id: "", automaticWatering: false)
    @State var showingDetail = false
    
    //temperary date formatting
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, hh:mm a"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack{
                if(user.pots.count == 0) {
                    ScrollView {
                        PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                            //attemptReload()
                        }
                        Text("You have no plants added.\nTry adding a plant by selecting the plus icon in the top right")
                            .bold()
                            .italic()
                            .padding()
                            .foregroundColor(.gray)
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
                } else {
                    List {
                        //PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                            //attemptReload()
                        //}
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
                                        Text("Last watered: \n\(getLastWatered(pot: pot))")
                                            .padding(.top)
                                            .frame(maxWidth: 125)
                                        Button("Water Plant") {
                                            potSelected = pot
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
                        .onDelete(perform: user.deletePot)
                    }
                    .allowsHitTesting(!showPopUp)
                    .navigationBarTitle("Hydro Pot", displayMode: .inline)
                    .navigationBarItems(trailing:
                        Button(action: {
                            if (showPopUp != true){
                                self.showingDetail.toggle()
                            }
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
                    waterModal(showPopUp: $showPopUp, pot: potSelected, user: user)
                }
            }
        }
    }
    
    func getLastWatered(pot: Pot) -> String {
        
        let date1 = pot.lastWatered
        let date2 = Date()
        
        let diffs = Calendar.current.dateComponents([.day], from: date1, to: date2)
        let days = diffs.day ?? 0
        
        if days == 1 {
            return String(days) +  " day ago"
        }
        return String(days) + " days ago"
    }
    func attemptReload() {
        user.reload() {
            
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(user: GetUser(), plants: Plants())
    }
}

struct PullToRefresh: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                } else {
                    Text("⬇️")
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}
