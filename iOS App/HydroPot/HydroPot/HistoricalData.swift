//
//  HistoricalData.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct HistoricalData: View {
    
    @ObservedObject var pot : Pot   //current pot selected
    @State private var selectedUnit = 0 //variable for storing which picker value is selected
    var units = ["Hourly", "Daily", "Weekly"]   //3 picker values available
    @State var tuples : [(high: Int, avg: Int, low: Int)]   //array of high low and average values to display

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    //picker for hourly, daily, and weekly views
                    Picker(selection: $selectedUnit, label: Text("")) {
                        ForEach(0..<units.count) { index in
                            Text(self.units[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding(.top, 10)

//                    Text("Value: \(units[selectedUnit])")
                }
                .onReceive([self.selectedUnit].publisher.first()) { (value) in
//                    self.tuples = pot.getValues(unit: units[selectedUnit])
                }
                //if there isnt any data stored, inform user
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
                    //show title and graph
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding()
                        Text("Soil Moisture")
                            .font(.system(size: UIScreen.title3TextSize))
                            .frame(width: UIScreen.zStackWidth, height: UIScreen.zStackHeight, alignment: .topLeading)
                        HStack {
                            ForEach(1..<9) { month in
                            VStack {
                              Spacer()
                                //data values shown on graph
                                Text("\(month*10)")
                                    .font(.system(size: UIScreen.subTextSize))
                                    .rotationEffect(.degrees(-90))
                                    .offset(y: UIScreen.textOffset)
                                    .zIndex(1)
                                    .offset(y: Double(month) < 2.4 ? -UIScreen.textOffset : 0)

                              // bars of the graph
                              Rectangle()
                                .fill(getTextColor(bool: ((month*10 >= pot.idealMoistureLow) && (month*10 <= pot.idealMoistureHigh))))
                                .frame(width: UIScreen.graphWidth, height: CGFloat(Double(month)) * UIScreen.graphMultiplier)
                              // x values of bar graph
                              Text("\(month)")
                                .font(.system(size: UIScreen.subTextSize))
                                .frame(height: UIScreen.graphWidth)
                            }
                            .padding(.bottom)
                            .padding(.trailing, UIScreen.graphPadding)
                          }
                        }
                    }
                    //2nd card, showing high, average, and low values
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding()
                        //cards's title
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
                    //show title and graphs
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding()
                        Text("Light Level")
                            .font(.system(size: UIScreen.title3TextSize))
                            .frame(width: UIScreen.zStackWidth, height: UIScreen.zStackHeight, alignment: .topLeading)
                        //graph
                        HStack {
                            ForEach(1..<9) { month in
                            VStack {
                              Spacer()
                                //graph data values
                                Text("\(month*100)")
                                    .font(.system(size: UIScreen.subTextSize))
                                    .rotationEffect(.degrees(-90))
                                    .offset(y: UIScreen.textOffset)
                                    .zIndex(1)
                                    .offset(y: Double(month) < 2.4 ? -UIScreen.textOffset : 0)

                              // graph bars
                              Rectangle()
                                .fill(getTextColor(bool: ((month*100 >= pot.idealLightLow) && (month*100 <= pot.idealLightHigh))))
                                .frame(width: UIScreen.graphWidth, height: CGFloat(Double(month)) * UIScreen.graphMultiplier)
                              // graph's x values
                              Text("\(month)")
                                .font(.system(size: UIScreen.subTextSize))
                                .frame(height: UIScreen.graphWidth)
                            }
                            .padding(.bottom)
                            //.padding(.trailing, UIScreen.graphPadding)
                          }
                        }
                    }
                    //2nd card - shows high, average, and low values
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding()
                        //title
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
                    //1st card - shows title and graphs
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding()
                        //title
                        Text("Temperature")
                            .font(.system(size: UIScreen.title3TextSize))
                            .frame(width: UIScreen.zStackWidth, height: UIScreen.zStackHeight, alignment: .topLeading)
                        //graph
                        HStack {
                            ForEach(1..<9) { month in
                            VStack {
                              Spacer()
                                //data values
                                Text("\(month*10)")
                                    .font(.system(size: UIScreen.subTextSize))
                                    .rotationEffect(.degrees(-90))
                                    .offset(y: UIScreen.textOffset)
                                    .zIndex(1)
                                    .offset(y: Double(month) < 2.4 ? -UIScreen.textOffset : 0)

                              // graph bars
                              Rectangle()
                                .fill(getTextColor(bool: ((month*10 >= pot.idealTempLow) && (month*10 <= pot.idealTempHigh))))
                                .frame(width: UIScreen.graphWidth, height: CGFloat(Double(month)) * UIScreen.graphMultiplier)
                                // graph x values
                                Text("\(month)")
                                  .font(.system(size: UIScreen.subTextSize))
                                  .frame(height: UIScreen.graphWidth)
                            }
                            .padding(.bottom)
                            .padding(.trailing, UIScreen.graphPadding)
                          }
                        }
                    }
                    //2nd card - show high, low, and average values
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.white.opacity(0.9))
                            .padding()
                        //title
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
                //setup the header (back button)
                
            }
        }
        //background image for the home page
        .background(
            Image("plant2")
                .resizable()
                .opacity(0.50)
        )
    }
    
    //return the corresponding color for if the value was in the pot's ideal range
    func getTextColor(bool: Bool) -> Color{
        if(bool) {
            return Color.green
            //return Color(red: 41.0/255.0, green: 110.0/255.0, blue: 25.0/255.0)
        }
        return Color.red
    }
}

//struct for seting up the different cards
struct PagesContainer <Content : View> : View {
    let contentCount: Int   //using 2 cards (one for graphs, one for highs and lows)
    @State var index: Int = 0   //current index
    let content: Content
    @GestureState private var translation: CGFloat = 0
    
    init(contentCount: Int, @ViewBuilder content: () -> Content) {
        self.contentCount = contentCount
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                //display the content within the pages container
                HStack (spacing: 0){
                    self.content
                        .frame(width: geometry.size.width)
                }
                //setup sizing, animations and gestures
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
                //show dots corresponding with which card is displayed and which is hidden
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
