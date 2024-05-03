//
//  AudioViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 25.04.2024.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {
    
    var player = AVAudioPlayer()
    
    var trackNumber = 0
    
    let soungs = [ "Linkin Park – What I've Done", "Linkin Park – Part of Me Hybrid Theory EP", "Linkin Park – New Divide", "Linkin Park – In the End", "Queen"
    ]
    
    
    private lazy var nameSong: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    private lazy var playButton: CustomButton = {
        let button = CustomButton(){
            self.play()
        }
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var stopButton: CustomButton = {
        let button = CustomButton(){
            self.stop()
        }
        button.setImage(UIImage(systemName: "stop.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nextTrackButton: CustomButton = {
        let button = CustomButton(){
            self.nextTrack()
        }
        button.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private lazy var backTrackButton: CustomButton = {
        let button = CustomButton(){
            self.backTrack()
        }
        button.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(nameSong)
        view.addSubview(playButton)
        view.addSubview(stopButton)
        view.addSubview(nextTrackButton)
        view.addSubview(backTrackButton)
        setupContraints()
        initPlayer()

    }
    
    
    func initPlayer(){
        do {
            let track = soungs[trackNumber]
            nameSong.text = track
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: track, ofType: "mp3")!))
            player.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    func nextTrack(){
        if trackNumber == (soungs.count - 1){
            trackNumber = 0
        }else {
            trackNumber += 1
        }
        initPlayer()
        player.play()
    }
    
    func backTrack(){
        if trackNumber == 0{
            trackNumber = soungs.count - 1
        }else {
            trackNumber -= 1
        }
        initPlayer()
        player.play()
    }

    
    func setupContraints(){
        let safeAreaGuide = view.safeAreaLayoutGuide
        let constraint = [
            
            nameSong.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 64),
            nameSong.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 64),
            nameSong.widthAnchor.constraint(equalTo: safeAreaGuide.widthAnchor),
            nameSong.heightAnchor.constraint(equalToConstant: 50),
            
            
            playButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -64),
            playButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 64),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            stopButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -64),
            stopButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -64),
            stopButton.widthAnchor.constraint(equalToConstant: 50),
            stopButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            nextTrackButton.bottomAnchor.constraint(equalTo: stopButton.topAnchor, constant: -64),
            nextTrackButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -64),
            nextTrackButton.widthAnchor.constraint(equalToConstant: 50),
            nextTrackButton.heightAnchor.constraint(equalToConstant: 50),
            
            backTrackButton.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -64),
            backTrackButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 64),
            backTrackButton.widthAnchor.constraint(equalToConstant: 50),
            backTrackButton.heightAnchor.constraint(equalToConstant: 50),
            
            
        ]
        NSLayoutConstraint.activate(constraint)
    }
    
    
    
    func play() {
        if player.isPlaying{
            self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            player.stop()
        }else{
            self.playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            player.play()
        }
        
        
    }
    
    func stop() {
            player.stop()
            self.playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            initPlayer()
    }


}
