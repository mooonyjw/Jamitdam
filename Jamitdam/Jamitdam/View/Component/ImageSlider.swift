import SwiftUI

struct ImageSlider: View {
    @State var imageUrls: [String]
    // 현재 사진 index
    @State private var activeIndex = 0
    // 드래그 제스처의 offset
    @State private var offset: CGFloat = 0.0
    // 이미지 확대 보기 상태
    @State private var isImageViewerPresented: Bool = false

    var height = UIScreen.main.bounds.height * 0.45

    // 사진 높이
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(imageUrls.indices, id: \.self) { index in
                    Image(imageUrls[index])
                        .resizable()
                        // 비율 유지하며 꽉 채우기
                        .scaledToFill()
                        .frame(width: geometry.size.width - 60, height: height)
                        .clipped()
                        .cornerRadius(20)
                        .shadow(radius: 5)
                        // 현재 인덱스 이미지와 다른 이미지는 투명도 조절
                        .opacity(index == activeIndex ? 1 : 0.6)
                        .offset(x: CGFloat(index - activeIndex) * geometry.size.width + offset)
                        .animation(.easeInOut, value: offset)
                        .onTapGesture {
                            // 사진 클릭 시 원본 크기로 보기 위한 모달 표시
                            isImageViewerPresented = true
                        }
                }
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        offset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold = geometry.size.width / 3
                        let translation = value.translation.width
                        if translation < -threshold && activeIndex < imageUrls.count - 1 {
                            activeIndex += 1
                        } else if translation > threshold && activeIndex > 0 {
                            activeIndex -= 1
                        }
                        offset = 0
                    }
            )
            .sheet(isPresented: $isImageViewerPresented) {
                ImageDetail(imageName: imageUrls[activeIndex])
            }
        }
        .frame(height: height)
        .padding(.horizontal, 30)
    }
}

struct ImageDetail: View {
    let imageName: String
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Image(imageName)
                    .resizable()
                    // 원본 이미지 전체가 화면에 맞게 보이도록
                    .scaledToFit()
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height)
                Spacer()
            }
            .background(Color.black.opacity(0.8))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ImageSlider(imageUrls: ["UserProfile1", "UserProfile2", "UserProfile3", "UserProfile4", "UserProfile5"])
}
