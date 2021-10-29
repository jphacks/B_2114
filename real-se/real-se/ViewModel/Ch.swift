//
//  Ch.swift
//  real-se
//
//  Created by 吉川莉央 on 2021/10/29.
//

import AVFoundation
import Foundation

class Ch {
    static let shared = Ch()
    var description: String = ""
    
    var bgmPlayer: AVAudioPlayer!
    var sePlayer: AVAudioPlayer!
    
    private init() {}
  
    func bgmPlaySound(name: String, loopNum: Int = -1, rate: Float) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("音源ファイルが見つかりません")
            return
        }
        do {
            // AVAudioPlayerのインスタンス化
            bgmPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            // AVAudioPlayerのデリゲートをセット
//            bgmPlayer.delegate = self
            // 音声の再生
            bgmPlayer.enableRate = true
            bgmPlayer.volume = 0.5
            bgmPlayer.rate = rate
            bgmPlayer.numberOfLoops = loopNum
            bgmPlayer.play()
        } catch {
            print("Error")
        }
    }
    
    func stopBgm(){
        if bgmPlayer != nil{
            bgmPlayer.stop()
            
        }
    }
    
    func changeRateBgm(rate: Float){
        if bgmPlayer != nil{
            bgmPlayer.rate = rate
            
        }
    }
    
    func sePlaySound(name: String, loopNum: Int = 1) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("音源ファイルが見つかりません")
            return
        }
        do {
            // AVAudioPlayerのインスタンス化
            sePlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            // AVAudioPlayerのデリゲートをセット
//            sePlayer.delegate = self
            // 音声の再生
            sePlayer.volume = 1.0
            sePlayer.numberOfLoops = loopNum
            sePlayer.play()
        } catch {
            print("Error")
        }
    }
    
}
