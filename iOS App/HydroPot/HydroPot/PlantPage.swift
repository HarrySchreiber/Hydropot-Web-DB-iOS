//
//  PlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct PlantPage: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var user: GetUser
    @ObservedObject var pot: Pot
    @ObservedObject var plants: Plants
    @State var screenChange = false
    @State var showingDetail = false
    @State var autoWatering = false {
        didSet{
            pot.automaticWatering = autoWatering
            user.editPot(pot: pot)
        }
    }
    @State private var showPopUp = false
    @State var moistureGood = false //(pot.curMoisture > pot.idealMoistureLow && pot.curMoisture < pot.idealMoistureHigh)
    @State var lightGood = true
    @State var tempGood = true
    @State var resGood = true
    @State var done = true
    
    var body: some View {
        
        let bind = Binding<Bool>(
            get:{self.autoWatering},
            set:{self.autoWatering = $0}
        )
        
        ZStack {
            ScrollView {
                PullToRefresh(coordinateSpaceName: "pullToRefresh") {
                    attemptReload()
                }
                    
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "photo")
                            .font(.system(size: UIScreen.homeImageSize))
                            .foregroundColor(.black)
                            .padding(.leading, 5)
                        VStack(alignment: .leading){
                            Text(pot.plantName)
                                .font(.system(size: UIScreen.titleTextSize))
                                .bold()
                            Text(pot.plantType)
                        }
                    }
                    HStack() {
                        Text("Last watered: \n\(getLastWatered(pot: pot))")
                            .font(.system(size: UIScreen.regTextSize))
                            .frame(maxWidth: UIScreen.plantBoxWidth)
                            .padding(.trailing, 15)
                        Button("Water Plant") {
                            showPopUp = true
                        }
                        .font(.system(size: UIScreen.regTextSize))
                        .buttonStyle(BorderlessButtonStyle())
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                        .cornerRadius(6)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.top, .bottom, .trailing])
                    .border(Color.gray, width: 1.25)
                    .padding([.leading, .bottom, .trailing])
                    
                    Toggle(isOn: bind) {
                        Text("Automatic Water")
                            .font(.system(size: UIScreen.regTextSize))
                            .padding(.leading)
                    }.toggleStyle(SwitchToggleStyle(tint: ((Color(red: 24/255, green: 57/255, blue: 163/255)))))
                    .frame(maxWidth: UIScreen.plantBoxWidth)
                    .padding([.top, .bottom, .trailing])
                    .border(Color.gray, width: 1.25)
                    .padding([.leading, .bottom, .trailing])
        
                    //soil moisture
                    NavigationLink(destination: HistoricalData(pot: pot, tuples: pot.getValues(unit: "Hourly"))) {
                        HStack {
                            VStack{
                                HStack {
                                    Text("Soil Moisture")
                                        .font(.system(size: UIScreen.regTextSize))
                                        .frame(maxWidth: UIScreen.plantBoxWidth)
                                        .foregroundColor(.black)
                                    Text("\(pot.curMoisture)%")
                                        .font(.system(size: UIScreen.titleTextSize))
                                        .bold()
                                        .frame(maxWidth: UIScreen.plantBoxWidth)
                                        .foregroundColor(getTextColor(bool: moistureGood))
                                        .padding(.leading, 45)
                                }
                                Text("Ideal: \(pot.idealMoistureLow)% - \(pot.idealMoistureHigh)%")
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(.leading, 100)
                                    .frame(maxWidth: UIScreen.plantBoxWidth)
                                    .foregroundColor(.black)
                            }
                            Image(systemName: "chevron.right")
                                .font(.system(size: UIScreen.title3TextSize))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: UIScreen.plantBoxWidth)
                        .padding([.top, .bottom])
                        .padding([.leading, .trailing], 5)
                        .border(Color.gray, width: 1.25)
                        .padding([.leading, .bottom, .trailing])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    //light level
                    NavigationLink(destination: HistoricalData(pot: pot, tuples: pot.getValues(unit: "Hourly"))) {
                        ZStack {
                            Text("Light Level")
                                .font(.system(size: UIScreen.title3TextSize))
                                .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .leading)
                                .foregroundColor(.black)
                                .padding(.leading, UIScreen.plantTitleSide)
                                .padding(.bottom, UIScreen.plantTitleBottom)
                            VStack (alignment: .trailing) {
                                    Text("\(pot.curLight)lm")
                                        .font(.system(size: UIScreen.titleTextSize))
                                        .bold()
                                        .foregroundColor(getTextColor(bool: lightGood))
                                    Text("Ideal: \(pot.idealLightLow)lm - \(pot.idealLightHigh)lm")
                                        .font(.system(size: UIScreen.regTextSize))
                                        .foregroundColor(.gray)
                            }
                            .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .trailing)
                            .padding(.trailing, UIScreen.plantBoxIdealsDistance)
                            Image(systemName: "chevron.right")
                                .font(.system(size: UIScreen.title3TextSize))
                                .foregroundColor(.gray)
                                .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .trailing)
                                .padding(.trailing)
                        }
                        .frame(maxWidth: UIScreen.plantBoxWidth)
                        .border(Color.gray, width: 1.25)
                        .padding([.leading, .bottom, .trailing])
                    }
                    
                    //temperature
                    NavigationLink(destination: HistoricalData(pot: pot, tuples: pot.getValues(unit: "Hourly"))) {
                        HStack {
                            VStack{
                                HStack {
                                    Text("Temperature")
                                        .font(.system(size: UIScreen.regTextSize))
                                        .frame(maxWidth: UIScreen.plantBoxWidth)
                                        .foregroundColor(.black)
                                    Text("\(pot.curTemp)°F")
                                        .font(.system(size: UIScreen.titleTextSize))
                                        .bold()
                                        .frame(maxWidth: UIScreen.plantBoxWidth)
                                        .foregroundColor(getTextColor(bool: tempGood))
                                        .padding(.leading, 35)
                                }
                                Text("Ideal: \(pot.idealTempLow)°F - \(pot.idealTempHigh)°F")
                                    .font(.system(size: UIScreen.regTextSize))
                                    .padding(.leading, 90)
                                    .frame(maxWidth: UIScreen.plantBoxWidth)
                                    .foregroundColor(.black)
                            }
                            Image(systemName: "chevron.right")
                                .font(.system(size: UIScreen.title3TextSize))
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: UIScreen.plantBoxWidth)
                        .padding([.top, .bottom])
                        .padding([.leading, .trailing], 5)
                        .border(Color.gray, width: 1.25)
                        .padding([.leading, .bottom, .trailing])
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    HStack {
                        Text("Reservoir Level")
                            .font(.system(size: UIScreen.regTextSize))
                            .frame(maxWidth: UIScreen.plantBoxWidth)
                            .foregroundColor(.black)
                        Text("\(pot.resLevel)%")
                            .font(.system(size: UIScreen.titleTextSize))
                            .bold()
                            .frame(maxWidth: UIScreen.plantBoxWidth)
                            .foregroundColor(getTextColor(bool: resGood))
                            .padding(.leading, 45)
                        
                    }
                    .frame(maxWidth: UIScreen.plantBoxWidth)
                    //.padding([.top, .bottom])
                    .padding( 5)
                    .border(Color.gray, width: 1.25)
                    .padding([.leading, .bottom, .trailing])
                    .fixedSize(horizontal: false, vertical: true)
                }
            }
            //end scroll view
            .allowsHitTesting(!showPopUp)
            .coordinateSpace(name: "pullToRefresh")
            .navigationBarItems(trailing:
                    Button(action: {
                        if (showPopUp != true){
                            self.showingDetail.toggle()
                        }
                    }) {
                        Text("Edit")
                            .padding(6)
                            .foregroundColor(.white)
                    }.sheet(isPresented: $showingDetail) {
                        EditPlantPage(user: user, plants: plants, pot: pot, showModal: $showingDetail, moistureGood: $moistureGood, lightGood: $lightGood, tempGood: $tempGood, resGood: $resGood)
                    })
            if $showPopUp.wrappedValue { 
                waterModal(showPopUp: $showPopUp, pot: pot, user: user)
            }
            }.onAppear {
                moistureGood = ((pot.curMoisture >= pot.idealMoistureLow) && (pot.curMoisture <= pot.idealMoistureHigh))
                lightGood = (pot.curLight >= pot.idealLightLow && pot.curLight <= pot.idealLightHigh)
                tempGood = (pot.curTemp >= pot.idealTempLow && pot.curTemp <= pot.idealTempHigh)
                autoWatering = pot.automaticWatering
                resGood = pot.resLevel > 20
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
    
    func getTextColor(bool: Bool) -> Color{
        if(bool) {
            return Color(red: 41.0/255.0, green: 110.0/255.0, blue: 25.0/255.0)
        }
        return Color.red
    }
    
    func attemptReload() {
        user.reload() {
            // will be received at the login processed
            if user.loggedIn {
                for (index, _) in user.pots.enumerated() {
                    if (user.pots[index].id == pot.id){
                        let tempPot = user.pots[index]
                        pot.editPlant(plantName: tempPot.plantName, plantType: tempPot.plantType, idealTempHigh: tempPot.idealTempHigh, idealTempLow: tempPot.idealTempLow, idealMoistureHigh: tempPot.idealMoistureHigh, idealMoistureLow: tempPot.idealMoistureLow, idealLightHigh: tempPot.idealLightHigh, idealLightLow: tempPot.idealLightLow, curLight: tempPot.curLight, curMoisture: tempPot.curMoisture, curTemp: tempPot.curTemp, automaticWatering: tempPot.automaticWatering, lastWatered: tempPot.lastWatered)
                        
                        moistureGood = ((pot.curMoisture >= pot.idealMoistureLow) && (pot.curMoisture <= pot.idealMoistureHigh))
                        lightGood = (pot.curLight >= pot.idealLightLow && pot.curLight <= pot.idealLightHigh)
                        tempGood = (pot.curTemp >= pot.idealTempLow && pot.curTemp <= pot.idealTempHigh)
                        autoWatering = pot.automaticWatering
                        resGood = pot.resLevel > 20
                    }
                }
            }
        }
    }
}
