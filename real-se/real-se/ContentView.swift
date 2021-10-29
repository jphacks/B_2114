//
//  ContentView.swift
//  Shared
//
//  Created by 宮地篤士 on 2021/10/29.
//

import SwiftUI
import AVKit

struct ContentView: View {
    var body: some View {
            
        VStack{
            MovieView()
            .frame(width: 720, height: 720)
            VStack(alignment: .leading, spacing: 0) {}
            ZStack {
                Rectangle()
                .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                .frame(width: 375, height: 310)
                .edgesIgnoringSafeArea(.bottom)
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color(#colorLiteral(red: 0.9490196108818054, green: 0.9490196108818054, blue: 0.9490196108818054, alpha: 1)), lineWidth: 3)
                        .frame(width: 200, height: 240)
                        Text("こうどう")
                            .font(.custom("DragonQuestFC", size: 32))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .padding(8)
                            .background(Color.black)
                            .offset(x: -50, y: -130)
                        Text("じゃんぷ")
                            .font(.custom("DragonQuestFC", size: 80))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .offset(y: -20)
                       
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color(#colorLiteral(red: 0.9490196108818054, green: 0.9490196108818054, blue: 0.9490196108818054, alpha: 1)), lineWidth: 3)
                        .frame(width: 127, height: 240)
                        Text("にんしき")
                            .font(.custom("DragonQuestFC", size: 32))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .padding(8)
                            .background(Color.black)
                            .offset(x: -12, y: -130)
                        VStack {
                            HStack{
                                Image("arrow")
                                Text("すたーと")
                                    .font(.custom("DragonQuestFC", size: 36))
                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                    .offset(y: -8)
                            }
                            .padding(.bottom, 20)
                            HStack{
                                Rectangle()
                                .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                                .frame(width: 16, height: 31)
                                Text("すとっぷ")
                                    .font(.custom("DragonQuestFC", size: 36))
                                    .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                                    .offset(y: -8)
                            }
                        }.offset(y: -20)
                    }
                }
            }.offset(y: -108)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MovieView: UIViewRepresentable{
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<MovieView>) {
    }
    
    func makeUIView(context: Context) -> UIView {
        return PlayerClass(frame: .zero)
    }
}

class PlayerClass: UIView {
    private let avPlayerLayer = AVPlayerLayer()
    var itemURL: URL?

    let startTime : CMTime = CMTimeMake(value: 2, timescale: 1)

    override init(frame: CGRect) {
    super.init(frame: frame)

    let url = Bundle.main.path(forResource: "load", ofType: "mov")
    let player = AVPlayer(url: URL(fileURLWithPath: url!))

    player.actionAtItemEnd = .none
    player.seek(to: startTime)
    player.play()
    player.rate = 2.0
    avPlayerLayer.player = player

    NotificationCenter.default.addObserver(self,selector: #selector(playerDidEnd(notification:)),name: .AVPlayerItemDidPlayToEndTime,object: player.currentItem)

    layer.addSublayer(avPlayerLayer)

    }

    @objc func playerDidEnd(notification: Notification) {
    if let avPlayerItem = notification.object as? AVPlayerItem {
    avPlayerItem.seek(to: startTime, completionHandler: nil)
    }
    }

    required init?(coder: NSCoder) {
    fatalError("init error")
    }

    override func layoutSubviews() {
    super.layoutSubviews()
    avPlayerLayer.frame = bounds
    }
}
