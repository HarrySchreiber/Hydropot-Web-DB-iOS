//
//  plantTypesFilter.swift
//  HydroPot
//
//  Created by David Dray on 2/12/21.
//

import SwiftUI

/*
    filter page for plant types
    filters by light, temp, moist
    filters those by high, med, low
 */
struct plantTypesFilter: View {
    @Environment(\.presentationMode) var presentationMode //mode for displaying modal
    @Binding var showFilter: Bool //showing the filer modal
    @Binding var filteredValues: [(Bool,Bool,Bool)] //the values of the filter
    @State var tempValues = [(false,false,false),(false,false,false),(false,false,false)] //default values for filter

    var body: some View {
        VStack{
            //telling user the can filter
            Text("Filter Plant Types")
                //styling
                .font(.system(size: UIScreen.titleTextSize))
                .foregroundColor(Color.black)
                .padding(.top, 32)
            HStack{
                //filtering by moisture
                Text("By Moisture:")
                    //styling
                    .font(.system(size: UIScreen.regTextSize))

                Spacer()
            }.padding()
            Group {
                HStack {
                    //button for filtering
                    Button(action: {
                        //filter low only
                        tempValues[0].0.toggle()
                        tempValues[0].1 = false
                        tempValues[0].2 = false
                    }) {
                        //low filter
                        Text("Low")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .foregroundColor(setButtonColor(selected: tempValues[0].0))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[0].0), lineWidth: 2)
                            )
                    }
                    //filtering medium
                    Button(action: {
                        //only medium
                        tempValues[0].1.toggle()
                        tempValues[0].0 = false
                        tempValues[0].2 = false
                    }) {
                        //medium filter
                        Text("Medium")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .foregroundColor(setButtonColor(selected: tempValues[0].1))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[0].1), lineWidth: 2)
                            )
                    }
                    //filtering high
                    Button(action: {
                        //high filter only
                        tempValues[0].2.toggle()
                        tempValues[0].0 = false
                        tempValues[0].1 = false
                    }) {
                        //fiter high
                        Text("High")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
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
                    //filter by light
                    Text("By Light Level:")
                        .font(.system(size: UIScreen.regTextSize))
                    Spacer()
                }.padding()
                HStack {
                    //filter low only
                    Button(action: {
                        tempValues[1].0.toggle()
                        tempValues[1].1 = false
                        tempValues[1].2 = false
                    }) {
                        //low filter
                        Text("Low")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .foregroundColor(setButtonColor(selected: tempValues[1].0))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[1].0), lineWidth: 2)
                            )
                    }
                    //filter medium only
                    Button(action: {
                        tempValues[1].1.toggle()
                        tempValues[1].0 = false
                        tempValues[1].2 = false
                    }) {
                        //medium filter
                        Text("Medium")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .foregroundColor(setButtonColor(selected: tempValues[1].1))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[1].1), lineWidth: 2)
                            )
                    }
                    //filter high only
                    Button(action: {
                        tempValues[1].2.toggle()
                        tempValues[1].0 = false
                        tempValues[1].1 = false
                    }) {
                        //high filter
                        Text("High")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
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
                    //filter by temperature
                    Text("By Temperature:")
                        //styling
                        .font(.system(size: UIScreen.regTextSize))
                    Spacer()
                }.padding()
                HStack {
                    Button(action: {
                        //filter low only
                        tempValues[2].0.toggle()
                        tempValues[2].1 = false
                        tempValues[2].2 = false
                    }) {
                        //low filter
                        Text("Low")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .foregroundColor(setButtonColor(selected: tempValues[2].0))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[2].0), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        //medium filter only
                        tempValues[2].1.toggle()
                        tempValues[2].0 = false
                        tempValues[2].2 = false
                    }) {
                        //medium filter
                        Text("Medium")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                            .foregroundColor(setButtonColor(selected: tempValues[2].1))
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(setButtonColor(selected: tempValues[2].1), lineWidth: 2)
                            )
                    }
                    Button(action: {
                        //filter high only
                        tempValues[2].2.toggle()
                        tempValues[2].0 = false
                        tempValues[2].1 = false
                    }) {
                        //high filter
                        Text("High")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
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
                    //reset filter
                    filteredValues = [(false,false,false),(false,false,false),(false,false,false)]
                    //dismiss
                    self.showFilter.toggle()
                }) {
                    HStack {
                        //cancel filter
                        Text("Cancel")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                    }
                    //styling
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.red.opacity(0.8))
                    .cornerRadius(6)
                }
                Button(action: {
                    //the real filtered is now temp
                    filteredValues = tempValues
                    //dismiss filter
                    self.showFilter.toggle()
                }) {
                    HStack {
                        //submit filtering
                        Text("Submit")
                            //styling
                            .font(.system(size: UIScreen.regTextSize))
                    }
                    //styling
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color(red: 0.142, green: 0.231, blue: 0.498))
                    .cornerRadius(6)
                    
                }.padding(.leading)
            }.padding(.top,30)
        }.onAppear {
            //make our temp what was previously filtered
            tempValues = filteredValues
        }
        Spacer()
    }
    
    /// make buttons correct color if selected
    /// - Parameters:
    ///     - selected: if the plant is selected make diff color
    ///
    /// - Returns;
    ///     - the color to be used by the button
    func setButtonColor(selected : Bool) -> Color {
        //if button is selected
        if(selected) {
            //return other color
            return Color(red: 24/255, green: 57/255, blue: 163/255)
        }
        //return regular color
        return Color.gray
    }
}

//
//struct plantTypesFilter_Previews: PreviewProvider {
//    static var previews: some View {
//        plantTypesFilter()
//    }
//}
