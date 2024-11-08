//
//  SplashView.swift
//  Jamitdam
//
//  Created by woni on 11/6/24.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Spacer()

            ZStack {
                Image(systemName: "heart.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .blur(radius: 15)
                    .frame(width: isAnimating ? 250 : 220, height: isAnimating ? 250 : 220)
                    .foregroundColor(Color("Redbase"))
                    .animation(
                        .easeInOut(duration: 0.5)
                            .repeatCount(5),
                        value: isAnimating
                    )
                VStack{
                    HStack {
                        Text("지금 가장\n잇한 이야기")
                            .font(.system(size: 25, weight: <#T##Font.Weight?#>))
                        Spacer()
                    }
                    .padding(.leading, 47)
                    .padding(.top, 180)
                    Spacer()
                }
            }

            Spacer()
        }
        .background(Color("Whitebackground"))
        .ignoresSafeArea()
        .onAppear {
            isAnimating = true
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
