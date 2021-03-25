//
//  HistoricalData.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct HistoricalData: View {
    
    @ObservedObject var pot : Pot   //current pot selected
    @State var selectedUnit : Int = 0 //variable for storing which picker value is selected
    @State var units = ["Hourly", "Daily", "Weekly"]   //3 picker values available
    @State var tuples : [(high: Int, avg: Int, low: Int)]   //array of high low and average values to display
    
    @State var moistureGraphArrays : (hourly: [Int], daily: [Int], weekly: [Int])  //arrays for moisture (hourly, daily, weekly)
    @State var lightGraphArrays : (hourly: [Int], daily: [Int], weekly: [Int])  //arrays for light (hourly, daily, weekly)
    @State var tempGraphArrays : (hourly: [Int], daily: [Int], weekly: [Int])  //arrays for temperature (hourly, daily, weekly)
    
    @State var moistureBars : [GraphBar] = []  //array for moisture bar
    @State var lightBars : [GraphBar] = []  //array for light bar
    @State var tempBars : [GraphBar] = [] //array for temperature bar
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        //binding variable for the display list of plants (strings)
        let bindingUnit = Binding(
            get: { self.selectedUnit },
            set: {
                self.selectedUnit = $0
                self.tuples = pot.getValues(unit: units[selectedUnit])
                
                //change bar sizes/values based on unit change
                //convert graph values to list of general graphBars
                //reverse list to get newest data last (for display)
                if selectedUnit == 1 {
                    moistureBars = getMoistureGraphBars(graphValues: moistureGraphArrays.daily.reversed())
                    lightBars = getLightGraphBars(graphValues: lightGraphArrays.daily.reversed())
                    tempBars = getTempGraphBars(graphValues: tempGraphArrays.daily.reversed())
                }
                else if selectedUnit == 2 {
                    moistureBars = getMoistureGraphBars(graphValues: moistureGraphArrays.weekly.reversed())
                    lightBars = getLightGraphBars(graphValues: lightGraphArrays.weekly.reversed())
                    tempBars = getTempGraphBars(graphValues: tempGraphArrays.weekly.reversed())
                }
                else {
                    moistureBars = getMoistureGraphBars(graphValues: moistureGraphArrays.hourly.reversed())
                    lightBars = getLightGraphBars(graphValues: lightGraphArrays.hourly.reversed())
                    tempBars = getTempGraphBars(graphValues: tempGraphArrays.hourly.reversed())
                }
            }
        )
        ScrollView {
            VStack {
                VStack {
                    //picker for hourly, daily, and weekly views
                    Picker(selection: bindingUnit, label: Text("")) {
                        ForEach(0..<units.count) { index in
                            Text(self.units[index]).tag(index)
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding(.top, 10)
                }
                //if there isnt any data stored, inform user
                if moistureGraphArrays.weekly[0] == 0 && moistureGraphArrays.weekly[1] == 0 && moistureGraphArrays.weekly[2] == 0 && moistureGraphArrays.weekly[3] == 0 && moistureGraphArrays.weekly[4] == 0 {
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
                            ForEach(moistureBars) { graphBar in
                                VStack {
                                    Spacer()
                                    //data values shown on graph
                                    Text("\(graphBar.displayValue)")
                                        .font(.system(size: UIScreen.subTextSize))
                                        .rotationEffect(.degrees(-90))
                                        .offset(y: UIScreen.textOffset)
                                        .zIndex(1)
                                        .offset(y: Double(graphBar.barHeight) < 2.4 ? -UIScreen.textOffset : 0)
                                    
                                    // bars of the graph
                                    Rectangle()
                                        .fill(getTextColor(bool: ((graphBar.displayValue >= pot.idealMoistureLow) && (graphBar.displayValue <= pot.idealMoistureHigh))))
                                        .frame(width: UIScreen.graphWidth, height: Double(graphBar.displayValue) == 0 ? CGFloat(5) : CGFloat(Double(graphBar.barHeight)) * UIScreen.graphMultiplier)
                                    // x values of bar graph
                                    Text("\(graphBar.xValue)")
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
                            ForEach(lightBars) { graphBar in
                                VStack {
                                    Spacer()
                                    //data values shown on graph
                                    Text("\(graphBar.displayValue)")
                                        .font(.system(size: UIScreen.subTextSize))
                                        .rotationEffect(.degrees(-90))
                                        .offset(y: UIScreen.textOffset)
                                        .zIndex(1)
                                        .offset(y: Double(graphBar.barHeight) < 2.4 ? -UIScreen.textOffset : 0)
                                    
                                    // bars of the graph
                                    Rectangle()
                                        .fill(getTextColor(bool: ((graphBar.displayValue >= pot.idealMoistureLow) && (graphBar.displayValue <= pot.idealMoistureHigh))))
                                        .frame(width: UIScreen.graphWidth, height: Double(graphBar.displayValue) == 0 ? CGFloat(5) : CGFloat(Double(graphBar.barHeight)) * UIScreen.graphMultiplier)
                                    // x values of bar graph
                                    Text("\(graphBar.xValue)")
                                        .font(.system(size: UIScreen.subTextSize))
                                        .frame(height: UIScreen.graphWidth)
                                }
                                .padding(.bottom)
                                .padding(.trailing, UIScreen.graphPadding)
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
                            ForEach(tempBars) { graphBar in
                                VStack {
                                    Spacer()
                                    //data values shown on graph
                                    Text("\(graphBar.displayValue)")
                                        .font(.system(size: UIScreen.subTextSize))
                                        .rotationEffect(.degrees(-90))
                                        .offset(y: UIScreen.textOffset)
                                        .zIndex(1)
                                        .offset(y: Double(graphBar.barHeight) < 2.4 ? -UIScreen.textOffset : 0)
                                    
                                    // bars of the graph
                                    Rectangle()
                                        .fill(getTextColor(bool: ((graphBar.displayValue >= pot.idealMoistureLow) && (graphBar.displayValue <= pot.idealMoistureHigh))))
                                        .frame(width: UIScreen.graphWidth, height: Double(graphBar.displayValue) == 0 ? CGFloat(5) : CGFloat(Double(graphBar.barHeight)) * UIScreen.graphMultiplier)
                                    // x values of bar graph
                                    Text("\(graphBar.xValue)")
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
        .onAppear {            
            //convert graph values to list of general graphBars
            //reverse list to get newest data last (for display)
            moistureBars = getMoistureGraphBars(graphValues: moistureGraphArrays.hourly.reversed())
            lightBars = getLightGraphBars(graphValues: lightGraphArrays.hourly.reversed())
            tempBars = getTempGraphBars(graphValues: tempGraphArrays.hourly.reversed())
        }
    }
    
    //return the corresponding color for if the value was in the pot's ideal range
    func getTextColor(bool: Bool) -> Color{
        if(bool) {
            return Color.green
            //return Color(red: 41.0/255.0, green: 110.0/255.0, blue: 25.0/255.0)
        }
        return Color.red
    }
    
    //function for creating an array of moisture graphBars to display for the user
    func getMoistureGraphBars (graphValues: [Int]) -> [GraphBar] {
        var returnList : [GraphBar] = []
        for index in 0..<graphValues.count {
            let xval = getXValue(graphValue: graphValues[index], timeDisplacement: graphValues.count - index-1)
            let barSize = getMoistureBarSize(graphValue: graphValues[index])
            let bar = GraphBar(xValue: xval, displayValue: graphValues[index], barHeight: barSize)
            returnList.append(bar)
        }
        return returnList
    }
    //function for creating an array of light graphBars to display for the user
    func getLightGraphBars (graphValues: [Int]) -> [GraphBar] {
        var returnList : [GraphBar] = []
        for index in 0..<graphValues.count {
            let xval = getXValue(graphValue: graphValues[index], timeDisplacement: graphValues.count - index-1)
            let barSize = getLightBarSize(graphValue: graphValues[index])
            let bar = GraphBar(xValue: xval, displayValue: graphValues[index], barHeight: barSize)
            returnList.append(bar)
        }
        return returnList
    }
    
    //function for creating an array of temperature graphBars to display for the user
    func getTempGraphBars (graphValues: [Int]) -> [GraphBar] {
        var returnList : [GraphBar] = []
        for index in 0..<graphValues.count {
            let xval = getXValue(graphValue: graphValues[index], timeDisplacement: graphValues.count - index-1)
            let barSize = getTempBarSize(graphValue: graphValues[index])
            let bar = GraphBar(xValue: xval, displayValue: graphValues[index], barHeight: barSize)
            returnList.append(bar)
        }
        return returnList
    }
    
    //function for converting moisture historical data values into graph bar sizes
    func getMoistureBarSize(graphValue: Int) -> Double{
        let maxMoisture = 60
        let minMoisture = 0
        let graphMin = 1
        let graphMax = 8
        
        let oldRange = (maxMoisture - minMoisture)
        let newRange = (graphMax - graphMin)
        let newValue = Double(((graphValue - minMoisture) * newRange) / oldRange) + Double(graphMin)
        return newValue
    }
    //function for converting light historical data values into graph bar sizes
    func getLightBarSize(graphValue: Int) -> Double{
        let maxLight = 15000
        let minLight = 100
        let graphMin = 1
        let graphMax = 8
        
        let oldRange = (maxLight - minLight)
        let newRange = (graphMax - graphMin)
        let newValue = Double(((graphValue - minLight) * newRange) / oldRange) + Double(graphMin)
        return newValue
    }
    //function for converting temperature historical data values into graph bar sizes
    func getTempBarSize(graphValue: Int) -> Double{
        let maxTemp = 90
        let minTemp = 40
        let graphMin = 1
        let graphMax = 8
        
        let oldRange = (maxTemp - minTemp)
        let newRange = (graphMax - graphMin)
        let newValue = Double(((graphValue - minTemp) * newRange) / oldRange) + Double(graphMin)
        return newValue
    }
    
    //function for getting x-values for any graph
    func getXValue(graphValue: Int, timeDisplacement: Int) -> String {
        let formatter = DateFormatter()
        
        if(units[selectedUnit] == "Daily") {
            formatter.dateFormat = "dd"
            let tempDate = Calendar.current.date(byAdding: .day, value: -timeDisplacement, to: Date())!
            return formatter.string(from: tempDate)
        }
        
        if(units[selectedUnit] == "Weekly") {
            formatter.dateFormat = "dd"
            let tempDate = Calendar.current.date(byAdding: .weekOfYear, value: -timeDisplacement, to: Date())!
            return formatter.string(from: tempDate)
        }
        
        formatter.dateFormat = "hh" // "a" prints "pm" or "am"
        let tempDate = Calendar.current.date(byAdding: .hour, value: -timeDisplacement, to: Date())!
        return formatter.string(from: tempDate)
    }
}

//struct for setting up the different cards
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


struct GraphBar : Identifiable {
    var id = UUID()
    var xValue: String
    var displayValue: Int
    var barHeight: Double
    
    init(xValue: String, displayValue: Int, barHeight: Double) {
        self.xValue = xValue
        self.displayValue = displayValue
        self.barHeight = barHeight
    }
}

