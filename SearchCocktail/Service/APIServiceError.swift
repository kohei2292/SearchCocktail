//
//  APIServiceError.swift
//  SearchGithub
//
//  Created by 布川浩平 on 2021/10/24.
//

import Foundation

enum APIServiceError: Error{
    case invalidURL         // URL不正
    case responseError      // APIレスポンスエラー
    case parseError(Error)  // JSONのパース時にエラーが発生
}
