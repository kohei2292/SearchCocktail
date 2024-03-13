//
//  SearchRepositoryResponse.swift
//  SearchGithub
//
//  Created by 布川浩平 on 2021/10/24.
//

import Foundation

// リポジトリー全体
struct SearchRepositoryResponse: Decodable {
    let cocktails: [Cocktail] // Repository型がひとつのリポジトリーを表し、レスポンス全体はSearchRepositoryResponse型で表現
}
