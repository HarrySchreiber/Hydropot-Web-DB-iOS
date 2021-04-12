//
//  PlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI
import URLImage

/*
    page to display the pot
 */
struct PlantPage: View {
    @Environment(\.presentationMode) var presentationMode //mode to be dismissed
    @ObservedObject var user: GetUser //user to be passed into
    @ObservedObject var pot: Pot //pot that is displayed
    @ObservedObject var plants: Plants //plant type list
    @ObservedObject var ideals: Ideals
    @State var screenChange = false //toggle thing
    @State var showingDetail = false //toggle thing
    //on set
    @State var autoWatering = false {
        didSet{
            //change client side auto
            pot.automaticWatering = autoWatering
            //edit server side
            user.editPot(pot: pot)
        }
    }
    
    @State private var showPopUp = false //toggle boi
    
    //historical data values
    @State var moistureGraphArrays : (hourly: [Int], daily: [Int], weekly: [Int]) = ([],[],[])  //arrays for moisture (hourly, daily, weekly)
    @State var lightGraphArrays : (hourly: [Int], daily: [Int], weekly: [Int]) = ([],[],[])  //arrays for light (hourly, daily, weekly)
    @State var tempGraphArrays : (hourly: [Int], daily: [Int], weekly: [Int]) = ([],[],[])  //arrays for temperature (hourly, daily, weekly)

    var body: some View {
        //sent to another page
        let bind = Binding<Bool>(
            //getting it
            get:{self.autoWatering},
            //setting it
            set:{self.autoWatering = $0}
        )
        
        ZStack {
            //pull down for refresh
            ScrollView {
                //refresh
                PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                    attemptReload()
                }
                
                VStack(alignment: .leading) {
                    HStack (){
                        //image to present to user
                        if (URL(string: pot.image) != nil){
                            URLImage(url: URL(string: pot.image)!) { image in
                                VStack {
                                    //image
                                    image
                                        //styling
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                        .shadow(radius: 10)
                                }
                                //styling
                                .frame(width: UIScreen.plantImage, height:  UIScreen.plantImage)
                            }
                        }
                        //if we don't have an image
                        else {
                            VStack {
                                //default image
                                Image(systemName: "leaf.fill")
                                    //styling
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 10)
                            }
                            //styling
                            .frame(width: UIScreen.plantImage, height:  UIScreen.plantImage)
                        }
                        VStack(alignment: .leading){
                            //text of the pot name
                            Text(pot.plantName)
                                //styling
                                .font(.system(size: UIScreen.titleTextSize))
                                .bold()
                            //pot type
                            Text(pot.plantType)
                                //styling
                                .font(.system(size: UIScreen.regTextSize))
                        }
                    }
                    ZStack {
                        //last watered in days ago
                        Text("Last watered: \n\(pot.lastWateredDays)")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .leading)
                            .foregroundColor(.black)
                            .padding(.leading, UIScreen.plantTitleSide)
                        //water plant button modal
                        Button("Water Plant") {
                            //showing modal
                            showPopUp = true
                        }
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .buttonStyle(BorderlessButtonStyle())
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                        .cornerRadius(6)
                        .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .trailing)
                        .padding(.trailing, UIScreen.plantTitleSide)
                    }
                    //styling
                    .frame(maxWidth: UIScreen.plantBoxWidth)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(6)
                    .padding([.leading, .bottom, .trailing])
                    
                    ZStack {
                        //last watered in days ago
                        Text("Last Filled: \n\(pot.lastFilledDays)")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .leading)
                            .foregroundColor(.black)
                            .padding(.leading, UIScreen.plantTitleSide)
                        //filled res button modal
                        Button("Filled Water") {
                            //set the last filled
                            pot.setLastFilled(lastFilled: Date())
                            //showing modal
                            user.editPot(pot: pot)
                        }
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .buttonStyle(BorderlessButtonStyle())
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                        .cornerRadius(6)
                        .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .trailing)
                        .padding(.trailing, UIScreen.plantTitleSide)
                    }
                    //styling
                    .frame(maxWidth: UIScreen.plantBoxWidth)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(6)
                    .padding([.leading, .bottom, .trailing])
                    
                    //automatic water toggle
                    Toggle(isOn: bind) {
                        //text of toggle button
                        Text("Automatic Water")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .padding(.leading, UIScreen.plantTitleSide/2)
                    }
                    //styling
                    .toggleStyle(SwitchToggleStyle(tint: ((Color(red: 24/255, green: 57/255, blue: 163/255)))))
                    .frame(maxWidth: UIScreen.plantBoxWidth)
                    .padding(.trailing, UIScreen.plantTitleSide/2)
                    .padding([.top, .bottom])
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(6)
                    .padding([.leading, .bottom, .trailing])
                    
                    //soil moisture nav link to historical page
                    NavigationLink(destination: HistoricalData(pot: pot, tuples: pot.getValues(unit: "Hourly"), moistureGraphArrays: moistureGraphArrays, lightGraphArrays: lightGraphArrays, tempGraphArrays: tempGraphArrays)) {
                        ZStack {
                            //soil moisture text
                            Text("Soil Moisture")
                                //styling
                                .font(.system(size: UIScreen.title3TextSize))
                                .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .leading)
                                .foregroundColor(.black)
                                .padding(.leading, UIScreen.plantTitleSide)
                                .padding(.bottom, UIScreen.plantTitleBottom)
                            VStack (alignment: .trailing) {
                                //display current pot's moisture
                                Text("\(pot.curMoisture)%")
                                    //styling
                                    .font(.system(size: UIScreen.titleTextSize))
                                    .bold()
                                    .foregroundColor(getTextColor(bool: pot.moistureGood))
                                //display ideals for moisture
                                Text("Ideal: \(pot.idealMoistureLow)% - \(pot.idealMoistureHigh)%")
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .foregroundColor(.gray)
                            }
                            //styling
                            .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .trailing)
                            .padding(.trailing, UIScreen.plantBoxIdealsDistance)
                            //chevron for knowing to clic
                            Image(systemName: "chevron.right")
                                //styling
                                .font(.system(size: UIScreen.title3TextSize))
                                .foregroundColor(.gray)
                                .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .trailing)
                                .padding(.trailing)
                        }
                        //styling
                        .frame(maxWidth: UIScreen.plantBoxWidth)
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(6)
                        .padding([.leading, .bottom, .trailing])
                    }
                    //light level nav link to historical
                    NavigationLink(destination: HistoricalData(pot: pot, tuples: pot.getValues(unit: "Hourly"), moistureGraphArrays: moistureGraphArrays, lightGraphArrays: lightGraphArrays, tempGraphArrays: tempGraphArrays)) {
                        ZStack {
                            //light level text
                            Text("Light Level")
                                //styling
                                .font(.system(size: UIScreen.title3TextSize))
                                .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .leading)
                                .foregroundColor(.black)
                                .padding(.leading, UIScreen.plantTitleSide)
                                .padding(.bottom, UIScreen.plantTitleBottom)
                                //styling
                            VStack (alignment: .trailing) {
                                //current light of pot
                                Text("\(pot.curLight)lm")
                                    //styling
                                    .font(.system(size: UIScreen.titleTextSize))
                                    .bold()
                                    .foregroundColor(getTextColor(bool: pot.lightGood))
                                //ideals for light level of plant type
                                Text("Ideal: \(pot.idealLightLow)lm - \(pot.idealLightHigh)lm")
                                    //styling
                                    .font(.system(size: UIScreen.regTextSize))
                                    .foregroundColor(.gray)
                            }
                            //styling
                            .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .trailing)
                            .padding(.trailing, UIScreen.plantBoxIdealsDistance)
                            //image of chev to click
                            Image(systemName: "chevron.right")
                                //styling
                                .font(.system(size: UIScreen.title3TextSize))
                                .foregroundColor(.gray)
                                .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .trailing)
                                .padding(.trailing)
                        }
                        //styling
                        .frame(maxWidth: UIScreen.plantBoxWidth)
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(6)
                        .padding([.leading, .bottom, .trailing])
                    }
                    //temperature of plant to historical page
                    NavigationLink(destination: HistoricalData(pot: pot, tuples: pot.getValues(unit: "Hourly"), moistureGraphArrays: moistureGraphArrays, lightGraphArrays: lightGraphArrays, tempGraphArrays: tempGraphArrays)) {
                        ZStack {
                            //temperature text
                            Text("Temperature")
                                //styling
                                .font(.system(size: UIScreen.title3TextSize))
                                .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .leading)
                                .foregroundColor(.black)
                                .padding(.leading, UIScreen.plantTitleSide)
                                .padding(.bottom, UIScreen.plantTitleBottom)
                                //styling
                            VStack (alignment: .trailing) {
                                //cur pot value of temp
                                Text("\(pot.curTemp)°F")
                                    //styling
                                    .font(.system(size: UIScreen.titleTextSize))
                                    .bold()
                                    .foregroundColor(getTextColor(bool: pot.tempGood))
                                //ideal for temp of pot
                                Text("Ideal: \(pot.idealTempLow)°F - \(pot.idealTempHigh)°F")
                                    .font(.system(size: UIScreen.regTextSize))
                                    .foregroundColor(.gray)
                            }
                            //styling
                            .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .trailing)
                            .padding(.trailing, UIScreen.plantBoxIdealsDistance)
                            Image(systemName: "chevron.right")
                                .font(.system(size: UIScreen.title3TextSize))
                                .foregroundColor(.gray)
                                .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .trailing)
                                .padding(.trailing)
                        }
                        //styling
                        .frame(maxWidth: UIScreen.plantBoxWidth)
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(6)
                        .padding([.leading, .bottom, .trailing])
                    }
                }
            }
            //end scroll view
            .allowsHitTesting(!showPopUp)
            .coordinateSpace(name: "pullToRefresh")
            .navigationBarItems(trailing:
                Button(action: {
                    //edit button
                    if (showPopUp != true){
                        
                        ideals.editIdeals(idealTemperatureHigh: pot.idealTempHigh, idealTemperatureLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightLevelHigh: pot.idealLightHigh, idealLightLevelLow: pot.idealLightLow, plantName: pot.plantName, plantSelected: pot.plantType, notificationFrequency: pot.notiFilledFrequency)
                        
                        //display edit modal
                        self.showingDetail.toggle()
                    }
                }){
                    //text of button
                    Text("Edit")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                        .padding(6)
                        .foregroundColor(.white)
                }
                //edit plant displayed
                .sheet(isPresented: $showingDetail) {
                    //call edit plant page
                    EditPlantPage(user: user, plants: plants, ideals: ideals, pot: pot, showModal: $showingDetail)
                })
            //if water modal was toggled
            if $showPopUp.wrappedValue {
                //display water modal
                waterModal(showPopUp: $showPopUp, pot: pot, user: user)
            }
        }
        .onAppear {
            ideals.editIdeals(idealTemperatureHigh: pot.idealTempHigh, idealTemperatureLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealMoistureLow, idealLightLevelHigh: pot.idealLightHigh, idealLightLevelLow: pot.idealLightLow, plantName: pot.plantName, plantSelected: pot.plantType, notificationFrequency: pot.notiFilledFrequency)
            
            //auto watering is set
            autoWatering = pot.automaticWatering
            
            //get historical data
            moistureGraphArrays = pot.calculateGraphData(dataType: "moisture")
            lightGraphArrays = pot.calculateGraphData(dataType: "light")
            tempGraphArrays = pot.calculateGraphData(dataType: "temperature")

        }
        .background(
            //background image default
            Image("plant2")
                //styling
                .resizable()
                .opacity(0.50)
        )
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
    
    
    /// functon that reload the data for the user
    ///
    func attemptReload() {
        //do the reload
        user.reload() {
        }
    }
}
