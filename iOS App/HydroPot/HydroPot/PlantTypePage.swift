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
    var body: some View {
        VStack {
            //scroll view
            ScrollView {
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
                Divider()
                //plant type of the plant
                Text("\(plant.plantType)")
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
                    (Text("Ideal Moisture: ").bold() + Text("\(plant.idealMoistureLow) - \(plant.idealMoistureHigh)%"))
                        .font(.system(size: UIScreen.subTextSize))
                        //styling
                        .padding(.bottom, 0.5)
                        .padding(.leading, 5)
                    
                    //ideal light values
                    (Text("Ideal Light: ").bold() + Text("\(plant.idealLightLow) - \(plant.idealLightHigh) lm"))
                        //styling
                        .font(.system(size: UIScreen.subTextSize))
                        .padding(.bottom, 0.5)
                        .padding(.leading, 5)

                    //ideal temperature values
                    (Text("Ideal Temperature: ").bold() + Text("\(plant.idealTempLow) - \(plant.idealTempHigh)°F"))
                        .font(.system(size: UIScreen.subTextSize))
                        //styling
                        .padding(.bottom, 0.5)
                        .padding(.leading, 5)
                }
            }
            Spacer()
        }
    }
}
//
//struct PlantTypePage_Previews: PreviewProvider {
//    static var previews: some View {
//        PlantTypePage(plant: Plant())
//    }
//}
