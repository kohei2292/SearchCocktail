//
//  Owner.swift
//  SearchGithub
//
//  Created by 布川浩平 on 2021/10/24.
//

import Foundation
// オーナー
struct Owner: Decodable, Hashable, Identifiable {
    let id: Int             // id
    let avatarUrl: String   // 画像URL
}
