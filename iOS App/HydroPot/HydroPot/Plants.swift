//
//  Plants.swift
//  HydroPot
//
//  Created by David Dray on 1/30/21.
//

import Foundation

/*
    codable struct for plantResults used to recieve json data
 */
struct PlantResults: Codable {
    let Items: [codePlant] //values of plants
    let Count: Int //count of plants
    let ScannedCount: Int //num of plants scanned
}


/*
    class of all of the individual plants
 */
class Plants: ObservableObject, Identifiable {
    @Published var plantList: [Plant] //list of individual plants
    @Published var url: URL
    
    /// constructor for plants
    ///
    /// - Parameters:
    ///     - plantList: list of individual plants
    init() {
        self.plantList = []
        self.url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/web")!
    }
    
    /// allows for determining if the plant list contains a given plant
    ///
    /// - Parameters:
    ///     - plantName: name of the plant we want
    /// - Returns:
    ///     - a bool that represents if the plant is within the list
    ///
    func contains(plantName: String) -> Bool {
        //for all the plants
        for (index, _) in plantList.enumerated() {
            //if we find our plant
            if (self.plantList[index].plantType == plantName){
                //success
                return true
            }
        }
        //failure
        return false
    }
    
    /// allows for getting a plant by it's name
    ///
    /// - Parameters:
    ///     - plantName: name of the plant we want
    /// - Returns:
    ///     - the plant with the given name
    ///
    func getPlant(plantName: String) -> Plant {
        //for ever plant type
        for (index, _) in plantList.enumerated() {
            //if we found our plant
            if (self.plantList[index].plantType == plantName){
                //return that plant
                return plantList[index]
            }
        }
        //return garabge plant
        return Plant(plantType: "Non-existent plant", idealTempLow: 0, idealTempHigh: 0, idealMoistureLow: 0, idealMoistureHigh: 0, idealLightLow: 0, idealLightHigh: 0, description: "This plant should never show up", imageURL: "")
    }
    
    /// gets all of the plant types from the db and adds to this class' plant list
    func getPlantsList() {
        
        plantList = [] //empty the current list
        
        //operation for the request
        let json: [String: Any] =
            ["operation": "getAll",
             "userID": "",
             "tableName": "HydroPotPlantTypes"]
        
        //serlialize our payload
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        //make the request
        var request = URLRequest(url: url)
        
        //post the request
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData
        
        //accept results
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
                //decode results
                let decoder = JSONDecoder()
                results = try decoder.decode(PlantResults.self, from: d)
            } catch {
                //if failure
                print(error)
                results = nil
            }
            //if not able to parse with codable
            guard let r = results else {
                print("Unable to parse JSON")
                return
            }
            
            //execute the async call
            DispatchQueue.main.async(execute: {
                //if items were returned
                if ((r.Items.count) != 0) {
                    //for each plant type
                    for plant in r.Items {
                        //append the new plant type to the list of plants
                        self.plantList.append(Plant(
                            plantType: plant.plantType,
                            idealTempLow: plant.idealTempLow ?? -1000,
                            idealTempHigh: plant.idealTempHigh ?? -1000,
                            idealMoistureLow: plant.idealMoistureLow ?? -1000,
                            idealMoistureHigh: plant.idealMoistureHigh ?? -1000,
                            idealLightLow: plant.idealLightLow ?? -1000,
                            idealLightHigh: plant.idealLightHigh ?? -1000,
                            description: plant.description ?? "No description available",
                            imageURL: plant.imageURL ?? ""))
                    }
                }
                //sort the plant list by type
                self.plantList = self.plantList.sorted(by: { $0.plantType < $1.plantType })

                self.plantList.insert(Plant(plantType: "Other", idealTempLow: -1000, idealTempHigh: -1000, idealMoistureLow: -1000, idealMoistureHigh: -1000, idealLightLow: -1000, idealLightHigh: -1000,description: "", imageURL: ""), at: 0)
            })
        }.resume()
    }
}
