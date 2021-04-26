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
    static let chevImage = screenWidth / 26
    
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
    static let textSize = screenWidth * 0.18
    static let loginTextBoxSize = screenWidth * 0.68
    
    //plant type page values
    static let titleTextSize = screenWidth / 11.4  //base is 28
    static let plantTypeImageSize = screenWidth / 1 //base is 200
    
    //plant list page values
    static let plantTypeListImageSize = screenWidth / 4
    static let searchPadding = screenWidth / 320
    
    //historical Data page values
    static let title3TextSize = screenWidth / 16  //base is 20
    static let zStackWidth = modalWidth - (screenWidth / 10) //base is about 270
    static let zStackHeight = screenWidth / 2.13  //base is 150
    static let panelWidth = screenWidth
    static let panelHeight = screenWidth / 1.4 //base is 225
    static let graphWidth = screenWidth / 16 // base is 20
    static let textOffset = screenWidth / 9.14 //base is 30
    static let lightTextOffset = textOffset * 1.25
    static let graphTextLen = screenWidth / 133 // base is 2.4
    static let graphMultiplier = screenWidth / 22.9 //base is 14
    static let graphPadding = screenWidth / 64 //base is 5
    
    //add edit values
    static let imageSelection = screenWidth / 3
    static let addPhotoPadding = screenWidth / 100
    static let textBoxWidth = screenWidth * 0.88
    static let textBoxHeight = screenWidth / 8
    static let idealsTextWidth = screenWidth * 0.325
    static let idealsValuesWidth = screenWidth * 0.22
    static let idealsValuesHeight = screenWidth / 8
    static let dashSize = screenWidth * 0.02
    static let resFont = screenWidth / 18.8 * 0.72
    static let cheveronSize = screenWidth * 0.8
    static let padding = screenWidth/60
    
    //plant page values
    static let plantBoxWidth = screenWidth / 1.06 //base is 300
    static let plantBoxHeight = homeImageSize
    static let plantButtonWidth = screenWidth / 2 //base is 300
    static let plantButtonHeight = homeImageSize / 2
    static let plantBoxIdealsDistance = screenWidth / 5.4 //base is 60
    static let plantTitleBottom = screenWidth / 16 //base is 20
    static let plantTitleSide = screenWidth / 10.6 //base is 30
    static let resLevelPadding = screenWidth / 5.5  //base is ~57
    static let plantImage = screenWidth / 2
    
    
}

/*
    view for home tab bar
 */
struct Home: View {
    @ObservedObject var user: GetUser //user observed obj
    @ObservedObject var plants: Plants //plant list observed obj
    
    //default values for styling ui elements
    init (user : GetUser, plants: Plants){
        //ui size
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: UIScreen.title3TextSize),
            .foregroundColor: UIColor.white,
        ]
        //ui nav bar appearance changed
        UINavigationBar.appearance().barTintColor = UIColor(red: 41.0/255.0, green: 110.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = attributes
        //assign out observed objects values
        self.user = user
        self.plants = plants
    }
    var body: some View {
        //tab view for going through our main pages
        TabView() {
            //home page
            HomeView(user: user, plants: plants).tabItem {
                //image for tab item
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                Text("Home")
            }.tag(1)
            //plant page
            PlantTypeList(plants: self.plants).tabItem {
                //image for tab item
                Image(systemName: "magnifyingglass")
                Text("Plant Type")
            }.tag(2)
            //notifications page
            NotificationsPage(user: user, plants: plants).tabItem {
                //image for tab item
                Image(systemName: "bell.fill")
                Text("Notifications")
            }.tag(3)
            //account page
            AccountPage(user: user).tabItem {
                //image for tab item
                Image(systemName: "person.crop.circle.fill")
                Text("Account")
            }.tag(4)
        }
        //styling of tab bar
        .accentColor(.black)
    }
}

/*
    view for homepage
 */
struct HomeView: View {
    @ObservedObject var user: GetUser //user already made
    @ObservedObject var plants: Plants //plant list already made
    @State private var showPopUp = false //allows add plants modal to pop up
    //default pot for the user to select
    @State var potSelected = Pot(plantName: "", plantType: "", idealTempHigh: 0, idealTempLow: 0, idealMoistureHigh: 0, idealMoistureLow: 0, idealLightHigh: 0, idealLightLow: 0, lastWatered: Date(), records: [], notifications: [], curTemp: 0, curLight: 0, curMoisture: 0, id: "", automaticWatering: false, image: "", potId: "", lastFilled: Date(), notiFilledFrequency: 2)
    //toggled to change add plants modal
    @State var showingDetail = false
    
    //date formating
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM y, hh:mm a"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                //if the user has no plants
                if(user.pots.count == 0) {
                    //scroll view for updated
                    ScrollView {
                        PullToRefresh(coordinateSpaceName: "pull") {
                            //reload
                            attemptReload()
                        }
                        //tell the user they don't have plants
                        Text("You have no plants added.\nTry adding a plant by selecting the plus icon in the top right")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .bold()
                            .italic()
                            .padding()
                            .foregroundColor(.gray)
                            .navigationBarTitle("Hydro Pot", displayMode: .inline)
                            //nav bar item (only contains add plants button)
                            .navigationBarItems(trailing:
                            Button(action: {
                                //toggles the add plant modal
                                self.showingDetail.toggle()
                            }) {
                                //image for adding
                                Image(systemName: "plus")
                                    //styling
                                    .resizable()
                                    .padding(6)
                                    .frame(width: UIScreen.plusImageSize, height: UIScreen.plusImageSize)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                            //if we have toggled the add plants button
                            }.sheet(isPresented: $showingDetail) {
                                //present modal
                                AddPlantPage(user: user, plants: plants, showModal: $showingDetail)
                            })
                    }.coordinateSpace(name: "pull")
                }
                //if the user has more than 0 plants
                else {
                    //scroll view for updates
                    ScrollView {
                        //allows db updates for plants
                        PullToRefresh(coordinateSpaceName: "pullRefresh") {
                            attemptReload()
                        }
                        //for every pot the user has
                        ForEach(user.pots) {
                            pot in
                            //creating ideals to pass
                            let ideals = Ideals(idealTemperatureHigh: String(pot.idealTempHigh), idealTemperatureLow: String(pot.idealTempLow), idealMoistureHigh: String(pot.idealMoistureHigh), idealMoistureLow: String(pot.idealMoistureLow), idealLightLevelLow: String(pot.idealLightLow), idealLightLevelHigh: String(pot.idealLightHigh), plantName: pot.plantName, plantSelected: pot.plantType, notificationFrequency: pot.notiFilledFrequency)
                            //nav link to plant page for each pot
                            NavigationLink(destination: PlantPage(user: user, pot: pot, plants: plants, ideals: ideals)) {
                                VStack (spacing: 0){
                                    //image stack
                                    HStack(){
                                        //if we have a db image
                                        if (URL(string: pot.image) != nil){
                                            //make the image from the s3 url
                                            URLImage(url: URL(string: pot.image)!) { image in
                                                //other stack for image
                                                VStack {
                                                    image
                                                        //styling for image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .clipShape(Circle())
                                                        .shadow(radius: 10)
                                                }
                                                //set frame of the image
                                                .frame(width: UIScreen.homeImageSize, height:  UIScreen.homeImageSize)
                                            }
                                        }
                                        //if we don't have a db image
                                        else {
                                            VStack {
                                                //default leaf image
                                                Image(systemName: "leaf.fill")
                                                    //styling for image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Circle())
                                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                                    .shadow(radius: 10)
                                            }
                                            //set frame of the image
                                            .frame(width: UIScreen.homeImageSize, height:  UIScreen.homeImageSize)
                                        }
                                        //plant name and temp stack
                                        VStack(alignment: .leading) {
                                            //name
                                            Text(pot.plantName)
                                                //styling
                                                .fontWeight(.bold)
                                                .font(.system(size: UIScreen.title2TextSize))
                                            //temp
                                            Text("Temperature: \(pot.curTemp)°F")
                                                //styling
                                                .font(.system(size: UIScreen.subTextSize))
                                                .foregroundColor(getTextColor(bool: pot.tempGood))
                                        }
                                        .padding(.leading)
                                    }
                                    //stack for last watered and water button
                                    HStack() {
                                        //last watered from function
                                        Text("Last watered: \n\(pot.lastWateredDays)")
                                            //styling
                                            .padding(.top, 2)
                                            .frame(maxWidth: UIScreen.lastWateredSize)
                                            .font(.system(size: UIScreen.regTextSize))
                                        //water plant button
                                        Button("Water Plant") {
                                            //show the pop up to water the plant
                                            potSelected = pot
                                            showPopUp = true
                                        }
                                        //styling (high prio because of nav link)
                                        .buttonStyle(HighPriorityButtonStyle())
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                                        .cornerRadius(6)
                                        .font(.system(size: UIScreen.regTextSize))
                                    }
                                }
                                //styling
                                .foregroundColor(.black)
                                .padding(20)
                                .background(Color.white)
                                .cornerRadius(6)
                                .padding([.leading, .top, .trailing],UIScreen.homeCardsSize)
                            }
                        }
                    }
                    //styling and aspects for the home view
                    .coordinateSpace(name: "pullRefresh")
                    .allowsHitTesting(!showPopUp)
                    .navigationBarTitle("Hydro Pot", displayMode: .inline)
                    //button for nav bar
                    .navigationBarItems(trailing:
                        Button(action: {
                            //add plant pressed so toggle modal
                            self.showingDetail.toggle()
                                if (showPopUp == true){
                                    //display add plant page
                                    self.showingDetail.toggle()
                                }
                        }) {
                            //image is plus for adding
                            Image(systemName: "plus")
                                //styling
                                .resizable()
                                .padding(6)
                                .frame(width: UIScreen.plusImageSize, height: UIScreen.plusImageSize) .clipShape(Circle())
                                .foregroundColor(.white)
                        }.sheet(isPresented: $showingDetail) {
                            //present the add plant modal
                            AddPlantPage(user: user, plants: plants, showModal: $showingDetail)
                        })
                }
                //if watering was pressed display watering modal
                if $showPopUp.wrappedValue {
                    waterModal(showPopUp: $showPopUp, pot: potSelected, user: user)
                }
            }
            //background image for the home page
            .background(
                Image("plant2")
                    .resizable()
                    .opacity(0.50)
            )
            //when page is presented
            .onAppear(){
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
                    attemptReload()
                }
            }
            .onAppear(){
                //if we are not on a simulator
                if (user.deviceToken != ""){
                    //change the device token to the current device (for notifications
                    user.changeDeviceToken()
                }
            }
        }
    }
    
    /// callback for the login functon designed to reload data dynamically
    /// without altering the user experience
    func attemptReload() {
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
            attemptReload()
        }
    }
    
    /// function to encode jpeg images
    ///
    /// - Parameters:
    ///     - bool: if supposed to be red or green
    ///
    /// - Returns:
    ///     the correct color of the text
    func getTextColor(bool: Bool) -> Color{
        //if we are supposed to be green
        if(bool) {
            //return green
            return Color(red: 41.0/255.0, green: 110.0/255.0, blue: 25.0/255.0)
        }
        //return red
        return Color.red
    }
    
}

/*
 previewer
 */
struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(user: GetUser(), plants: Plants())
    }
}

/*
 struct to allows for pulldown functionality
 */
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

/*
 button style for high priority buttons
 */
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

/*
 allows for priority on nested buttons
 */
struct StaticHighPriorityButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: PrimitiveButtonStyle.Configuration) -> some View {
        let gesture = TapGesture()
            .onEnded { _ in configuration.trigger() }
        
        return configuration.label
            .highPriorityGesture(gesture)
    }
}
