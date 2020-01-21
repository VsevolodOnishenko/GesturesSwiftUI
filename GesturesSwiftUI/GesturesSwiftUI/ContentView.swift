//
//  ContentView.swift
//  GesturesSwiftUI
//
//  Created by Vsevolod Onishchenko on 17.01.2020.
//  Copyright © 2020 oneactionapp. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @GestureState private var longPressTap = false
    @State private var isPressed = false
    
    @GestureState private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero
    
    @GestureState private var dragState = DragState.inactive
    @State private var positionCloud = CGSize.zero
    
    var body: some View {
        VStack {
            
            Image(systemName: "cloud")
                .font(.system(size: 150))
                .opacity(dragState.isPressing ? 0.5 : 1.0)
                .offset(x: positionCloud.width + dragState.translation.width,
                        y: positionCloud.height + dragState.translation.height)
                .animation(.easeInOut)
                .foregroundColor(.blue)
                .gesture(
                    LongPressGesture(minimumDuration: 1.0)
                        .sequenced(before: DragGesture())
                        .updating($dragState, body: { value, state, transaction in
                            switch value {
                            case .first(true):
                                state = .pressing
                            case .second(true, let drag):
                                state = .dragging(translation: drag?.translation ?? .zero)
                            default:
                                break
                            }
                        })
                        .onEnded({ value in
                            guard case .second(true, let drag?) = value else {
                                return
                            }
                            self.positionCloud.height += drag.translation.height
                            self.positionCloud.width += drag.translation.width
                        })
            ).padding(.bottom, 100)
               
    
            Image(systemName: "arkit")
                .font(.system(size: 150))
                .offset(x: position.width + dragOffset.width, y: position.height + dragOffset.height)
                .animation(.easeInOut)
                .foregroundColor(.purple)
                .gesture(
                    DragGesture()
                        .updating($dragOffset, body: { (value, state, transaction) in
                            state = value.translation
                        })
                        .onEnded({ value in
                            self.position.height += value.translation.height
                            self.position.width += value.translation.width
                        })
            ).padding(.bottom, 100)
            
            Image(systemName: "star.circle.fill")
                .font(.system(size: 150))
                .opacity(longPressTap ? 0.4 : 1.0)
                .scaleEffect(isPressed ? 0.5 : 1.0)
                .animation(.easeInOut)
                .foregroundColor(.green)
                .gesture(
                    LongPressGesture(minimumDuration: 1.0)
                        .updating($longPressTap, body: { (currentState, state, transaction) in
                            state = currentState
                        })
                        .onEnded({ _ in
                            self.isPressed.toggle()
                        })
//                    LongPressGesture(minimumDuration: 1.0)
//                        .onEnded({ _ in
//                            self.isPressed.toggle()
//                        })
//                    TapGesture()
//                        .onEnded({
//                            self.isPressed.toggle()
//                        })
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
