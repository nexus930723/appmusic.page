import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

struct ContentView: View {
    private let featuredToRecentGap: CGFloat = 29
    private let miniPlayerOuterHorizontalPadding: CGFloat = 8
    private let tabBarLift: CGFloat = 8
    private let tabBarItemSpacing: CGFloat = 0
    private let tabBarVerticalPadding: CGFloat = 6

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("首頁")
                            .font(.system(size: 32, weight: .bold))
                        Spacer()
                        Circle()
                            .fill(Color.gray.opacity(0.7))
                            .frame(width: 36, height: 36)
                            .overlay(
                                Text("陳")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)

                    FeaturedSectionView()
                        .padding(.bottom, featuredToRecentGap)

                    VStack(alignment: .leading, spacing: 13) {
                        Text("最近播放")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                RecentPlayCardView(imageName: "m4", title: "放鬆歌單")
                                RecentPlayCardView(imageName: "m5", title: "Rap Life")
                                RecentPlayCardView(imageName: "m6", title: "夏日清單")
                            }
                            .padding(.horizontal)
                        }
                    }

                    Spacer(minLength: 140)
                }
            }

            MiniPlayerView()
                .padding(.horizontal, miniPlayerOuterHorizontalPadding)
                .padding(.bottom, 4)

            Divider()
            HStack(spacing: tabBarItemSpacing) {
                TabBarItemView(systemName: "house.fill", title: "首頁", active: true)
                TabBarItemView(systemName: "square.grid.2x2", title: "新發現")
                TabBarItemView(systemName: "dot.radiowaves.left.and.right", title: "廣播")
                TabBarItemView(systemName: "music.note.list", title: "資料庫")
                TabBarItemView(systemName: "magnifyingglass", title: "搜尋")
            }
            .padding(.vertical, tabBarVerticalPadding)
            .background(Color(.systemBackground))
            .padding(.bottom, tabBarLift)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct FeaturedSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("為你精選")
                .font(.system(size: 20, weight: .bold))
                .padding(.horizontal)

            Text("專屬推薦")
                .font(.system(size: 13))
                .foregroundColor(.gray)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    FeaturedCardView(
                        imageName: "m1",
                        title: "活力充電站",
                        subtitle: "G Herbo、Skrilla、Lil Yachty、Yeat、ian、DJ Iraq、Playboi Carti、BunnaB 等藝人"
                    )
                    FeaturedCardView(
                        imageName: "m2",
                        title: "São Paulo",
                        subtitle: "The Weeknd 2025"
                    )
                    FeaturedCardView(
                        imageName: "m3",
                        title: "最新發行",
                        subtitle: "每週新歌推薦"
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

struct FeaturedCardView: View {
    let imageName: String
    let title: String
    let subtitle: String

    private let imageWidth: CGFloat = 260
    private let imageHeight: CGFloat = 350
    private var infoHeight: CGFloat { imageHeight / 5 }
    private let titleTopPadding: CGFloat = 36

    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: imageWidth, height: imageHeight)
                .clipped()

            LinearGradient(
                colors: [Color.black.opacity(0.55), Color.black.opacity(0.0)],
                startPoint: .top,
                endPoint: .center
            )
            .frame(width: imageWidth, height: imageHeight)

            VStack {
                HStack {
                    Text("Music")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white.opacity(0.9))
                    Spacer()
                }
                .padding(.top, 15)
                .padding(.horizontal, 37)
                Spacer()
            }
            .frame(width: imageWidth, height: imageHeight)

            VStack {
                HStack {
                    Spacer()
                    Text(title)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: imageWidth - 24)
                    Spacer()
                }
                .padding(.top, titleTopPadding)
                Spacer()
            }
            .frame(width: imageWidth, height: imageHeight)

            VStack {
                Spacer()
                ZStack(alignment: .leading) {
                    (averageColor(named: imageName) ?? Color.black.opacity(0.25))
                        .opacity(1)
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                }
                .frame(height: infoHeight)
            }
            .frame(width: imageWidth, height: imageHeight)
        }
        .frame(width: imageWidth, height: imageHeight)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

struct RecentPlayCardView: View {
    let imageName: String
    let title: String

    private let size: CGFloat = 157

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .topLeading) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
                    .clipped()
                    .cornerRadius(12)
                Text("Music")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(4)
            }
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.primary)
                .lineLimit(1)
        }
        .frame(width: size)
    }
}

struct MiniPlayerView: View {
    private let albumSize: CGFloat = 36
    private let verticalPadding: CGFloat = 10
    private let horizontalPadding: CGFloat = 14

    var body: some View {
        HStack {
            Image("m7")
                .resizable()
                .scaledToFill()
                .frame(width: albumSize, height: albumSize)
                .cornerRadius(6)
            Text("Gone Girl")
                .font(.system(size: 14))
                .foregroundColor(.primary)
            Spacer()
            HStack(spacing: 20) {
                Image(systemName: "play.fill")
                    .font(.system(size: 18))
                Image(systemName: "forward.fill")
                    .font(.system(size: 18))
            }
            .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct TabBarItemView: View {
    let systemName: String
    let title: String
    var active: Bool = false

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(active ? .red : .gray)
            Text(title)
                .font(.system(size: 10))
                .foregroundColor(active ? .red : .gray)
        }
        .frame(maxWidth: .infinity)
    }
}

fileprivate func averageColor(named name: String) -> Color? {
    guard let uiImage = UIImage(named: name) else { return nil }
    guard let cgImage = uiImage.cgImage else { return nil }

    let ciImage = CIImage(cgImage: cgImage)
    let extent = ciImage.extent
    let filter = CIFilter.areaAverage()
    filter.inputImage = ciImage
    filter.extent = extent

    let context = CIContext(options: [.workingColorSpace: NSNull()])
    guard let output = filter.outputImage else { return nil }

    var bitmap = [UInt8](repeating: 0, count: 4)
    context.render(
        output,
        toBitmap: &bitmap,
        rowBytes: 4,
        bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
        format: .RGBA8,
        colorSpace: nil
    )

    return Color(
        red: Double(bitmap[0]) / 255.0,
        green: Double(bitmap[1]) / 255.0,
        blue: Double(bitmap[2]) / 255.0
    )
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
