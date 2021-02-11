//
//  HistoricalData.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct HistoricalData: View {
    @ObservedObject var pot : Pot
    @State private var selectedUnit = 0
    var units = ["Hourly", "Daily", "Weekly"]
    @State var tuples : [(high: Int, avg: Int, low: Int)]
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    Picker(selection: $selectedUnit, label: Text("")) {
                        ForEach(0..<units.count) { index in
                            Text(self.units[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding(.top, 10)

//                    Text("Value: \(units[selectedUnit])")
                }.onReceive([self.selectedUnit].publisher.first()) { (value) in
//                    self.tuples = pot.getValues(unit: units[selectedUnit])
                    print("_____---_____---__---___---___--___--\(value)")
            }
                if tuples[0].high == 0 && tuples[0].low == 0 {
                    Text("There is no historical data for this plant yet")
                        .bold()
                        .italic()
                        .padding()
                        .foregroundColor(.gray)
                        
                }
                //moisture box
                PagesContainer(contentCount: 2) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.blue.opacity(0.3))
                            .padding()
                        Text("Soil Moisture").frame(width: 275, height: 150, alignment: .topLeading)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.blue.opacity(0.3))
                            .padding()
                        Text("Soil Moisture").frame(width: 275, height: 150, alignment: .topLeading)
                        VStack {
                            Text("High: \(tuples[0].high)%")
                                .font(.callout)
                                .padding(.vertical)
                                .foregroundColor(Color.gray)
                            Text("Average: \(tuples[0].avg)%")
                                .font(.callout)
                                .padding(.bottom)
                                .foregroundColor(Color.gray)
                            Text("Low: \(tuples[0].low)%")
                                .font(.callout)
                                .foregroundColor(Color.gray)
                        }
                    }
                }.frame(width: 325, height: 225)
                
                //light box
                PagesContainer(contentCount: 2) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.red.opacity(0.3))
                            .padding()
                        Text("Light Level").frame(width: 275, height: 150, alignment: .topLeading)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.red.opacity(0.3))
                            .padding()
                        Text("Light Level").frame(width: 275, height: 150, alignment: .topLeading)
                        VStack {
                            Text("High: \(tuples[1].high)")
                                .font(.callout)
                                .padding(.vertical)
                                .foregroundColor(Color.gray)
                            Text("Average: \(tuples[1].avg)")
                                .font(.callout)
                                .padding(.bottom)
                                .foregroundColor(Color.gray)
                            Text("Low: \(tuples[1].low)")
                                .font(.callout)
                                .foregroundColor(Color.gray)
                        }
                    }
                }.frame(width: 325, height: 225)
                
                //temperature box
                PagesContainer(contentCount: 2) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.green.opacity(0.3))
                            .padding()
                        Text("Temperature").frame(width: 275, height: 150, alignment: .topLeading)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.green.opacity(0.3))
                            .padding()
                        Text("Temperature").frame(width: 275, height: 150, alignment: .topLeading)
                        VStack {
                            Text("High: \(tuples[2].high)°F")
                                .font(.callout)
                                .padding(.vertical)
                                .foregroundColor(Color.gray)
                            Text("Average: \(tuples[2].avg)°F")
                                .font(.callout)
                                .padding(.bottom)
                                .foregroundColor(Color.gray)
                            Text("Low: \(tuples[2].low)°F")
                                .font(.callout)
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                .frame(width: 325, height: 225) //scaling thing later
                
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
    
}

struct PagesContainer <Content : View> : View {
    let contentCount: Int
    @State var index: Int = 0
    let content: Content
    @GestureState private var translation: CGFloat = 0
    
    init(contentCount: Int, @ViewBuilder content: () -> Content) {
        self.contentCount = contentCount
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack (spacing: 0){
                    self.content
                        .frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.index) * geometry.size.width)
                .offset(x: self.translation)
                .animation(.interactiveSpring())
                .gesture(
                    DragGesture().updating(self.$translation) { value, state, _ in
                        state = value.translation.width
                    }.onEnded { value in
                        var weakGesture : CGFloat = 0
                        if value.translation.width < 0 {
                            weakGesture = -100
                        } else {
                            weakGesture = 100
                        }
                        let offset = (value.translation.width + weakGesture) / geometry.size.width
                        let newIndex = (CGFloat(self.index) - offset).rounded()
                        self.index = min(max(Int(newIndex), 0), self.contentCount - 1)
                    }
                )
                HStack {
                    ForEach(0..<self.contentCount) { num in
                        Circle().frame(width: 10, height: 10)
                            .foregroundColor(self.index == num ? .primary : Color.secondary.opacity(0.5))
                    }
                }
            }
        }
    }
}
/*
struct HistoricalData_Previews: PreviewProvider {
    static var previews: some View {
        HistoricalData(pot: Pot(plantName: "bob", plantType: "type", idealTempHigh: 80, idealTempLow: 20, idealMoistureHigh: 30, idealMoistureLow: 20, idealLightHigh: 3200, idealLightLow: 2300, lastWatered: Date(), records: [], notifications: []), tuples: [(high: 0, avg: 2, low: 0),(high: 1, avg: 2, low: 3),(high: 1, avg: 2, low: 3)])
        
    }
}*/
