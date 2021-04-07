//
//  PlantTypePage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI
import URLImage

/*
    page to display individual plant
 */
struct PlantTypePage: View {
    @ObservedObject var plant: Plant //plant being passed
    @ObservedObject var ideals: Ideals = Ideals(idealTemperatureHigh: "", idealTemperatureLow: "", idealMoistureHigh: "", idealMoistureLow: "", idealLightLevelLow: "", idealLightLevelHigh: "", plantName: "", plantSelected: "", notificationFrequency: 2) //default ideals
    
    init (plant : Plant) {
        //set plant
        self.plant = plant
        
        //setting ideals
        ideals.idealMoistureHigh = String(plant.idealMoistureHigh)
        ideals.idealMoistureLow = String(plant.idealMoistureLow)
        ideals.idealTemperatureHigh = String(plant.idealTempHigh)
        ideals.idealTemperatureLow = String(plant.idealTempLow)
        ideals.idealLightLevelLow = String(plant.idealLightLow)
        ideals.idealLightLevelHigh = String(plant.idealLightHigh)
        
        //handling no ideal moist low
        if (ideals.idealMoistureLow == "-1000"){
            ideals.idealMoistureLow = "NA"
        }
        //handling no ideal moist high
        if (ideals.idealMoistureHigh == "-1000"){
            ideals.idealMoistureHigh = "NA"
        }
        //handling no ideal temp low
        if (ideals.idealTemperatureLow == "-1000"){
            ideals.idealTemperatureLow = "NA"
        }
        //handling no ideal temp high
        if (ideals.idealTemperatureHigh == "-1000"){
            ideals.idealTemperatureHigh = "NA"
        }
        //handling no ideal light low
        if (ideals.idealLightLevelLow == "-1000"){
            ideals.idealLightLevelLow = "NA"
        }
        //handling no ideal light high
        if (ideals.idealLightLevelHigh == "-1000"){
            ideals.idealLightLevelHigh = "NA"
        }
    }
    var body: some View {
        VStack {
            //scroll view
            ScrollView {
                //if there is a plant type image
                if (plant.imageURL != "") {
                    //image displayed for the given plant
                    URLImage(url: URL(string: plant.imageURL)!) { image in
                        VStack {
                            //image
                            image
                                //styling
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.black)
                        }
                        //styling
                        .frame(width: UIScreen.plantTypeImageSize, height: UIScreen.plantTypeImageSize)
                    }
                }
                else {
                    VStack {
                        //default image
                        Image(systemName: "photo")
                            //styling
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.black)
                    }
                    //styling
                    .frame(width: UIScreen.plantTypeImageSize, height: UIScreen.plantTypeImageSize)
                }
                Divider()
                //plant type of the plant
                Text("\(ideals.plantSelected)")
                    //styling
                    .font(.system(size: UIScreen.titleTextSize))
                Divider()
                VStack(alignment: .leading){
                    //description of the given type
                    (Text("Description: ").bold() +
                        Text("\(plant.description)"))
                        //styling
                        .font(.system(size: UIScreen.subTextSize))
                        .padding(.vertical, 0.5)
                        .lineLimit(nil)
                        .padding(.bottom, 5)
                        .padding(.leading, 5)
                    
                    //ideal moisture values
                    (Text("Ideal Moisture: ").bold() + Text("\(ideals.idealMoistureLow) - \(ideals.idealMoistureHigh)%"))
                        .font(.system(size: UIScreen.subTextSize))
                        //styling
                        .padding(.bottom, 0.5)
                        .padding(.leading, 5)
                    
                    //ideal light values
                    (Text("Ideal Light: ").bold() + Text("\(ideals.idealLightLevelLow) - \(ideals.idealLightLevelHigh) lm"))
                        //styling
                        .font(.system(size: UIScreen.subTextSize))
                        .padding(.bottom, 0.5)
                        .padding(.leading, 5)

                    //ideal temperature values
                    (Text("Ideal Temperature: ").bold() + Text("\(ideals.idealTemperatureLow) - \(ideals.idealTemperatureHigh)°F"))
                        //styling
                        .font(.system(size: UIScreen.subTextSize))
                        .padding(.bottom, 0.5)
                        .padding(.leading, 5)
                }
            }
            Spacer()
        }
    }
}

