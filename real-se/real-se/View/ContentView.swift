//
//  ContentView.swift
//  real-se
//
//  Created by Rei Nakaoka on 2021/10/28.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @ObservedObject var mlManeger = MLManeger()
    @State private var jumptoggle: Bool = true
    
    var body: some View {
//        Text(mlManeger.classLabel)
//            .padding()
        VStack{
            ZStack(alignment: .bottom) {
//                MovieView()
                Image("room")
                    .frame(width: 760, height: 760)
                Image("person_run")
                    .resizable()
                    .frame(width: 160.0, height: 200.0, alignment: .leading)
                    .offset(y: jumptoggle ? -164 : -264)
                    .onAppear(perform: {
                        jumptoggle.toggle()
                    })
                    .animation(Animation.interactiveSpring(dampingFraction: 0.2).repeatForever())
            }
            
            
            VStack(alignment: .leading, spacing: 0) {}
            ZStack {
                Rectangle()
                .fill(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                .frame(width: 414, height: 368)
                .edgesIgnoringSafeArea(.bottom)
                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color(#colorLiteral(red: 0.9490196108818054, green: 0.9490196108818054, blue: 0.9490196108818054, alpha: 1)), lineWidth: 3)
                        .frame(width: 220, height: 260)
                        Text("こうどう")
                            .font(.custom("DragonQuestFC", size: 32))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .padding(8)
                            .background(Color.black)
                            .offset(x: -50, y: -130)
                        Text(mlManeger.classLabel)
                            .font(.custom("DragonQuestFC", size: 80))
                            .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                            .offset(y: -20)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color(#colorLiteral(red: 0.9490196108818054, green: 0.9490196108818054, blue: 0.9490196108818054, alpha: 1)), lineWidth: 3)
                        .frame(width: 128, height: 260)
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
            }.offset(y: -128)
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
