//
//  PlantPage.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct PlantPage: View {
    @ObservedObject var user: GetUser
    @State var screenChange = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello World")
                NavigationLink(destination: HistoricalData()) {
                    Text("Do Something")
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
//        Button(action: {
//            screenChange = true
//        }) {
//            Text("Do Something")
//        }
    }
    //navigate(to: MainPageView(), when: $willMoveToNextScreen)
}
