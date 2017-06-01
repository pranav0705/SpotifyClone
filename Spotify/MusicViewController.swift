//
//  MusicViewController.swift
//  Spotify
//
//  Created by Pranav Bhandari on 5/14/17.
//  Copyright © 2017 Pranav Bhandari. All rights reserved.
//

import UIKit
import AVFoundation

class MusicViewController: UIViewController {
    
    var music_img = UIImage()
    var music_name = String()
    var audioURL = String()

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var back_img: UIImageView!
    @IBOutlet weak var playpauseBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        img.image = music_img
        back_img.image = music_img
        name.text = music_name
        if audioURL != "" {
            downloadFileFromURL(url: URL(string : audioURL)!)
            
            playpauseBtn.setTitle("Pause", for: .normal)
        }
        else {
            playpauseBtn.setTitle("No Audio", for: .normal)
            playpauseBtn.isEnabled = false
        }
        
    }
    
    func downloadFileFromURL(url: URL) {
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
            customURL,response,error in
            self.play(url: customURL!)
        })
        downloadTask.resume()
    }
    
    func play(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        }
        catch {
            print(error)
        }
    }
    @IBAction func didTapPlayPause(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            playpauseBtn.setTitle("Play", for: .normal)
        }
        else {
            player.play()
            playpauseBtn.setTitle("Pause", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
