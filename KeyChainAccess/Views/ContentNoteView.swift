//
//  ContentPasswordView.swift
//  KeyChainAccess
//
//  Created by Gokhan Mutlu on 20.07.2021.
//

import SwiftUI

struct ContentNoteView: View {
    var contentVM:ContentViewModel
    
    var body: some View {
        VStack {
            Text("Add-Search-Update-Delete\na NOTE")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            HStack(spacing:40) {
                Button(action: {
                    contentVM.addNote()
                }, label: {
                    ButtonView(title:"Add", bgColor: Color.green)
                })
                
                Button(action: {
                    contentVM.fetchNotes()
                }, label: {
                    ButtonView(title:"Search")
                })
            }
            
            HStack(spacing:40) {
                Button(action: {
                    contentVM.updateNote()
                }, label: {
                    ButtonView(title:"Update", bgColor: Color.orange)
                })
                
                Button(action: {
                    contentVM.deleteNote()
                }, label: {
                    ButtonView(title:"Delete", bgColor:Color.red)
                })
            }.padding([.vertical], 10)
        }
    }
}

struct ContentNoteView_Previews: PreviewProvider {
    static var previews: some View {
        ContentNoteView(contentVM: ContentViewModel())
    }
}
