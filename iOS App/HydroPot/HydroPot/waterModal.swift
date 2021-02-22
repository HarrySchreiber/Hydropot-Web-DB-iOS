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
    
    var body: some View {
        ZStack {
            Color.white
            VStack (alignment: .leading) {
                Text("Water Amount")
                    .font(.system(size: UIScreen.regTextSize))
                HStack {
                    if (threeML == true){
                        Image(systemName: "drop.fill")
                            .font(.system(size: UIScreen.homeImageSize/2))
                    }
                    else {
                        Image(systemName: "drop")
                            .font(.system(size: UIScreen.homeImageSize/2))
                    }
                    Text("30 mL")
                        .font(.system(size: UIScreen.regTextSize))
                }
                .onTapGesture {
                    threeML = true
                    sixML = false
                    nineML = false
                }
                HStack {
                    if (sixML == true){
                        Image(systemName: "drop.fill")
                            .font(.system(size: UIScreen.homeImageSize/2))
                        Image(systemName: "drop.fill")
                            .font(.system(size: UIScreen.homeImageSize/2))
                    }
                    else {
                        Image(systemName: "drop")
                            .font(.system(size: UIScreen.homeImageSize/2))
                        Image(systemName: "drop")
                            .font(.system(size: UIScreen.homeImageSize/2))
                    }
                    Text("60 mL")
                        .font(.system(size: UIScreen.regTextSize))
                }
                .onTapGesture {
                    threeML = false
                    sixML = true
                    nineML = false
                }
                HStack {
                    if (nineML == true){
                        Image(systemName: "drop.fill")
                            .font(.system(size: UIScreen.homeImageSize/2))
                        Image(systemName: "drop.fill")
                            .font(.system(size: UIScreen.homeImageSize/2))
                        Image(systemName: "drop.fill")
                            .font(.system(size: UIScreen.homeImageSize/2))
                    }
                    else {
                        Image(systemName: "drop")
                            .font(.system(size: UIScreen.homeImageSize/2))
                        Image(systemName: "drop")
                            .font(.system(size: UIScreen.homeImageSize/2))
                        Image(systemName: "drop")
                            .font(.system(size: UIScreen.homeImageSize/2))
                    }
                    Text("90 mL")
                        .font(.system(size: UIScreen.regTextSize))
                }
                .onTapGesture {
                    threeML = false
                    sixML = false
                    nineML = true
                }
                HStack {
                    Button(action: {
                        showPopUp = false
                    }) {
                        Text("Cancel")
                            .font(.system(size: UIScreen.regTextSize))
                            .buttonStyle(BorderlessButtonStyle())
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color(red: 24/255, green: 57/255, blue: 163/255))
                            .cornerRadius(6)
                    }
                    Button(action: {
                        showPopUp = false
                    }) {
                        Text("Confirm")
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
        .frame(width: UIScreen.modalWidth, height: UIScreen.modalWidth - UIScreen.screenWidth/80)
        .cornerRadius(20).shadow(radius: 20)
    }
}

