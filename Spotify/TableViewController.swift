//
//  ViewController.swift
//  Spotify
//
//  Created by Pranav Bhandari on 5/14/17.
//  Copyright © 2017 Pranav Bhandari. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

var player = AVAudioPlayer()

struct artistDetails {
    let image : UIImage!
    let name : String!
    let audioURL : String!
}

class TableViewController: UITableViewController, UISearchBarDelegate {
    typealias JsonType = [String : AnyObject]
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var url = String()
    
    var artist = [artistDetails]()

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let keywords = searchBar.text
        let finalkeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        
     url = "https://api.spotify.com/v1/search?q=\(finalkeywords!)&type=track"
        print(url)
        artist.removeAll()
        callAlamo(url: url)
        tableView.reloadData()
        self.view.endEditing(true)
    }
    
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
                        var aud_url = ""
                        if let audioURL = item["preview_url"] as? String {
                            aud_url = audioURL
                        }
                        
                        if let album = item["album"] as? JsonType {
                            if let image = album["images"] as? [JsonType] {
                                let imgURL = image[0]
                                let imageFetch = URL(string: imgURL["url"] as! String)
                                let imgData = NSData(contentsOf: imageFetch!)
                                let img = UIImage(data: imgData! as Data)
                                
                                artist.append(artistDetails.init(image: img, name: name, audioURL: aud_url))
                                tableView.reloadData()
                            }
                        }
                        
                        
                    }
                }
            }
        }
        catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artist.count
    }
    
    // create a cell for each table view row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell!
        
        let imgCell = cell.viewWithTag(2) as! UIImageView
        let nameCell = cell.viewWithTag(1) as! UILabel
        
        imgCell.image = artist[indexPath.row].image
        nameCell.text = artist[indexPath.row].name
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        
        let viewController = segue.destination as! MusicViewController
        
        viewController.music_img = artist[indexPath!].image
        viewController.music_name = artist[indexPath!].name
        viewController.audioURL = artist[indexPath!].audioURL
    }
}

