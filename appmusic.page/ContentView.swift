import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

struct ContentView: View {
    // 只調整「為你精選」和「最近播放」之間的距離：
    // 正值 = 增加間距；負值 = 縮短間距
    private let featuredToRecentGap: CGFloat = 29
    // 調整 MiniPlayer 在螢幕左右的外距（越小越寬）
    private let miniPlayerOuterHorizontalPadding: CGFloat = 8
    
    // TabBar 調整用：
    private let tabBarLift: CGFloat = 8              // 往上抬高的距離（越大 → 離底部越遠）
    private let tabBarItemSpacing: CGFloat = 0       // 五個項目之間的間距（越小 → 越靠近）
    private let tabBarVerticalPadding: CGFloat = 6   // TabBar 的上下內距（會影響 TabBar 高度）

    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Scroll 主內容
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Header
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
                    
                    // MARK: - 為你精選
                    VStack(alignment: .leading, spacing: 5) {
                        // 還原為靠左（先前置中的改動撤回）
                        Text("為你精選")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.horizontal)
                        
                        Text("專屬推薦")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) { // 間隔
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
                    // 只影響「為你精選」與「最近播放」之間的距離
                    .padding(.bottom, featuredToRecentGap)
                    
                    // MARK: - 最近播放
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
                    
                    Spacer(minLength: 140) // 預留小播放器 & TabBar
                }
            }
            
            // MARK: - 小播放器
            MiniPlayerView()
                .padding(.horizontal, miniPlayerOuterHorizontalPadding) // 調整外側水平間距 → 影響寬度
                .padding(.bottom, 4)
            
            // MARK: - TabBar
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
            .padding(.bottom, tabBarLift) // 這行放在 background 之後 → 真的「往上抬」TabBar
            
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - FeaturedCardView
struct FeaturedCardView: View {
    let imageName: String
    let title: String
    let subtitle: String
    
    // 手動調整尺寸：改這兩個常數（底部資訊區高度 = 圖片高度的 1/5，覆蓋在圖片上）
    private let imageWidth: CGFloat = 260
    private let imageHeight: CGFloat = 350
    private var infoHeight: CGFloat { imageHeight / 5 }
    // 圖片上「title」往下的距離（置中標題與左上 Music 錯開）
    private let titleTopPadding: CGFloat = 36
    
    var body: some View {
        ZStack {
            // 背景圖
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: imageWidth, height: imageHeight)
                .clipped()
            
            // 上方漸層，讓上方文字更清楚
            LinearGradient(
                colors: [Color.black.opacity(0.55), Color.black.opacity(0.0)],
                startPoint: .top,
                endPoint: .center
            )
            .frame(width: imageWidth, height: imageHeight)
            
            // 左上角：Music
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
            
            // 置中的「title」（圖片上的標題）
            VStack {
                HStack {
                    Spacer()
                    Text(title)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(width: imageWidth - 24) // 與左右留白對齊
                    Spacer()
                }
                .padding(.top, titleTopPadding)
                Spacer()
            }
            .frame(width: imageWidth, height: imageHeight)
            
            // 底部 1/5 高度：覆蓋在圖片上（不是額外高度）
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

// MARK: - RecentPlayCardView
struct RecentPlayCardView: View {
    let imageName: String
    let title: String
    
    // 高度與寬度都增加，且三張同尺寸
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

// MARK: - MiniPlayerView
struct MiniPlayerView: View {
    // 這三個數值控制 MiniPlayer 的「高度」與內部留白
    private let albumSize: CGFloat = 36          // 專輯封面尺寸（越小 → 整體高度越低）
    private let verticalPadding: CGFloat = 10     // 上下內距（越小 → 高度越低）
    private let horizontalPadding: CGFloat = 14  // 左右內距（調整內容與邊緣距離，不影響外部寬度）
    
    var body: some View {
        HStack {
            Image("m7") // 專輯封面
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
        .frame(maxWidth: .infinity) // 盡可能佔滿可用寬度
        .padding(.vertical, verticalPadding)
        .padding(.horizontal, horizontalPadding)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// MARK: - TabBarItemView
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

// MARK: - 平均色工具（從圖片取出近似底色）
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

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

