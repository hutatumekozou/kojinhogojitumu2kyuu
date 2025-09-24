import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
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

                VStack(alignment: .leading, spacing: 16) {
                    // タイトル
                    VStack(spacing: 4) {
                        Text("個人情報保護実務検定 2級")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(.primary)
                            .accessibilityLabel("個人情報保護実務検定 2級")
                            .multilineTextAlignment(.center)

                        Text("問題集")
                            .font(.system(size: 22, weight: .heavy))
                            .foregroundStyle(.primary)
                            .accessibilityHidden(true)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)

                    // 縦1列のボタン群（スクロール）
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(QuizTopic.allCases) { topic in
                                NavigationLink(destination: QuizView(topic: topic)) {
                                    Text(topic.title)
                                        .font(.headline)
                                        .foregroundStyle(Color(red: 0.12, green: 0.39, blue: 0.85))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 16)
                                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(.white.opacity(0.6), lineWidth: 1)
                                        )
                                        .shadow(radius: 1, y: 1)
                                        .accessibilityLabel(topic.title)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.bottom, 24)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
            }
            .navigationBarHidden(true)
            .onAppear {
                AdsManager.shared.preload()
            }
        }
    }
}