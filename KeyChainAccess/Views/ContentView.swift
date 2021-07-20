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
                Text("Add-Search-Update-Delete\na PASSWORD")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
                
                HStack(spacing:40) {
                    Button(action: {
                        contentVM.add()
                    }, label: {
                        ButtonView(title:"Add", bgColor: Color.green)
                    })
                    
                    Button(action: {
                        contentVM.search()
                    }, label: {
                        ButtonView(title:"Search")
                    })
                }
                
                HStack(spacing:40) {
                    Button(action: {
                        contentVM.update()
                    }, label: {
                        ButtonView(title:"Update", bgColor: Color.orange)
                    })
                    
                    Button(action: {
                        contentVM.delete()
                    }, label: {
                        ButtonView(title:"Delete", bgColor:Color.red)
                    })
                }.padding([.vertical], 20)
            
                
                Text(contentVM.message)
                    .frame(width: nil, height: 80, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.black)
                    .background(Color(#colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)))
                    .padding(.vertical, 20)
                    

                Spacer()
            }
            .padding(.top, 40)
            
            
            .navigationTitle("Keychain Access")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


