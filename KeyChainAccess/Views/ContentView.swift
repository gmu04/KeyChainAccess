//
//  ContentView.swift
//  KeyChainAccess
//
//  Created by Gokhan Mutlu on 19.07.2021.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var contentVM = ContentViewModel()
    let width = UIScreen.main.bounds.size.width
    
    var body: some View {
        NavigationView {
            VStack {
                
                ContentPasswordView(contentVM: contentVM)

                Text(contentVM.message)
                    .frame(width: nil, height: 80, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.black)
                    .background(Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)))
                    .padding(.vertical, 20)
                    
                ContentNoteView(contentVM: contentVM)
                Spacer()
            }
            
            .navigationTitle("Keychain Access")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


