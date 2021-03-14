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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
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
            }
                if tuples[0].high == 0 && tuples[0].low == 0 {
                    Text("There is no historical data for this plant yet")
                        .font(.system(size: UIScreen.regTextSize))
                        .bold()
                        .italic()
                        .padding()
                        .foregroundColor(.gray)
                        
                }
                //moisture box
                PagesContainer(contentCount: 2) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding()
                        Text("Soil Moisture")
                            .font(.system(size: UIScreen.title3TextSize))
                            .frame(width: UIScreen.zStackWidth, height: UIScreen.zStackHeight, alignment: .topLeading)
                        // 1
                        HStack {
                          // 2
                            ForEach(1..<9) { month in
                            // 3
                            VStack {
                              // 4
                              Spacer()
                                Text("\(String(format: "%.2f", Double(month)))")
                                    
                                  .font(.footnote)
                                  .rotationEffect(.degrees(-90))
                                  .offset(y: 35)
                                  .zIndex(1)
                                    .offset(y: Double(month) < 2.4 ? -35 : 0)

                              // 5
                              Rectangle()
                                .fill(Color.green)
                                .frame(width: 20, height: CGFloat(Double(month)) * 15.0)
                              // 6
                              Text("\(month)")
                                .font(.footnote)
                                .frame(height: 20)
                            }
                            .padding(.bottom)
                          }
                        }
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding()
                        Text("Soil Moisture")
                            .font(.system(size: UIScreen.title3TextSize))
                            .frame(width: UIScreen.zStackWidth, height: UIScreen.zStackHeight, alignment: .topLeading)
                        VStack {
                            Text("High: \(tuples[0].high)%")
                                .font(.system(size: UIScreen.regTextSize))
                                .padding(.vertical)
                                .foregroundColor(Color.gray)
                            Text("Average: \(tuples[0].avg)%")
                                .font(.system(size: UIScreen.regTextSize))
                                .padding(.bottom)
                                .foregroundColor(Color.gray)
                            Text("Low: \(tuples[0].low)%")
                                .font(.system(size: UIScreen.regTextSize))
                                .foregroundColor(Color.gray)
                        }
                    }
                }.frame(width: UIScreen.panelWidth, height: UIScreen.panelHeight)
                
                //light box
                PagesContainer(contentCount: 2) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding()
                        Text("Light Level")
                            .font(.system(size: UIScreen.title3TextSize))
                            .frame(width: UIScreen.zStackWidth, height: UIScreen.zStackHeight, alignment: .topLeading)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding()
                        Text("Light Level")
                            .font(.system(size: UIScreen.title3TextSize))
                            .frame(width: UIScreen.zStackWidth, height: UIScreen.zStackHeight, alignment: .topLeading)
                        VStack {
                            Text("High: \(tuples[1].high)")
                                .font(.system(size: UIScreen.regTextSize))
                                .padding(.vertical)
                                .foregroundColor(Color.gray)
                            Text("Average: \(tuples[1].avg)")
                                .font(.system(size: UIScreen.regTextSize))
                                .padding(.bottom)
                                .foregroundColor(Color.gray)
                            Text("Low: \(tuples[1].low)")
                                .font(.system(size: UIScreen.regTextSize))
                                .foregroundColor(Color.gray)
                        }
                    }
                }.frame(width: UIScreen.panelWidth, height: UIScreen.panelHeight)
                
                //temperature box
                PagesContainer(contentCount: 2) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding()
                        Text("Temperature")
                            .font(.system(size: UIScreen.title3TextSize))
                            .frame(width: UIScreen.zStackWidth, height: UIScreen.zStackHeight, alignment: .topLeading)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding()
                        Text("Temperature")
                            .font(.system(size: UIScreen.title3TextSize))
                            .frame(width: UIScreen.zStackWidth, height: UIScreen.zStackHeight, alignment: .topLeading)
                        VStack {
                            Text("High: \(tuples[2].high)°F")
                                .font(.system(size: UIScreen.regTextSize))
                                .padding(.vertical)
                                .foregroundColor(Color.gray)
                            Text("Average: \(tuples[2].avg)°F")
                                .font(.system(size: UIScreen.regTextSize))
                                .padding(.bottom)
                                .foregroundColor(Color.gray)
                            Text("Low: \(tuples[2].low)°F")
                                .font(.system(size: UIScreen.regTextSize))
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                .frame(width: UIScreen.panelWidth, height: UIScreen.panelHeight)
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
                    })
            }
        }
        //background image for the home page
        .background(
            Image("plant2")
                .resizable()
                .opacity(0.50)
        )
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
