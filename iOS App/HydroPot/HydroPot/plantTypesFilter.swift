//
//  plantTypesFilter.swift
//  HydroPot
//
//  Created by David Dray on 2/12/21.
//

import SwiftUI

struct plantTypesFilter: View {
    //@Environment(\.presentationMode) var presentationMode
    //@ObservedObject var user: GetUser
    @Binding var showFilter: Bool
    //moisture buttons
    @State var lowMoist: Bool = false
    @State var medMoist: Bool = false
    @State var highMoist: Bool = false
    //light buttons
    @State var lowLight: Bool = false
    @State var medLight: Bool = false
    @State var highLight: Bool = false
    //temperature buttons
    @State var lowTemp: Bool = false
    @State var medTemp: Bool = false
    @State var highTemp: Bool = false
    
    var body: some View {
        VStack{
            Text("Filter Plant Types")
                .font(.title)
                .foregroundColor(Color.black)
                .padding(.top, 32)
            HStack{
                Text("By Moisture:")
                Spacer()
            }.padding()
            Group {
                HStack {
                    Button(action: {
                        lowMoist.toggle()
                    }) {
                        Text("Low")
                            .foregroundColor(setButtonColor(selected: lowMoist))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: lowMoist), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        medMoist.toggle()
                    }) {
                        Text("Medium")
                            .foregroundColor(setButtonColor(selected: medMoist))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: medMoist), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        highMoist.toggle()
                    }) {
                        Text("High")
                            .foregroundColor(setButtonColor(selected: highMoist))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: highMoist), lineWidth: 2)
                            )
                    }
                }
            }
            Group {
                HStack{
                    Text("By Light Level:")
                    Spacer()
                }.padding()
                HStack {
                    Button(action: {
                        lowLight.toggle()
                    }) {
                        Text("Low")
                            .foregroundColor(setButtonColor(selected: lowLight))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: lowLight), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        medLight.toggle()
                    }) {
                        Text("Medium")
                            .foregroundColor(setButtonColor(selected: medLight))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: medLight), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        highLight.toggle()
                    }) {
                        Text("High")
                            .foregroundColor((setButtonColor(selected: highLight)))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: highLight), lineWidth: 2)
                            )
                    }
                }
            }
            Group {
                HStack{
                    Text("By Temperature:")
                    Spacer()
                }.padding()
                HStack {
                    Button(action: {
                        lowTemp.toggle()
                    }) {
                        Text("Low")
                            .foregroundColor(setButtonColor(selected: lowTemp))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: lowTemp), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        medTemp.toggle()
                    }) {
                        Text("Medium")
                            .foregroundColor(setButtonColor(selected: medTemp))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: medTemp), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        highTemp.toggle()
                    }) {
                        Text("High")
                            .foregroundColor(setButtonColor(selected: highTemp))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: highTemp), lineWidth: 2)
                            )
                    }
                }
            }
            HStack {
                Button(action: {
                    self.showFilter.toggle()
                }) {
                    HStack {
                        Text("Cancel")
                    }
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(6)
                }
                Button(action: {
                    self.showFilter.toggle()
                }) {
                    HStack {
                        Text("Submit")
                    }
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color(red: 0.142, green: 0.231, blue: 0.498))
                    .cornerRadius(6)
                    
                }.padding(.leading)
            }.padding(.top,30)
        }
        Spacer()
    }
    
    func setButtonColor(selected : Bool) -> Color {
        if(selected) {
            return Color(red: 24/255, green: 57/255, blue: 163/255)
        }
        return Color.gray
    }
}

//
//struct plantTypesFilter_Previews: PreviewProvider {
//    static var previews: some View {
//        plantTypesFilter()
//    }
//}
