//
//  ContentView.swift
//  BlobIslandEffect
//
//  Created by Pratik Gadhesariya on 26/05/23.
//

import SwiftUI

struct ContentView: View {
    @State private var offset: CGPoint = .zero
    
    private var islandTopPadding: CGFloat = 11.33
    private var islandSize: CGSize = CGSize(width: 126, height: 37.33)
    private var imageSize: CGFloat = 80
    
    var body: some View {
        GeometryReader { bounds in
            ZStack(alignment: .top) {
                Canvas { context, size in
                    context.addFilter(.alphaThreshold(min: 0.5, color: .black))
                    context.addFilter(.blur(radius: 6))
                    
                    context.drawLayer { ctx in
                        if let image = ctx.resolveSymbol(id: "Image") {
                            ctx.draw(image, at: CGPoint(x: (size.width/2), y: (bounds.safeAreaInsets.top + (imageSize/2))))
                        }
                        if let island = ctx.resolveSymbol(id: "Island") {
                            ctx.draw(island, at: CGPoint(x: (size.width/2), y: islandTopPadding + (islandSize.height/2)))
                        }
                    }
                } symbols: {
                    Circle()
                        .fill(.black)
                        .frame(width: imageSize, height: imageSize, alignment: .center)
                        .clipShape(Circle())
                        .scaleEffect(scale)
                        .offset(y: max(-offset.y, -imageSize + imageSize.percentage(20)))
                        .tag("Image")
                    
                    Capsule(style: .continuous)
                        .frame(width: islandSize.width, height: islandSize.height, alignment: .center)
                        .tag("Island")
                        .scaleEffect(islandScale)
                    
                }
                .edgesIgnoringSafeArea(.top)
                
                Image("profilePic")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: imageSize, height: imageSize, alignment: .center)
                    .clipShape(Circle())
                    .scaleEffect(scale)
                    .blur(radius: opacity*3)
                    .opacity(CGFloat(1 - opacity))
                    .offset(y: max(-offset.y, -imageSize + imageSize.percentage(10)))
                
                Circle()
                    .fill(.black)
                    .frame(width: imageSize, height: imageSize, alignment: .center)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .offset(y: max(-offset.y, -imageSize + imageSize.percentage(10)))
                
                OffsetObservingScrollView(offset: $offset) {
                    VStack {
                        ForEach(0..<30) { _ in
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(Color.purple.opacity(0.5))
                                .frame(height: 60)
                        }
                    }
                    .padding(.top, imageSize + 20)
                    .padding(.horizontal)
                }
            }
        }
    }
    
    private var scale: CGFloat {
        let percentage = min(offset.y, imageSize)
        let scale = (percentage * (0 - 1) / 100) + 1
        return min(scale, 1)
    }
    
    private var islandScale: CGFloat {
        var scaleFactor: CGFloat = 1
        scaleFactor = abs((offset.y/2) - 37)/37
        
        let perc = min(max(scaleFactor, 0), 1)
        let scale = (perc * (1 - 1.1)) + 1.1
        return scale
    }
    
    private var opacity: CGFloat {
        let percentage = min(offset.y, imageSize)*2.5
        let opacity = (percentage * (0 - 1) / 100) + 1
        return 1 - min(opacity, 1)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension CGFloat {
    func percentage(_ perc: CGFloat) -> CGFloat {
        self * perc / 100
    }
}
