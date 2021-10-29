//
//  MovieView.swift
//  real-se
//
//  Created by Rei Nakaoka on 2021/10/30.
//

import SwiftUI
import AVKit

struct MovieView: View {
    private let player = AVPlayer(url: Bundle.main.url(forResource: "load", withExtension: "mov")!)
    @EnvironmentObject var mlManeger: MLManeger

    init() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player.currentItem, queue: .main) { [self] _ in
            self.player.seek(to: CMTime.zero)
            self.player.play()
        }
    }

    var body: some View {
        VStack {
            PlayerViewController(player: player, rate: mlManeger.movieRate)
                .onAppear(){
                    self.player.play()
                }.edgesIgnoringSafeArea(.all)
        }
    }
}

struct PlayerViewController: UIViewControllerRepresentable {
    var player: AVPlayer!
    var rate: Float!

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller =  AVPlayerViewController()
        controller.modalPresentationStyle = .fullScreen
        controller.player = player
        controller.videoGravity = .resizeAspectFill
        controller.showsPlaybackControls = false
        return controller
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        player.rate = rate
    }
}
