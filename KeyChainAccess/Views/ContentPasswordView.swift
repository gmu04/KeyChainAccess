//
//  ContentPasswordView.swift
//  KeyChainAccess
//
//  Created by Gokhan Mutlu on 20.07.2021.
//

import SwiftUI

struct ContentPasswordView: View {
    var contentVM:ContentViewModel
    
    var body: some View {
        VStack {
            Text("Add-Search-Update-Delete\na PASSWORD")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
            
            HStack(spacing:40) {
                Button(action: {
                    contentVM.addPassword()
                }, label: {
                    ButtonView(title:"Add", bgColor: Color.green)
                })
                
                Button(action: {
                    contentVM.searchPassword()
                }, label: {
                    ButtonView(title:"Search")
                })
            }
            
            HStack(spacing:40) {
                Button(action: {
                    contentVM.updatePassword()
                }, label: {
                    ButtonView(title:"Update", bgColor: Color.orange)
                })
                
                Button(action: {
                    contentVM.deletePassword()
                }, label: {
                    ButtonView(title:"Delete", bgColor:Color.red)
                })
            }.padding([.vertical], 10)
        }
    }
}

struct ContentPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ContentPasswordView(contentVM: ContentViewModel())
    }
}
