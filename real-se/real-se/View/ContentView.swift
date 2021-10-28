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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
