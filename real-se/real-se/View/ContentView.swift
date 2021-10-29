//
//  ContentView.swift
//  real-se
//
//  Created by Rei Nakaoka on 2021/10/28.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var mlManeger = MLManeger()

    var body: some View {
        Text(mlManeger.classLabel)
            .padding()
        
        Button("Play") {
            Ch.shared.bgmPlaySound(name: "enter",rate: 0.7)
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
