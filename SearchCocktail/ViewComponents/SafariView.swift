//
//  SafariView.swift
//  SearchGithub
//
//  Created by 布川浩平 on 2021/10/24.
//

import SwiftUI
import SafariServices

// UIViewControllerRepresentableはUIViewControllerをSwiftUIとして使う時に準拠するもの
struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = SFSafariViewController
    let url: URL
    // *（インスタンス生成時）
    // 閲覧機能のみで良いのでSFSafariControllerを使用（自由に連携する場合はWKWebView）
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    // *（データ更新時）今回は使わない
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}
