//
//  Home.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//
import SwiftUI
import URLImage

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    
    //nav bar values
    static let plusImageSize = screenWidth / 12
    static let titleSize = screenWidth / 16
    
    //home values
    static let homeImageSize = screenWidth / 4 //base is 80 (ipod 7gen)
    static let homePicSize = screenWidth / 4 //base is 80 (ipod 7gen)
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
    
    //add edit value
    static let imageSelection = screenWidth / 3

}

struct Home: View {
    @ObservedObject var user: GetUser
    @ObservedObject var plants: Plants
    
    init (user : GetUser, plants: Plants){
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: UIScreen.titleSize),
            .foregroundColor: UIColor.white,
        ]
        UINavigationBar.appearance().barTintColor = UIColor(red: 41.0/255.0, green: 110.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = attributes
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
    @State var potSelected = Pot(plantName: "", plantType: "", idealTempHigh: 0, idealTempLow: 0, idealMoistureHigh: 0, idealMoistureLow: 0, idealLightHigh: 0, idealLightLow: 0, lastWatered: Date(), records: [], notifications: [], resLevel: 0, curTemp: 0, curLight: 0, curMoisture: 0, id: "", automaticWatering: false, image: "")
    @State var showingDetail = false
    
    //temperary date formatting
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, hh:mm a"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                if(user.pots.count == 0) {
                    ScrollView {
                        PullToRefresh(coordinateSpaceName: "pull") {
                            attemptReload()
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
                                    .frame(width: UIScreen.plusImageSize, height: UIScreen.plusImageSize)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            }.sheet(isPresented: $showingDetail) {
                                AddPlantPage(user: user, plants: plants, showModal: $showingDetail)
                            })
                    }.coordinateSpace(name: "pull")
                } else {                        
                    ScrollView {
                        PullToRefresh(coordinateSpaceName: "pullRefresh") {
                            attemptReload()
                        }
                        ForEach(user.pots) {
                            pot in
                            NavigationLink(destination: PlantPage(user: user, pot: pot, plants: plants)) {
                                VStack (spacing: 0){
                                    HStack(){
                                        if (URL(string: pot.image) != nil){
                                            URLImage(url: URL(string: pot.image)!) { image in
                                                VStack {
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .clipShape(Circle())
                                                        
                                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                                        .shadow(radius: 10)
                                                }
                                                .font(.system(size: UIScreen.homeImageSize))
                                            }
                                        }
                                        else {
                                            Image(systemName: "leaf.fill")
                                                .font(.system(size: UIScreen.homeImageSize))
                                        }
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
                                        .buttonStyle(HighPriorityButtonStyle())
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
                    }
                    .coordinateSpace(name: "pullRefresh")
                    .allowsHitTesting(!showPopUp)
                    .navigationBarTitle("Hydro Pot", displayMode: .inline)
                    .navigationBarItems(trailing:
                        Button(action: {
                            self.showingDetail.toggle()
                                if (showPopUp == true){
                                    self.showingDetail.toggle()
                                }
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .padding(6)
                                .frame(width: UIScreen.plusImageSize, height: UIScreen.plusImageSize) .clipShape(Circle())
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
            // will be received at the login processed
            if user.loggedIn {
                print("hey")
                for (index, _) in user.pots.enumerated() {
                    let tempPot = user.pots[index]
                    user.pots[index].editPlant(plantName: tempPot.plantName, plantType: tempPot.plantType, idealTempHigh: tempPot.idealTempHigh, idealTempLow: tempPot.idealTempLow, idealMoistureHigh: tempPot.idealMoistureHigh, idealMoistureLow: tempPot.idealMoistureLow, idealLightHigh: tempPot.idealLightHigh, idealLightLow: tempPot.idealLightLow, curLight: tempPot.curLight, curMoisture: tempPot.curMoisture, curTemp: tempPot.curTemp, automaticWatering: tempPot.automaticWatering, lastWatered: tempPot.lastWatered, image: tempPot.image)
                }
            }
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

struct HighPriorityButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
        MyButton(configuration: configuration)
    }
    
    private struct MyButton: View {
        @State var pressed = false
        let configuration: PrimitiveButtonStyle.Configuration
        
        var body: some View {
            let gesture = DragGesture(minimumDistance: 0)
                .onChanged { _ in self.pressed = true }
                .onEnded { value in
                    self.pressed = false
                    if value.translation.width < 10 && value.translation.height < 10 {
                        self.configuration.trigger()
                    }
                }
            
            return configuration.label
                .opacity(self.pressed ? 0.5 : 1.0)
                .highPriorityGesture(gesture)
        }
    }
}

struct StaticHighPriorityButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
        let gesture = TapGesture()
            .onEnded { _ in configuration.trigger() }
        
        return configuration.label
            .highPriorityGesture(gesture)
    }
}
