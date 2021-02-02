//
//  PlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct PlantPage: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var user: GetUser
    @State var screenChange = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello World")
                NavigationLink(destination: HistoricalData()) {
                    Text("Do Something")
                }
                NavigationLink(destination: EditPlantPage(user: user)) {
                    Text("Do Something Two")
                }
            }
        }
    }
}
