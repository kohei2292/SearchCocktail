//
//  APIService.swift
//  SearchGithub
//
//  Created by 布川浩平 on 2021/10/24.
//

import Foundation
import Combine

protocol APIRequestType {
    associatedtype Response: Decodable // 今はまだ決められないけど準拠時に決めてねという型を定義
    
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
}

protocol APIServiceType {
    func request<Request>(with request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType
}

final class APIService: APIServiceType {
    private let baseURLString: String
    // 初期処理
    init(baseURLString: String = "https://cocktail-f.com"){
        self.baseURLString = baseURLString
    }
    // APIのリクエストを実行
    func request<Request>(with request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType{
        
        // URL変換
        guard let pathURL = URL(string: request.path, relativeTo: URL(string: baseURLString)) else {
            return Fail(error: APIServiceError.invalidURL).eraseToAnyPublisher()
        }
        
        // URLからクエリパラメータを取得する
        var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = request.queryItems
        
        // Requestを生成
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        print(request)
        let decorder = JSONDecoder()
        // snake case から camel caseへ変換
        decorder.keyDecodingStrategy = .convertFromSnakeCase
        // URLSessionのPublisherを実行
        return URLSession.shared.dataTaskPublisher(for: request)
            // mapでレスポンスデータのストリームに変換
            .map{ data, urlResponse in data }
            // エラーが起きたらresponseErrorを返す
            .mapError{ _ in APIServiceError.responseError }
            // JSONからデータオブジェクトにデコードする
            .decode(type: Request.Response.self, decoder: decorder)
            // デコードでエラーが起きたらParseErrorを返す
            .mapError({ (error) -> APIServiceError in
                APIServiceError.parseError(error)
            })
            // ストリームをメインメソッドに流れるように変換
            .receive(on: RunLoop.main)
            // （ネストが深くならないように）Publisherの型を消去する
            .eraseToAnyPublisher()
    }
}
