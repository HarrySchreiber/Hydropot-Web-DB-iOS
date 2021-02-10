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
    @State var autoWatering = false
    @State private var showPopUp = false
    @State private var threeML = true
    @State private var sixML = false
    @State private var nineML = false
    @State var moistureGood = false//(pot.curMoisture > pot.idealMoistureLow && pot.curMoisture < pot.idealMoistureHigh)
    @State var lightGood = true
    @State var tempGood = true
    
    var body: some View {
        ZStack {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "photo")
                                .font(.system(size: 90))
                                .foregroundColor(.black)
                                .padding(.leading, 5)
                            VStack(alignment: .leading){
                                Text(pot.plantName)
                                    .font(.title)
                                    .bold()
                                Text(pot.plantType)
                            }
                        }
                        HStack() {
                            Text("Last watered: \n\(getLastWatered(pot: pot))")
                                .frame(maxWidth: 300)
                                .padding(.trailing, 15)
                            Button("Water Plant") {
                                showPopUp = true
                            }
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
                        Toggle(isOn: $autoWatering) {
                            Text("Automatic Water").padding(.leading)
                        }.toggleStyle(SwitchToggleStyle(tint: ((Color(red: 24/255, green: 57/255, blue: 163/255)))))
                        .frame(maxWidth: 300)
                        .padding([.top, .bottom, .trailing])
                        .border(Color.gray, width: 1.25)
                        .padding([.leading, .bottom, .trailing])
                        
                        //soil moisture
                        NavigationLink(destination: HistoricalData(pot: pot, tuples: pot.getValues(unit: "Hourly"))) {
                            HStack {
                                VStack{
                                    HStack {
                                        Text("Soil Moisture")
                                            .frame(maxWidth: 300)
                                            .foregroundColor(.black)
                                        Text("\(pot.curMoisture)%")
                                            .font(.title)
                                            .bold()
                                            .frame(maxWidth: 300)
                                            .foregroundColor(getTextColor(bool: moistureGood))
                                            .padding(.leading, 45)
                                    }
                                    Text("Ideal: \(pot.idealMoistureLow)% - \(pot.idealMoistureHigh)%")
                                        .padding(.leading, 100)
                                        .frame(maxWidth: 300)
                                        .foregroundColor(.black)
                                }
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: 300)
                            .padding([.top, .bottom])
                            .padding([.leading, .trailing], 5)
                            .border(Color.gray, width: 1.25)
                            .padding([.leading, .bottom, .trailing])
                            .fixedSize(horizontal: false, vertical: true)
                        }
                        //light level
                        NavigationLink(destination: HistoricalData(pot: pot, tuples: pot.getValues(unit: "Hourly"))) {
                            HStack {
                                VStack{
                                    HStack {
                                        Text("Light Level")
                                            .frame(maxWidth: 300)
                                            .foregroundColor(.black)
                                            .padding(.trailing, 10)
                                        Text("\(pot.curLight)lm")
                                            .font(.title)
                                            .bold()
                                            .frame(maxWidth: 300)
                                            .foregroundColor(getTextColor(bool: lightGood))
                                            .padding(.leading, 1)
                                    }
                                    Text("Ideal: \(pot.idealLightLow)lm - \(pot.idealLightHigh)lm")
                                        .padding(.leading, 50)
                                        .frame(maxWidth: 300)
                                        .foregroundColor(.black)
                                }
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: 300)
                            .padding([.top, .bottom])
                            .padding(.trailing, 5)
                            .border(Color.gray, width: 1.25)
                            .padding([.leading, .bottom, .trailing])
                            .fixedSize(horizontal: false, vertical: true)
                        }
                        
                        //temperature
                        NavigationLink(destination: HistoricalData(pot: pot, tuples: pot.getValues(unit: "Hourly"))) {
                            HStack {
                                VStack{
                                    HStack {
                                        Text("Temperature")
                                            .frame(maxWidth: 300)
                                            .foregroundColor(.black)
                                        Text("\(pot.curTemp)°F")
                                            .font(.title)
                                            .bold()
                                            .frame(maxWidth: 300)
                                            .foregroundColor(getTextColor(bool: tempGood))
                                            .padding(.leading, 35)
                                    }
                                    Text("Ideal: \(pot.idealTempLow)°F - \(pot.idealTempHigh)°F")
                                        .padding(.leading, 90)
                                        .frame(maxWidth: 300)
                                        .foregroundColor(.black)
                                }
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20))
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: 300)
                            .padding([.top, .bottom])
                            .padding([.leading, .trailing], 5)
                            .border(Color.gray, width: 1.25)
                            .padding([.leading, .bottom, .trailing])
                            .fixedSize(horizontal: false, vertical: true)
                        }
                        .navigationBarHidden(true)
                    }
                }//end scroll view
            }
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingDetail.toggle()
                }) {
                    Text("Edit")
                        .padding(6)
                        .foregroundColor(.white)
                }.sheet(isPresented: $showingDetail) {
                    EditPlantPage(user: user, plants: plants, pot: pot, showModal: $showingDetail)
                })
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
        }.onAppear {
            moistureGood = ((pot.curMoisture >= pot.idealMoistureLow) && (pot.curMoisture <= pot.idealMoistureHigh))
            lightGood = (pot.curLight >= pot.idealLightLow && pot.curLight <= pot.idealLightHigh)
            tempGood = (pot.curTemp >= pot.idealTempLow && pot.curTemp <= pot.idealTempHigh)
            autoWatering = pot.automaticWatering
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
}
