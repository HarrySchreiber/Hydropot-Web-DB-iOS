//
//  PlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI
import URLImage

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
    @State var moistureGood = false
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
                    HStack (){
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
                                .frame(width: UIScreen.plantImage, height:  UIScreen.plantImage)
                            }
                        }
                        else {
                            Image(systemName: "leaf.fill")
                                .font(.system(size: UIScreen.homeImageSize))
                        }
                        VStack(alignment: .leading){
                            Text(pot.plantName)
                                .font(.system(size: UIScreen.titleTextSize))
                                .bold()
                            Text(pot.plantType)
                                .font(.system(size: UIScreen.regTextSize))
                        }
                    }
                    
                    ZStack {
                        Text("Last watered: \n\(getLastWatered(pot: pot))")                            .font(.system(size: UIScreen.regTextSize))
                            .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .leading)
                            .foregroundColor(.black)
                            .padding(.leading, UIScreen.plantTitleSide)
                        Button("Water Plant") {
                            showPopUp = true
                        }
                        .font(.system(size: UIScreen.regTextSize))
                        .buttonStyle(BorderlessButtonStyle())
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                        .cornerRadius(6)
                        .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .trailing)
                        .padding(.trailing, UIScreen.plantTitleSide)
                    }
                    .frame(maxWidth: UIScreen.plantBoxWidth)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(6)
                    .padding([.leading, .bottom, .trailing])
                    
                    Toggle(isOn: bind) {
                        Text("Automatic Water")
                            .font(.system(size: UIScreen.regTextSize))
                            .padding(.leading, UIScreen.plantTitleSide/2)
                    }.toggleStyle(SwitchToggleStyle(tint: ((Color(red: 24/255, green: 57/255, blue: 163/255)))))
                    .frame(maxWidth: UIScreen.plantBoxWidth)
                    .padding(.trailing, UIScreen.plantTitleSide/2)
                    .padding([.top, .bottom])
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(6)
                    .padding([.leading, .bottom, .trailing])
                    
                    //soil moisture
                    NavigationLink(destination: HistoricalData(pot: pot, tuples: pot.getValues(unit: "Hourly"))) {
                        ZStack {
                            Text("Soil Moisture")
                                .font(.system(size: UIScreen.title3TextSize))
                                .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .leading)
                                .foregroundColor(.black)
                                .padding(.leading, UIScreen.plantTitleSide)
                                .padding(.bottom, UIScreen.plantTitleBottom)
                            VStack (alignment: .trailing) {
                                Text("\(pot.curMoisture)%")                                        .font(.system(size: UIScreen.titleTextSize))
                                    .bold()
                                    .foregroundColor(getTextColor(bool: moistureGood))
                                Text("Ideal: \(pot.idealMoistureLow)% - \(pot.idealMoistureHigh)%")
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
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(6)
                        .padding([.leading, .bottom, .trailing])
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
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(6)
                        .padding([.leading, .bottom, .trailing])
                    }
                    
                    //temperature
                    NavigationLink(destination: HistoricalData(pot: pot, tuples: pot.getValues(unit: "Hourly"))) {
                        ZStack {
                            Text("Temperature")
                                .font(.system(size: UIScreen.title3TextSize))
                                .frame(width: UIScreen.plantBoxWidth, height: UIScreen.plantBoxHeight, alignment: .leading)
                                .foregroundColor(.black)
                                .padding(.leading, UIScreen.plantTitleSide)
                                .padding(.bottom, UIScreen.plantTitleBottom)
                            VStack (alignment: .trailing) {
                                Text("\(pot.curTemp)°F")
                                    .font(.system(size: UIScreen.titleTextSize))
                                    .bold()
                                    .foregroundColor(getTextColor(bool: tempGood))
                                Text("Ideal: \(pot.idealTempLow)°F - \(pot.idealTempHigh)°F")
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
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(6)
                        .padding([.leading, .bottom, .trailing])
                    }
                    ZStack {
                        Text("Reservoir Level")
                            .font(.system(size: UIScreen.title3TextSize))
                            .frame(width: UIScreen.plantBoxWidth, height: UIScreen.title3TextSize * 3, alignment: .leading)
                            .foregroundColor(.black)
                            .padding(.leading, UIScreen.plantTitleSide)
                        Text("\(pot.resLevel)%")
                            .font(.system(size: UIScreen.titleTextSize))
                            .foregroundColor(getTextColor(bool: resGood))
                            .bold()
                            .foregroundColor(getTextColor(bool: resGood))
                            .frame(width: UIScreen.plantBoxWidth, height: UIScreen.title3TextSize * 3, alignment: .trailing)
                            .padding(.trailing, UIScreen.resLevelPadding)
                    }
                    .frame(maxWidth: UIScreen.plantBoxWidth)
                    .background(Color.white.opacity(0.85))
                    .cornerRadius(6)
                    .padding([.leading, .bottom, .trailing])
                }
            }
            //end scroll view
            .allowsHitTesting(!showPopUp)
            .coordinateSpace(name: "pullToRefresh")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: UIScreen.title3TextSize))
                            .frame(width: UIScreen.chevImage, height: UIScreen.chevImage)
                            .foregroundColor(.white)
                        Text("Back")
                            .font(.system(size: UIScreen.regTextSize))
                    }
                }, trailing:
                Button(action: {
                    if (showPopUp != true){
                        self.showingDetail.toggle()
                    }
                }) {
                    Text("Edit")
                        .font(.system(size: UIScreen.regTextSize))
                        .padding(6)
                        .foregroundColor(.white)
                }.sheet(isPresented: $showingDetail) {
                    EditPlantPage(user: user, plants: plants, pot: pot, showModal: $showingDetail, moistureGood: $moistureGood, lightGood: $lightGood, tempGood: $tempGood, resGood: $resGood)
                })
            if $showPopUp.wrappedValue { 
                waterModal(showPopUp: $showPopUp, pot: pot, user: user)
            }
        }.onAppear {
            attemptReload()
            moistureGood = ((pot.curMoisture >= pot.idealMoistureLow) && (pot.curMoisture <= pot.idealMoistureHigh))
            lightGood = (pot.curLight >= pot.idealLightLow && pot.curLight <= pot.idealLightHigh)
            tempGood = (pot.curTemp >= pot.idealTempLow && pot.curTemp <= pot.idealTempHigh)
            autoWatering = pot.automaticWatering
            resGood = pot.resLevel > 20
        }
        .background(
            Image("plant2")
                .resizable()
                .opacity(0.50)
        )
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
                        pot.editPlant(plantName: tempPot.plantName, plantType: tempPot.plantType, idealTempHigh: tempPot.idealTempHigh, idealTempLow: tempPot.idealTempLow, idealMoistureHigh: tempPot.idealMoistureHigh, idealMoistureLow: tempPot.idealMoistureLow, idealLightHigh: tempPot.idealLightHigh, idealLightLow: tempPot.idealLightLow, curLight: tempPot.curLight, curMoisture: tempPot.curMoisture, curTemp: tempPot.curTemp, automaticWatering: tempPot.automaticWatering, lastWatered: tempPot.lastWatered, image: tempPot.image)
                        
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
