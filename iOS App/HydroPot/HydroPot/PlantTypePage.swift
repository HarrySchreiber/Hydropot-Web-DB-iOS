//
//  PlantTypePage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct PlantTypePage: View {
    @ObservedObject var plant: Plant
    var body: some View {
        VStack {
            ScrollView {
                Image(systemName: "photo")
                    .font(.system(size: 200))
                Divider()
                Text("\(plant.plantType)")
                    .font(.title)
                Divider()
                VStack(alignment: .leading){
                    (Text("Description: ").bold() +
                        Text("\(plant.description)"))
                        .font(.footnote)
                        .padding(.vertical, 0.5)
                        .lineLimit(nil)
                        .padding(.bottom,5)
                    
                    (Text("Ideal Moisture: ").bold() + Text("\(plant.idealMoistureLow) - \(plant.idealMoistureHigh)%"))
                        .font(.footnote)
                        .padding(.bottom, 0.5)
                    (Text("Ideal Light: ").bold() + Text("\(plant.idealLightLow) - \(plant.idealLightHigh) lm")).font(.footnote)
                        .padding(.bottom, 0.5)
                    (Text("Ideal Temperature: ").bold() + Text("\(plant.idealTempLow) - \(plant.idealTempHigh)°F"))
                        .font(.footnote)
                        .padding(.bottom, 0.5)
                    
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
