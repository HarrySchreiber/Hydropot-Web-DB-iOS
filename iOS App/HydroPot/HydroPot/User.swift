//
//  User.swift
//  HydroPot
//
//  Created by Eric  Lisle on 1/27/21.
//

import Foundation

struct UserResults: Codable {
    let Items: [User]
    let Count: Int
    let ScannedCount: Int
}

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let hashedPW: String
    let userName: String
    let pots: [codePot]?
    
    enum CodingKeys: String, CodingKey {
        case id, email, hashedPW, userName, pots
    }
}

class GetUser: ObservableObject {
    @Published var userId: String
    @Published var loggedIn: Bool
    @Published var name: String
    @Published var email: String
    @Published var password: String
    @Published var pots: [Pot]


    init() {
        self.userId = ""
        self.loggedIn = false
        self.name = "Spencer The Cool"
        self.email = ""
        self.password = ""
        self.pots = []
    }
    
    func login (email: String, password: String) {
        
        let json: [String: Any] =
            ["operation": "login", "tableName": "HydroPotUsers", "payload": ["Item": ["email": email, "password": password]]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
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
            let results: UserResults?
            do {
                let decoder = JSONDecoder()
                results = try decoder.decode(UserResults.self, from: d)
            } catch {
                results = nil
            }
            guard let r = results else {
                print("Unable to parse JSON")
                return
            }
            DispatchQueue.main.async(execute: {
                if ((r.Items.count) != 0) {
                    self.userId = r.Items[0].id
                    self.loggedIn = true
                    self.name = r.Items[0].userName
                    self.email = r.Items[0].email
                    self.password = password
                    let codePots = r.Items[0].pots
                    if (codePots?.count != 0){
                        for pot in codePots! {
                            var records : [Record] = []
                            for rec in pot.records! {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                let date = dateFormatter.date(from: rec.dateRecorded)
                                
                                let record = Record(dateRecorded: date!, moisture: rec.moisture, temperature: rec.temperature, light: rec.light, reservoir: rec.reservoir)
                                records.append(record)
                            }
                            var notifications : [Notification] = []
                            for notie in pot.notifications! {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                                let date = dateFormatter.date(from: notie.timeStamp)
                                
                                let notification = Notification(type: notie.type, timeStamp: date!)
                                notifications.append(notification)
                            }
//                            var notifications : [Notification] = []
//                            for notie in pot.! {
//                                let record = Record(dateRecorded: rec.dateRecorded, moisture: rec.moisture, temperature: rec.temperature, light: rec.light, reservoir: rec.reservoir)
//                                records.append(record)
//                            }
                            self.pots.append(Pot(plantName: pot.plantName, plantType: pot.plantType, idealTempHigh: pot.idealTempHigh, idealTempLow: pot.idealTempLow, idealMoistureHigh: pot.idealMoistureHigh, idealMoistureLow: pot.idealLightLow, idealLightHigh: pot.idealLightHigh, idealLightLow: pot.idealLightLow, records: records, notifications: notifications))
                        }
                    }
                }
            })
        }.resume()

        
    }
    
    func changePass(newPass: String) {
        self.password = newPass
    }
    
    func logout() {
        self.userId = ""
        self.loggedIn = false
        self.name = ""
        self.email = ""
        self.password = ""
        self.pots = []
    }
    
    func signup(name: String, email: String, password: String) {
        
        let tempID = UUID()
        
        let json: [String: Any] = ["operation": "signup", "tableName": "HydroPotUsers", "payload": ["Item": ["name": name, "email": email, "password": password, "id": tempID.uuidString]]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "https://695jarfi2h.execute-api.us-east-1.amazonaws.com/production/mobile")!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // insert json data to the request
        request.httpBody = jsonData

        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Accept": "Application/json"]
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in }.resume()
        
        self.userId = tempID.uuidString
        self.loggedIn = true
        self.name = name
        self.email = email
        self.password = password
        self.pots = []

    }
    
    func addPlant(pot: Pot) {
        pots.append(pot)
    }
    
    func replacePot(pot: Pot){
        for (index, _) in pots.enumerated() {
            if (self.pots[index].id == pot.id){
                self.pots[index] = pot
            }
        }
    }
    
}
