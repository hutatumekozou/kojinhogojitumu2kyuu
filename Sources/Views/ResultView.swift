import SwiftUI

struct ResultView: View {
    let topic: QuizTopic
    let correctAnswers: Int
    let totalQuestions: Int
    @Environment(\.dismiss) private var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    private var scorePercentage: Double {
        Double(correctAnswers) / Double(totalQuestions) * 100
    }
    
    private var resultMessage: String {
        switch scorePercentage {
        case 81...100:
            return "素晴らしい！完璧に理解されています！\nこの調子で頑張ってください！"
        case 61...80:
            return "よくできました！\nもう少し勉強すれば満点も夢じゃありません！"
        case 41...60:
            return "まずまずの結果ですね。\n基礎をしっかり固めて再挑戦しましょう！"
        case 21...40:
            return "もう少し頑張りましょう！\n諦めずに勉強を続ければ必ず上達します！"
        default: // 0-20%
            return "大丈夫です、最初は誰でもこんなものです。\n一歩ずつ着実に学んでいきましょう！"
        }
    }

    private var bookColors: [Color] {
        switch scorePercentage {
        case 81...100:
            return [.green, .mint, .teal, .cyan, .blue]
        case 61...80:
            return [.blue, .indigo, .purple, .cyan, .teal]
        case 41...60:
            return [.orange, .yellow, .red, .pink, .purple]
        case 21...40:
            return [.purple, .pink, .red, .orange, .brown]
        default: // 0-20%
            return [.gray, .secondary, .brown, .orange, .red]
        }
    }

    private var numberOfBooks: Int {
        switch scorePercentage {
        case 81...100: return 8
        case 61...80: return 6
        case 41...60: return 5
        case 21...40: return 4
        default: return 3
        }
    }

    private var bookshelfView: some View {
        VStack(spacing: 8) {
            // 上段の本棚
            HStack(spacing: 4) {
                ForEach(0..<min(numberOfBooks, 5), id: \.self) { index in
                    bookView(
                        color: bookColors[index % bookColors.count],
                        height: 50 + Double(index % 3) * 5,
                        width: 14 + Double(index % 4) * 2
                    )
                }
                Spacer(minLength: 0)
            }
            .frame(height: 60)
            .padding(.horizontal, 16)
            .background(
                Rectangle()
                    .fill(Color(red: 0.6, green: 0.4, blue: 0.2))
                    .frame(height: 8)
                    .offset(y: 30)
            )

            // 中段の本棚
            if numberOfBooks > 5 {
                HStack(spacing: 4) {
                    ForEach(5..<numberOfBooks, id: \.self) { index in
                        bookView(
                            color: bookColors[index % bookColors.count],
                            height: 45 + Double(index % 3) * 5,
                            width: 16 + Double(index % 3) * 2
                        )
                    }
                    Spacer(minLength: 0)
                }
                .frame(height: 55)
                .padding(.horizontal, 16)
                .background(
                    Rectangle()
                        .fill(Color(red: 0.6, green: 0.4, blue: 0.2))
                        .frame(height: 8)
                        .offset(y: 27.5)
                )
            }

            // 下段の本棚（装飾用）
            HStack(spacing: 4) {
                ForEach(0..<4, id: \.self) { index in
                    bookView(
                        color: bookColors[(index + 2) % bookColors.count].opacity(0.7),
                        height: 35 + Double(index % 3) * 5,
                        width: 18 + Double(index % 2) * 2
                    )
                }
                Spacer(minLength: 0)
            }
            .frame(height: 45)
            .padding(.horizontal, 16)
            .background(
                Rectangle()
                    .fill(Color(red: 0.6, green: 0.4, blue: 0.2))
                    .frame(height: 8)
                    .offset(y: 22.5)
            )

            // 本棚の基部
            Rectangle()
                .fill(Color(red: 0.5, green: 0.3, blue: 0.1))
                .frame(height: 12)
                .cornerRadius(2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(red: 0.95, green: 0.9, blue: 0.85))
                .shadow(color: .black.opacity(0.1), radius: 3, x: 2, y: 2)
        )
    }

    private func bookView(color: Color, height: Double, width: Double) -> some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(color)
                .frame(width: width, height: height)
                .overlay(
                    VStack(spacing: 2) {
                        Rectangle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: width * 0.7, height: 1)
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: width * 0.5, height: 1)
                    }
                    .offset(y: -height * 0.3)
                )
                .overlay(
                    Rectangle()
                        .fill(Color.black.opacity(0.1))
                        .frame(width: 2, height: height)
                        .offset(x: width/2 - 1)
                )
                .cornerRadius(2)
        }
    }

    var body: some View {
        ZStack {
            // シンプルなグラデーション背景
            LinearGradient(
                colors: [
                    Color(red: 0.75, green: 0.88, blue: 1.0),
                    Color(red: 0.58, green: 0.77, blue: 0.98)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // タイトル
                Text("クイズ結果")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                // トピック名
                Text(topic.title)
                    .font(.title2)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                // スコア表示
                VStack(spacing: 15) {
                    Text("\(correctAnswers) / \(totalQuestions)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(String(format: "%.0f%%", scorePercentage))
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                
                // イラストと激励メッセージエリア
                VStack(spacing: 15) {
                    // メッセージ
                    Text(resultMessage)
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                    
                    // 本棚のイラスト
                    bookshelfView
                        .frame(width: 200, height: 200)
                }
                .padding()
                .background(Color.white.opacity(0.9))
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
                
                Spacer()
                
                // ボタン
                Button(action: {
                    // 新しいAdsManagerで広告表示
                    if let root = UIApplication.shared.connectedScenes
                        .compactMap({ ($0 as? UIWindowScene)?.keyWindow?.rootViewController })
                        .first {
                        AdsManager.show(from: root)
                    }
                    // TODO: 広告表示後の画面遷移処理を実装
                }) {
                    Text("最初に戻る")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color(red: 0.2, green: 0.4, blue: 0.8))
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
        .onAppear {
            AdsManager.preload()
        }
    }
}