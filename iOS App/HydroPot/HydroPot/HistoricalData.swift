//
//  HistoricalData.swift
//  HydroPot
//
//  Created by David Dray on 1/27/21.
//

import SwiftUI

struct HistoricalData: View {
    var body: some View {
        ScrollView {
            VStack {
                PagesContainer(contentCount: 2) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.green.opacity(0.3))
                            .padding()
                        Text("Temperature").frame(width: 275, height: 150, alignment: .topLeading)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.green.opacity(0.3))
                            .padding()
                        Text("Temperature").frame(width: 275, height: 150, alignment: .topLeading)
                        VStack {
                            Text("High: 73")
                                .font(.callout)
                                .padding(.vertical)
                                .foregroundColor(Color.gray)
                            Text("Average: 68")
                                .font(.callout)
                                .padding(.bottom)
                                .foregroundColor(Color.gray)
                            Text("Low: 64")
                                .font(.callout)
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                .frame(width: 325, height: 225) //scaling thing later
                
                PagesContainer(contentCount: 2) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.red.opacity(0.3))
                            .padding()
                        Text("Light Level").frame(width: 275, height: 150, alignment: .topLeading)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.red.opacity(0.3))
                            .padding()
                        Text("Light Level").frame(width: 275, height: 150, alignment: .topLeading)
                        VStack {
                            Text("High: 3805")
                                .font(.callout)
                                .padding(.vertical)
                                .foregroundColor(Color.gray)
                            Text("Average: 3400")
                                .font(.callout)
                                .padding(.bottom)
                                .foregroundColor(Color.gray)
                            Text("Low: 1200")
                                .font(.callout)
                                .foregroundColor(Color.gray)
                        }
                    }
                }.frame(width: 325, height: 225)
                
                PagesContainer(contentCount: 2) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.blue.opacity(0.3))
                            .padding()
                        Text("Soil Moisture").frame(width: 275, height: 150, alignment: .topLeading)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color.blue.opacity(0.3))
                            .padding()
                        Text("Soil Moisture").frame(width: 275, height: 150, alignment: .topLeading)
                        VStack {
                            Text("High: 30%")
                                .font(.callout)
                                .padding(.vertical)
                                .foregroundColor(Color.gray)
                            Text("Average: 23%")
                                .font(.callout)
                                .padding(.bottom)
                                .foregroundColor(Color.gray)
                            Text("Low: 15%")
                                .font(.callout)
                                .foregroundColor(Color.gray)
                        }
                    }
                }.frame(width: 325, height: 225)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct PagesContainer <Content : View> : View {
    let contentCount: Int
    @State var index: Int = 0
    let content: Content
    @GestureState private var translation: CGFloat = 0
    
    init(contentCount: Int, @ViewBuilder content: () -> Content) {
        self.contentCount = contentCount
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack (spacing: 0){
                    self.content
                        .frame(width: geometry.size.width)
                }
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

struct HistoricalData_Previews: PreviewProvider {
    static var previews: some View {
        HistoricalData()
    }
}
