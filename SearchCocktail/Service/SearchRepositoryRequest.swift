//
//  SearchRepositoryRequest.swift
//  SearchGithub
//
//  Created by 布川浩平 on 2021/10/24.
//

import Foundation

// APIのリクエストを表現する型
struct SearchRepositoryRequest: APIRequestType {
    typealias Response = SearchRepositoryResponse
    
    // https://api.github.com/以下のURL
    var path: String { return "/api/v1/cocktails" }
    var queryItems: [URLQueryItem]? {
        return [
            // イニシャライザーで検索文字列を設定できるようにする
            .init(name: "base", value: query),
        ]
        
    }
    
    private let query: String
    
    init(query: String){
        self.query = query
    }
}
