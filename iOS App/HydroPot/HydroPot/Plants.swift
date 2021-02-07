//
//  Plants.swift
//  HydroPot
//
//  Created by David Dray on 1/30/21.
//

import Foundation



class Plant: ObservableObject, Identifiable {
    @Published var plantType: String
    @Published var idealTempLow: Int
    @Published var idealTempHigh: Int
    @Published var idealMoistureLow: Int
    @Published var idealMoistureHigh: Int
    @Published var idealLightLow: Int
    @Published var idealLightHigh: Int
    @Published var description: String
    
    init(plantType: String, idealTempLow: Int, idealTempHigh: Int, idealMoistureLow: Int, idealMoistureHigh: Int,
         idealLightLow: Int, idealLightHigh: Int, description: String) {
        self.plantType = plantType
        self.idealTempLow = idealTempLow
        self.idealTempHigh = idealTempHigh
        self.idealMoistureLow = idealMoistureLow
        self.idealMoistureHigh = idealMoistureHigh
        self.idealLightLow = idealLightLow
        self.idealLightHigh = idealLightHigh
        self.description = description
    }
    
}


struct PlantResults: Codable {
    let Items: [codePlant]
    let Count: Int
    let ScannedCount: Int
}

struct codePlant: Codable, Identifiable {
    let id: String
    let description: String
    let idealLightHigh: Int
    let idealLightLow: Int
    let idealMoistureHigh: Int
    let idealMoistureLow: Int
    let idealTempHigh: Int
    let idealTempLow: Int
    let plantType: String
    
    enum CodingKeys: String, CodingKey {
        case id, description, idealLightHigh, idealLightLow, idealMoistureHigh, idealMoistureLow,
             idealTempHigh, idealTempLow, plantType
    }
}


class Plants: ObservableObject, Identifiable {
    @Published var plantList: [Plant]
    
    init() {
        self.plantList = []
    }
    
    func contains(plantName: String) -> Bool {
        for (index, _) in plantList.enumerated() {
            if (self.plantList[index].plantType == plantName){
                return true
            }
        }
        return false
    }
    
    /* DO NOT USE UNLESS YOU HAVE CALLED CONTAINS FIRST*/
    func getPlant(plantName: String) -> Plant {
        for (index, _) in plantList.enumerated() {
            if (self.plantList[index].plantType == plantName){
                return plantList[index]
            }
        }
        return Plant(plantType: "Non-existent plant", idealTempLow: 0, idealTempHigh: 0, idealMoistureLow: 0, idealMoistureHigh: 0, idealLightLow: 0, idealLightHigh: 0, description: "This plant should never show up")
    }
    
    func getPlantsList() {
        
        let json: [String: Any] =
            ["operation": "getAll", "tableName": "HydroPotPlantTypes"]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/web")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData
        
        
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        // start a data task to download the data from the URL
        
        
        session.dataTask(with: request) { data, response, error in
            // make sure data is not nil
            guard let d = data else {
                print("Unable to load data")
                return
            }
            
            // decode the returned data into Codable structs
            let results: PlantResults?
            do {
                let decoder = JSONDecoder()
                results = try decoder.decode(PlantResults.self, from: d)
            } catch {
                print(error)
                results = nil
            }
            guard let r = results else {
                print("Unable to parse JSON")
                return
            }
            DispatchQueue.main.async(execute: {
                if ((r.Items.count) != 0) {
                    for plant in r.Items {
                        self.plantList.append(Plant(
                            plantType: plant.plantType,
                            idealTempLow: plant.idealTempLow,
                            idealTempHigh: plant.idealTempHigh,
                            idealMoistureLow: plant.idealMoistureLow,
                            idealMoistureHigh: plant.idealMoistureHigh,
                            idealLightLow: plant.idealLightLow,
                            idealLightHigh: plant.idealLightHigh,
                            description: plant.description))
                    }
                    print("number of list elements inside: \(self.plantList.count)")
                }
            })
        }.resume()
        print("number of list elements outside: \(self.plantList.count)")
    }
    
}
