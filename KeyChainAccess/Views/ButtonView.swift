//
//  ButtonView.swift
//  KeyChainAccess
//
//  Created by Gokhan Mutlu on 19.07.2021.
//

import SwiftUI

struct ButtonView: View {
    var title:String
    var bgColor = Color.blue
    var body: some View {
        Text(title)
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            .frame(minWidth:100)
            .padding()
            .background(bgColor)
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(title: "title")
    }
}
