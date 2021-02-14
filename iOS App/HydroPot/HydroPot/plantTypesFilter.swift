//
//  plantTypesFilter.swift
//  HydroPot
//
//  Created by David Dray on 2/12/21.
//

import SwiftUI

struct plantTypesFilter: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var showFilter: Bool
    @Binding var filteredValues: [(Bool,Bool,Bool)]
    @State var tempValues = [(false,false,false),(false,false,false),(false,false,false)]

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
                        tempValues[0].0.toggle()
                        tempValues[0].1 = false
                        tempValues[0].2 = false
                    }) {
                        Text("Low")
                            .foregroundColor(setButtonColor(selected: tempValues[0].0))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[0].0), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        tempValues[0].1.toggle()
                        tempValues[0].0 = false
                        tempValues[0].2 = false
                    }) {
                        Text("Medium")
                            .foregroundColor(setButtonColor(selected: tempValues[0].1))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[0].1), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        tempValues[0].2.toggle()
                        tempValues[0].0 = false
                        tempValues[0].1 = false
                    }) {
                        Text("High")
                            .foregroundColor(setButtonColor(selected: tempValues[0].2))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[0].2), lineWidth: 2)
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
                        tempValues[1].0.toggle()
                        tempValues[1].1 = false
                        tempValues[1].2 = false
                    }) {
                        Text("Low")
                            .foregroundColor(setButtonColor(selected: tempValues[1].0))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[1].0), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        tempValues[1].1.toggle()
                        tempValues[1].0 = false
                        tempValues[1].2 = false
                    }) {
                        Text("Medium")
                            .foregroundColor(setButtonColor(selected: tempValues[1].1))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[1].1), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        tempValues[1].2.toggle()
                        tempValues[1].0 = false
                        tempValues[1].1 = false
                    }) {
                        Text("High")
                            .foregroundColor((setButtonColor(selected: tempValues[1].2)))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[1].2), lineWidth: 2)
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
                        tempValues[2].0.toggle()
                        tempValues[2].1 = false
                        tempValues[2].2 = false
                    }) {
                        Text("Low")
                            .foregroundColor(setButtonColor(selected: tempValues[2].0))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[2].0), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        tempValues[2].1.toggle()
                        tempValues[2].0 = false
                        tempValues[2].2 = false
                    }) {
                        Text("Medium")
                            .foregroundColor(setButtonColor(selected: tempValues[2].1))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[2].1), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        tempValues[2].2.toggle()
                        tempValues[2].0 = false
                        tempValues[2].1 = false
                    }) {
                        Text("High")
                            .foregroundColor(setButtonColor(selected: tempValues[2].2))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[2].2), lineWidth: 2)
                            )
                    }
                }
            }
            HStack {
                Button(action: {
                    filteredValues = [(false,false,false),(false,false,false),(false,false,false)]
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
                    filteredValues = tempValues
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
        }.onAppear {
            tempValues = filteredValues
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
