//
//  ViewController.swift
//  Spotify
//
//  Created by Pranav Bhandari on 5/14/17.
//  Copyright © 2017 Pranav Bhandari. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    typealias JsonType = [String : AnyObject]
    
    var url = "https://api.spotify.com/v1/search?q=Shreya+Ghosal&type=track"
    
    var names = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        callAlamo(url: url)
    }
    
    func callAlamo(url : String) {
        Alamofire.request(url).response(completionHandler: {
            resonse in
            self.parseJSON(data: resonse.data!)
        })
    }
    
    func parseJSON(data: Data){
        do {
            var result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JsonType
            if let tracks = result?["tracks"] as? JsonType {
                if let items = tracks["items"] as? [JsonType] {
                    for i in 0..<items.count {
                        let item = items[i]
                        let name = item["name"] as! String
                        names.append(name)
                        
                    }
                }
            }
        }
        catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

