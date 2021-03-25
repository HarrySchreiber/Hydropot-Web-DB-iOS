//
//  waterModal.swift
//  HydroPot
//
//  Created by Eric  Lisle on 2/12/21.
//

import Foundation
import SwiftUI

/*
    view for water modal
 */
struct waterModal: View {
    
    @Binding var showPopUp: Bool //bool to dismiss modal
    @State var isShowing = false
    @State var threeML = true //30 ML to water
    @State var sixML = false //60 ML to water
    @State var nineML = false //90 ML to water
    @ObservedObject var pot: Pot //given pot to water
    @ObservedObject var user: GetUser //user that holds the pot
    
    var body: some View {
        ZStack {
            Color.white
            VStack (alignment: .leading) {
                Text("Water Amount")
                    .font(.system(size: UIScreen.regTextSize))
                HStack {
                    //if selected
                    if (threeML == true){
                        //one black drop
                        Image(systemName: "drop.fill")
                            .font(.system(size: UIScreen.homeImageSize/2))
                    }
                    else {
                        //one white drop
                        Image(systemName: "drop")
                            .font(.system(size: UIScreen.homeImageSize/2))
                    }
                    //watering amount
                    Text("30 mL")
                        .font(.system(size: UIScreen.regTextSize))
                }
                .onTapGesture {
                    //only threeML true
                    threeML = true
                    sixML = false
                    nineML = false
                }
                HStack {
                    //if seleceted
                    if (sixML == true){
                        //two black drops
                        Image(systemName: "drop.fill")
                            .font(.system(size: UIScreen.homeImageSize/2))
                        Image(systemName: "drop.fill")
                            .font(.system(size: UIScreen.homeImageSize/2))
                    }
                    //if not selected
                    else {
                        //two white drops
                        Image(systemName: "drop")
                            .font(.system(size: UIScreen.homeImageSize/2))
                        Image(systemName: "drop")
                            .font(.system(size: UIScreen.homeImageSize/2))
                    }
                    //watering amount
                    Text("60 mL")
                        .font(.system(size: UIScreen.regTextSize))
                }
                .onTapGesture {
                    //only sixML true
                    threeML = false
                    sixML = true
                    nineML = false
                }
                HStack {
                    //selected
                    if (nineML == true){
                        //three black drops
                        Image(systemName: "drop.fill")
                            .font(.system(size: UIScreen.homeImageSize/2))
                        Image(systemName: "drop.fill")
                            .font(.system(size: UIScreen.homeImageSize/2))
                        Image(systemName: "drop.fill")
                            .font(.system(size: UIScreen.homeImageSize/2))
                    }
                    //not selected
                    else {
                        //three white drops
                        Image(systemName: "drop")
                            .font(.system(size: UIScreen.homeImageSize/2))
                        Image(systemName: "drop")
                            .font(.system(size: UIScreen.homeImageSize/2))
                        Image(systemName: "drop")
                            .font(.system(size: UIScreen.homeImageSize/2))
                    }
                    //display watering amount
                    Text("90 mL")
                        .font(.system(size: UIScreen.regTextSize))
                }
                .onTapGesture {
                    //only nineML is true
                    threeML = false
                    sixML = false
                    nineML = true
                }
                //stack for buttons (conf/cancel)
                HStack {
                    //button to cancel
                    Button(action: {
                        //dismiss modal
                        showPopUp = false
                    }) {
                        //cancel text
                        Text("Cancel")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                            .cornerRadius(6)
                    }
                    //button for watering
                    Button(action: {
                        //dismiss the modal
                        showPopUp = false
                        //water the plant
                        waterPot()
                    }) {
                        //confirm text
                        Text("Confirm")
                            //styling for the confirm button
                            .font(.system(size: UIScreen.regTextSize))
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                            .cornerRadius(6)
                    }
                }
            }.padding()
        }
        //frame of the modal
        .frame(width: UIScreen.modalWidth, height: UIScreen.modalWidth - UIScreen.screenWidth/80)

        .cornerRadius(20).shadow(radius: 20)
    }
    
    /// allows for the watering of the plant
    func waterPot(){
        //if user selected 30ML
        if (threeML == true){
            //water 30ML (db call)
            user.waterPot(pot: pot, waterAmount: 1)
        }
        //if user selected 60ML
        else if (sixML == true){
            //water 60ML (db call)
            user.waterPot(pot: pot, waterAmount: 2)
        }
        //if user seleceted 90ML
        else {
            //water 90ML (db call)
            user.waterPot(pot: pot, waterAmount: 3)
        }
        //set the days correctly
        pot.setLastWatered(lastWatered: Date())
    }
}

