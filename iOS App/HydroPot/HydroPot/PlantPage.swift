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
    @ObservedObject var pot: Pot
    @State var screenChange = false
    @State var showingDetail = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Plant Name: \(pot.plantName)")
                NavigationLink(destination: HistoricalData()) {
                    Text("View Historical Data")
                }
                Button(action: {
                    self.showingDetail.toggle()
                }) {
                   Text("Edit Plant")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color(red: 0.142, green: 0.231, blue: 0.498))
                    .cornerRadius(6)
                    .frame(maxWidth: .infinity)
                    .sheet(isPresented: $showingDetail) {
                        EditPlantPage(user: user, showModal: $showingDetail)
                    }
                }
            }
        }
    }
}
