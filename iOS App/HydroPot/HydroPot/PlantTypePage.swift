//
//  PlantTypePage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI
import URLImage

struct PlantTypePage: View {
    @ObservedObject var plant: Plant
    var body: some View {
        VStack {
            ScrollView {
                URLImage(url: URL(string: plant.imageURL)!) { image in
                    VStack {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.black)
                    }.frame(width: UIScreen.plantTypeImageSize, height: UIScreen.plantTypeImageSize)
                }
                Divider()
                Text("\(plant.plantType)")
                    .font(.system(size: UIScreen.titleTextSize))
                Divider()
                VStack(alignment: .leading){
                    (Text("Description: ").bold() +
                        Text("\(plant.description)"))
                        .font(.system(size: UIScreen.subTextSize))
                        .padding(.vertical, 0.5)
                        .lineLimit(nil)
                        .padding(.bottom, 5)
                        .padding(.leading, 5)
                    
                    (Text("Ideal Moisture: ").bold() + Text("\(plant.idealMoistureLow) - \(plant.idealMoistureHigh)%"))
                        .font(.system(size: UIScreen.subTextSize))
                        .padding(.bottom, 0.5)
                        .padding(.leading, 5)

                    (Text("Ideal Light: ").bold() + Text("\(plant.idealLightLow) - \(plant.idealLightHigh) lm"))
                        .font(.system(size: UIScreen.subTextSize))
                        .padding(.bottom, 0.5)
                        .padding(.leading, 5)

                    (Text("Ideal Temperature: ").bold() + Text("\(plant.idealTempLow) - \(plant.idealTempHigh)°F"))
                        .font(.system(size: UIScreen.subTextSize))
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
