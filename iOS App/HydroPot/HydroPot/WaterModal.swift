//
//  WaterModal.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct WaterModal: View {
    
    @Binding var showModal: Bool
    
    var body: some View {
         VStack {
             Text("Inside Modal View")
                 .padding()
             Button("Dismiss") {
                 self.showModal.toggle()
             }
         }
    }
}
