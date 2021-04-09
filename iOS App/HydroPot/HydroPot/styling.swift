//
//  styling.swift
//  HydroPot
//
//  Created by David Dray on 4/8/21.
//

import Foundation

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    
    //nav bar values
    static let plusImageSize = screenWidth / 12
    static let chevImage = screenWidth / 26
    
    //home values
    static let homeImageSize = screenWidth / 4 //base is 80 (ipod 7gen)
    static let homePicSize = screenWidth / 4 //base is 80 (ipod 7gen)
    static let regTextSize = screenWidth / 18.8 // base is 17
    static let title2TextSize = screenWidth / 14.5 //base is 22
    static let subTextSize = screenWidth / 24.6  //base is 13
    static let lastWateredSize = screenWidth / 2.56 //base is 125
    static let homeCardsSize = screenWidth / 32 //base is 10
    
    //login values
    static let modalWidth = screenWidth / 1.14 //base is 280
    
    //plant type page values
    static let titleTextSize = screenWidth / 11.4  //base is 28
    static let plantTypeImageSize = screenWidth / 1 //base is 200
    
    //plant list page values
    static let plantTypeListImageSize = screenWidth / 4
    static let searchPadding = screenWidth / 320
    
    //historical Data page values
    static let title3TextSize = screenWidth / 16  //base is 20
    static let zStackWidth = modalWidth - (screenWidth / 10) //base is about 270
    static let zStackHeight = screenWidth / 2.13  //base is 150
    static let panelWidth = screenWidth
    static let panelHeight = screenWidth / 1.4 //base is 225
    static let graphWidth = screenWidth / 16 // base is 20
    static let textOffset = screenWidth / 9.14 //base is 30
    static let graphTextLen = screenWidth / 133 // base is 2.4
    static let graphMultiplier = screenWidth / 22.9 //base is 14
    static let graphPadding = screenWidth / 64 //base is 5
    
    //add edit value
    static let imageSelection = screenWidth / 3
    static let addPhotoPadding = screenWidth / 100
    
    //plant page values
    static let plantBoxWidth = screenWidth / 1.06 //base is 300
    static let plantBoxHeight = homeImageSize
    static let plantButtonWidth = screenWidth / 2 //base is 300
    static let plantButtonHeight = homeImageSize / 2
    static let plantBoxIdealsDistance = screenWidth / 5.4 //base is 60
    static let plantTitleBottom = screenWidth / 16 //base is 20
    static let plantTitleSide = screenWidth / 10.6 //base is 30
    static let resLevelPadding = screenWidth / 5.5  //base is ~57
    static let plantImage = screenWidth / 2

}
