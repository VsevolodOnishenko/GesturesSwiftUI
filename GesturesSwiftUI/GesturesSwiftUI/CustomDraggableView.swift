//
//  CustomDraggableView.swift
//  GesturesSwiftUI
//
//  Created by Vsevolod Onishchenko on 17.01.2020.
//  Copyright © 2020 oneactionapp. All rights reserved.
//

import SwiftUI

enum DragState {
    case inactive
    case pressing
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive, .pressing:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isPressing: Bool {
        switch self {
        case .pressing, .dragging:
            return true
        case .inactive:
            return false
        }
    }
}

struct CustomDraggableView<Content>: View where Content: View {
    
    @GestureState private var dragState = DragState.inactive
    @State private var position = CGSize.zero
    
    var content: () -> Content
    
    var body: some View {
        content()
            .opacity(dragState.isPressing ? 0.5 : 1.0)
            .offset(x: position.width + dragState.translation.width,
                    y: position.height + dragState.translation.height)
            .animation(.easeInOut)
            .gesture(
                LongPressGesture(minimumDuration: 1.0)
                    .sequenced(before: DragGesture())
                    .updating($dragState, body: { (value, state, transaction) in
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
                        self.position.height += drag.translation.height
                        self.position.width += drag.translation.width
                    })
        )
    }
}

struct CustomDraggableView_Previews: PreviewProvider {
    static var previews: some View {
        CustomDraggableView() {
            Text("Template")
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .bold()
                .foregroundColor(.green)
        }
    }
}
