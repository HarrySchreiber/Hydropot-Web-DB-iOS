//
//  Home.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//
import SwiftUI

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    
    //home values
    static let homeImageSize = screenWidth / 4 //base is 80 (ipod 7gen)
    static let regTextSize = screenWidth / 18.8 // base is 17
    static let title2TextSize = screenWidth / 14.5 //base is 22
    static let subTextSize = screenWidth / 24.6  //base is 13
    static let lastWateredSize = screenWidth / 2.56 //base is 125
    static let homeCardsSize = screenWidth / 32 //base is 10
    
    //login values
    static let modalWidth = screenWidth / 1.14 //base is 280
    
    //plant page values
    static let titleTextSize = screenWidth / 11.4  //base is 28
    static let plantTypeImageSize = screenWidth / 1.6 //base is 200
    
    //historical Data page values
    static let title3TextSize = screenWidth / 16  //base is 20
    static let zStackWidth = modalWidth - 10 //base is 270
    static let zStackHeight = screenWidth / 2.13  //base is 150
    static let panelWidth = screenWidth
    static let panelHeight = screenWidth / 1.4 //base is 225

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
        .accentColor(.black)
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
                            .font(.system(size: UIScreen.regTextSize))
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
                    ScrollView {
                        PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                            //attemptReload()
                        }
                        ForEach(user.pots) {
                            pot in
                            NavigationLink(destination: PlantPage(user: user, pot: pot, plants: plants)) {
                                VStack {
                                    HStack(){
                                        Image(systemName: "leaf.fill")
                                            .font(.system(size: UIScreen.homeImageSize))
                                        VStack(alignment: .leading) {
                                            Text(pot.plantName)
                                                .fontWeight(.bold)
                                                .font(.system(size: UIScreen.title2TextSize))
                                            Text("Temperature: \(pot.curTemp)°F")
                                                .font(.system(size: UIScreen.subTextSize))
                                        }
                                        .padding(.leading)
                                    }
                                    HStack() {
                                        Text("Last watered: \n\(getLastWatered(pot: pot))")
                                            .padding(.top, 2)
                                            .frame(maxWidth: UIScreen.lastWateredSize)
                                            .font(.system(size: UIScreen.regTextSize))
                                        Button("Water Plant") {
                                            potSelected = pot
                                            showPopUp = true
                                        }
                                        .buttonStyle(BorderlessButtonStyle())
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                                        .cornerRadius(6)
                                        .font(.system(size: UIScreen.regTextSize))
                                    }
                                }
                                .foregroundColor(.black)
                                .padding(20)
                                .background(Color.white)
                                .cornerRadius(6)
                                .padding([.leading, .top, .trailing],UIScreen.homeCardsSize)
                                
                                //eventually can add custom swipe to delete with this drag gesture?
                                .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                                .onEnded { value in
                                    if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                                        print("left swipe on \(pot.plantName)")
                                    }
                                })
                            }
                        }
                        //.onDelete(perform: user.deletePot)
                    }
                    .allowsHitTesting(!showPopUp)
                    .navigationBarTitle("Hydro Pot", displayMode: .inline)
                    .navigationBarItems(trailing:
                        Button(action: {
                            self.showingDetail.toggle()
                                if (showPopUp != true){
                                self.showingDetail.toggle()
                            }
                        }) {
                            Image(systemName: "plus") .resizable() .padding(6) .frame(width: 30, height: 30) .clipShape(Circle())
                                .foregroundColor(.white)
                        }.sheet(isPresented: $showingDetail) {
                            AddPlantPage(user: user, plants: plants, showModal: $showingDetail)
                        })
                }
                if $showPopUp.wrappedValue {
                    waterModal(showPopUp: $showPopUp, pot: potSelected, user: user)
                }
            }
            .background(
                Image("plant2")
                    .resizable()
                    .opacity(0.50)
            )
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
                    //Image("arrow.down")
                    Text("⬇️")
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}
