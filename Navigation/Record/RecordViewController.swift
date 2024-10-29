//
//  RecordViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 26.04.2024.
//

import UIKit
import AVFAudio
import AVFoundation


class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var recordSession: AVAudioSession!
    var isRecord: Bool = false
    var recordingName: URL!
    
    private lazy var recordButton: CustomButton = {
        let button = CustomButton(){
            if(self.audioRecorder != nil){
                self.finishAudioRecording(success: true)
            }else{
                self.startRecord()
            }
            
        }
        button.setImage(UIImage(systemName: "record.circle"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private lazy var playButton: CustomButton = {
        let button = CustomButton(){
            self.play()
        }
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPermission()
        setupView()
        addSubviews()
        setupConstraints()
        
    }
    
    private func setupView() {
        view.backgroundColor = .customBackgroundColor
    }
    
    private func addSubviews() {
        view.backgroundColor = .white
        recordingName = getDirectoryUrl().appendingPathComponent("output.m4a")
        view.addSubview(recordButton)
        view.addSubview(playButton)
    }
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            recordButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -64),
            recordButton.leadingAnchor.constraint(equalTo: safeAreaGuide.leadingAnchor, constant: 64),
            recordButton.widthAnchor.constraint(equalToConstant: 50),
            recordButton.heightAnchor.constraint(equalToConstant: 50),
            
            
            playButton.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -64),
            playButton.trailingAnchor.constraint(equalTo: safeAreaGuide.trailingAnchor, constant: -64),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
    }
    
    private func audioPermission() {
        // Нужен еще пермишн прописать в info
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("Доступ разрешен")
            } else {
                print("Доступ запрещен")
            }
        }
    }
    
    
    func startRecord(){
        if audioRecorder == nil {
            
            setupRecorder()
            
            recordButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            
            audioRecorder.record()
        }
    }
    
    private func getDirectoryUrl() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    private func setupRecorder() {
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            
            audioRecorder = try AVAudioRecorder(url: recordingName, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            
        } catch {
            
            finishAudioRecording(success: false)
            print(#line, #function, error.localizedDescription)
        }
    }
    
    private func finishAudioRecording(success: Bool) {
        
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            print("Успешная запись :)")
        } else {
            print("Что-то пошло не так :(")
        }
        recordButton.setImage(UIImage(systemName: "record.circle"), for: .normal)
    }
    
    private func play(){
        do {
            if(self.audioPlayer == nil){
                audioPlayer = try AVAudioPlayer(contentsOf: recordingName)
                audioPlayer.prepareToPlay()
                audioPlayer.volume = 5
                audioPlayer.play()
                audioPlayer.delegate = self
                playButton.setImage(UIImage(systemName: "stop.fill"), for: .normal)
            }
        } catch {
            self.audioPlayer = nil
        }
    }
    
     func stpoPlay(){
        self.audioPlayer.stop()
        self.audioPlayer = nil
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }


}

extension RecordViewController: AVAudioPlayerDelegate{
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
        self.stpoPlay()
    }
}
