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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(playButton)
        view.addSubview(stopButton)
        setupContraints()
        initPlayer()

    }
    
    
    func initPlayer(){
        do {
            player = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "Queen", ofType: "mp3")!))
            player.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
    
    func setupContraints(){
        let safeAreaGuide = view.safeAreaLayoutGuide
        let constraint = [
            playButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -64),
            playButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 64),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            stopButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -64),
            stopButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -64),
            stopButton.widthAnchor.constraint(equalToConstant: 50),
            stopButton.heightAnchor.constraint(equalToConstant: 50)
            
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
