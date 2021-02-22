//
//  waterModal.swift
//  HydroPot
//
//  Created by Eric  Lisle on 2/12/21.
//

import Foundation
import SwiftUI

struct waterModal: View {
    
    @Binding var showPopUp: Bool
    @State var isShowing = false
    @State var threeML = true
    @State var sixML = false
    @State var nineML = false
    @ObservedObject var pot: Pot
    @ObservedObject var user: GetUser
    
    var body: some View {
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
                    Text("30 mL")
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
                    Text("60 mL")
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
                    Text("90 mL")
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
                        waterPot()
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
    
    func waterPot(){
        if (threeML == true){
            user.waterPot(pot: pot, waterAmount: 1)
        }
        else if (sixML == true){
            user.waterPot(pot: pot, waterAmount: 2)
        }
        else {
            user.waterPot(pot: pot, waterAmount: 3)
        }
    }
}

