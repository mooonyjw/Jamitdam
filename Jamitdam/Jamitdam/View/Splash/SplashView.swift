//
//  SplashView.swift
//  Jamitdam
//
//  Created by woni on 11/6/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var isTextVisible = false // Text visibility state

    var body: some View {
        VStack {
            Spacer()

            ZStack {
                Image(systemName: "heart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .blur(radius: 15)
                    .frame(width: isAnimating ? 280 : 220, height: isAnimating ? 280 : 220)
                    .foregroundColor(Color("Redbase"))
                    .animation(
                        .easeInOut(duration: 0.5)
                            .repeatCount(3),
                        value: isAnimating
                    )

                VStack {
                    HStack {
                        Text("지금 가장\n잇한 이야기")
                            .font(.title.bold())
                            .offset(x: isTextVisible ? 0 : 0)
                            .opacity(isTextVisible ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isTextVisible)
                        Spacer()
                    }
                    .padding(.leading, 47)
                    .padding(.top, 180)
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Text("잼잇담")
                            .font(.largeTitle.bold())
                            .font(.system(size: 40, weight: .bold))
                            .offset(x: isTextVisible ? 0 : 0)
                            .opacity(isTextVisible ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isTextVisible)
                        Spacer()
                    }
                    .padding(.leading, 232)
                    .padding(.top, 581)
                    Spacer()
                }
            }
            Button("Button") {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
            }
            Spacer()
        }
        .background(Color("Whitebackground"))
        .ignoresSafeArea()
        .onAppear {
            isAnimating = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                isTextVisible = true
            }
        }
    }
}

#Preview {
    SplashView()
}
