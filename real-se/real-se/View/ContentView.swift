//
//  ContentView.swift
//  real-se
//
//  Created by Rei Nakaoka on 2021/10/28.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @EnvironmentObject var mlManeger: MLManeger
    @ObservedObject var bleManeger = BLEManeger()
    var body: some View {
        VStack{
            ZStack(alignment: .bottom) {
                if bleManeger.inHounse {
                    Image("room")
                        .frame(width: 760, height: 760)
                } else {
                    MovieView()
                        .frame(width: 760, height: 760)
                }
                Image("person_run")
                    .resizable()
                    .frame(width: 160.0, height: 200.0, alignment: .leading)
                    .offset(y: mlManeger.jumptoggle ? -264 : -164)
                    .animation(Animation.interactiveSpring(dampingFraction: 0.2))
                    
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
        ContentView().environmentObject(MLManeger())
    }
}
