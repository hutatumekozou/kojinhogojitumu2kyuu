import SwiftUI

struct ResultView: View {
    let topic: QuizTopic
    let correctAnswers: Int
    let totalQuestions: Int
    @Environment(\.dismiss) private var dismiss
    
    private var scorePercentage: Double {
        Double(correctAnswers) / Double(totalQuestions) * 100
    }
    
    private var resultMessage: String {
        switch scorePercentage {
        case 90...100:
            return "素晴らしい！完璧に理解されています！"
        case 70..<90:
            return "よくできました！もう少しで満点です！"
        case 50..<70:
            return "まずまずの結果です。復習してみましょう。"
        default:
            return "もう一度チャレンジしてみましょう！"
        }
    }
    
    var body: some View {
        ZStack {
            // グラデーション背景
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.6, green: 0.8, blue: 1.0),
                    Color(red: 0.4, green: 0.6, blue: 0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
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
                
                // メッセージ
                Text(resultMessage)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(15)
                
                Spacer()
                
                // ボタン
                VStack(spacing: 15) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("もう一度")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color(red: 0.2, green: 0.4, blue: 0.8))
                            .cornerRadius(12)
                    }
                    
                    Button(action: {
                        // 広告を表示してからホームに戻る
                        if let topViewController = TopViewController.getTopViewController() {
                            AdsManager.shared.show(from: topViewController)
                        }
                        
                        // NavigationViewのルートまで戻る
                        dismiss()
                        dismiss()
                    }) {
                        Text("最初に戻る")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.8))
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 0.2, green: 0.4, blue: 0.8), lineWidth: 2)
                            )
                    }
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}