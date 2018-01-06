//
//  NetworkApi.swift
//  Quiz
//
//  Created by Perry Davies on 25/09/2017.
//  Copyright © 2017 Perry Davies. All rights reserved.
//

import Foundation
import SystemConfiguration

protocol completed  {
    func complete()
}

final class NetworkApi
{
    static var sharedInstance: NetworkApi = NetworkApi()
    var delegate : completed!
    var players  = [Player]()
    
    enum sessionURL : String
    {
        case baseURLString = "https://cdn.rawgit.com/liamjdouglas/bb40ee8721f1a9313c22c6ea0851a105/raw/6b6fc89d55ebe4d9b05c1469349af33651d7e7f1/Player.json"
    }
    
    private init()
    {
    }
    
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    func fetchPlayersData()
    {
        var session:URLSession = {
            let config = URLSessionConfiguration.ephemeral
            return URLSession(configuration: config)
        }()
        
        let queue = DispatchQueue(label: "players")
        queue.async {
            session = URLSession(configuration: .default)
            session.dataTask(with: self.fanDuelURL(), completionHandler: { (data, response, error) in
                if let data = data
                {
                    self.processData(data: data)
                }
                
            }).resume()
        }
        
    }
    
    func processData(data: Data)
    {
        do
        {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            if let jsonDictionary  = json as? [AnyHashable: Any],
                let playerSections = jsonDictionary  as? [String:Any],
                let allPlayers     = playerSections["players"]  as? [[String:Any]]
            {
                for player in allPlayers
                {
                    let images          = player["images"]      as? [String: Any]
                    let dfalt           = images!["default"]    as? [String: Any]
                    let fName           = player["first_name"]  as? String
                    let lName           = player["last_name"]   as? String
                    let fppg            = player["fppg"]        as? Double
                    let player_Url      = dfalt!["url"]         as? String
                                        
                    let newPlayer = Player(first_Name: fName,
                                           last_Name: lName,
                                           fppg: fppg ?? 0.0,
                                           player_Url: player_Url
                    )
                    players.append(newPlayer)
                }
                DispatchQueue.main.async {
                    self.delegate.complete()
                }
            }
        } catch let error
        {
            print("Failed to fetch players")
        }
    }

    func fanDuelURL() -> URL!
    {
        return URL(string: sessionURL.baseURLString.rawValue)
    }
}
