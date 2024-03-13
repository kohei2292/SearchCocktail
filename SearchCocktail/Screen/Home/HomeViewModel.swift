//
//  HomeViewModel.swift
//  SearchGithub
//
//  Created by 布川浩平 on 2021/10/24.
//

import Foundation
import Combine
import UIKit
import RealmSwift

final class HomeViewModel: ObservableObject{
    // MARK: - Inputs
    enum Inputs {
        // ユーザーの入力操作が終わった
        case onCommit(text: String)
        // CardViewがタップされた
        case tappedCardView(cocktailName: String, recipeDesc: String)
    }
    
    // MARK: - Outputs
    // 表示するリポジトリーデータ　@Publishedは更新されるとHomeViewもViewも更新される
    @Published private(set) var cardViewInputs: [CardView.Input] = [];
    // TextFieldで入力されたテキスト
    @Published var inputText: String = ""
    // エラーアラートを表示するかどうか
    @Published var isShowError = false
    // 読み込みテキストを表示するかどうか
    @Published var isLoading = false
    // シートを表示するかどうか
    @Published var isShowSheet = false
    // カクテル名
    @Published var repoCocktailName: String = ""
    // ベース
    @Published var repobaseName: String = ""
    // 作り方
    @Published var repoRecipeDesc: String = ""
    
    
    init(apiService: APIServiceType){
        self.apiService = apiService
        bind() // Subjectをバインドする
        onCommitSubject.send("0")
    }
    
    func apply(inputs: Inputs){
        switch inputs {
            case .onCommit(let inputText):
                // 検索
                onCommitSubject.send(inputText)
        case .tappedCardView(let cocktailName, let recipeDesc):
                // アクセス （単純にリポジトリーのURLを更新してisShowSheetフラグをtrue）
                repoCocktailName = cocktailName
                repoRecipeDesc = recipeDesc
                isShowSheet = true
        }
    }
    
    //MARK: - Private
    private let apiService: APIServiceType
    // ユーザーの入力操作が終わった時にイベント発行するSubject　PassthroughSubjectを使って、入力されたものを逐次的に送るPublisher
    // .sink することで、データが送られてきた時に処理することができる
    private let onCommitSubject = PassthroughSubject<String, Never>()
    // APIリクエストが完了したときにイベント発行するSubject
    private let responseSubject = PassthroughSubject<SearchRepositoryResponse, Never>()
    // エラーが起きたらイベント発行するSubject
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    
    private var cancellables: [AnyCancellable] = []
    
    private func bind(){
        let responseSubscriber = onCommitSubject
            .flatMap{ [apiService] (query) in
                apiService.request(with: SearchRepositoryRequest(query: query))
                    // エラーが起こった場合にストリームの型変換して新しいPublisherとしてイベントを流すオペレータ
                    
                    .catch{ [weak self] error -> Empty<SearchRepositoryResponse, Never> in // Empty型はイベント発行が行われないPublisherに対して利用する型
                        print(error)
                        self?.errorSubject.send(error) // errorSubjectのストリームを流すことでエラーをハンドリング
                        return .init()
                        
                    }
            }
            // 流値をSearchRepositoryResponseから[Repository]に変換
            .map{ $0.cocktails }
            // 逐次的にデータを更新
            .sink(receiveValue: { [weak self] (cocktails) in
                guard let self = self else { return }
                print(cocktails)
                self.cardViewInputs = self.convertInput(cocktails: cocktails)
                self.inputText = ""
                //let recipeModel = Cocktail()
                //let realm = try! Realm()
                //realm.write {
                //    realm.add(cocktails)
                //}
                self.isLoading = false
            })
        // 検索時に動く
        let loadingStartSubscriber = onCommitSubject
            .map{ _ in true }
            // assignOperatorを使用しHomeViewModelのisLoadingプロパティをtrue
            .assign(to: \.isLoading, on: self)
        
        let errorSubscriber = errorSubject
            // 逐次的にデータを更新
            .sink(receiveValue: { [weak self] (error) in
                guard let self = self else { return }
                self.isShowError = true
                self.isLoading = false
            })
        
        cancellables += [
            responseSubscriber,
            loadingStartSubscriber,
            errorSubscriber
        ]
    }
    
    // 画像のURLからUIImageに変換してCardViewのデータモデルを作成するメソッド
    private func convertInput(cocktails: [Cocktail]) -> [CardView.Input] {
        return cocktails.compactMap{ (repo) -> CardView.Input? in
            
            let image = convertImage(baseName: repo.baseName ?? "")
            
            let decoder = JSONDecoder()
            
            do{
                let data = try decoder.decode(repo.recipes)
                let jsonstr:String = String(data: data, decoding: .utf8)!
                print(jsonstr)
            } catch {
                print(error.localizedDescription)
            }
            
            
            // CardViewを作成
            return CardView.Input(cocktailName: repo.cocktailName,
                                  baseName: repo.baseName,
                                  cocktailDesc: repo.cocktailDesc,
                                  iconImage: image,
                                  tasteName: repo.tasteName,
                                  recipeDesc: repo.recipeDesc
            )
        }
    }
    
    public func convertImage(baseName: String) -> UIImage {
        var image = UIImage(named: "wine")!
        switch baseName {
            case "ジン":
                image = UIImage(named: "gin")!
                break
            case "ウォッカ":
                image = UIImage(named: "vodka")!
                break
            case "テキーラ":
                image = UIImage(named: "tequila")!
                break
            case "ラム":
                image = UIImage(named: "rum")!
                break
            case "ウイスキー":
                image = UIImage(named: "whisky")!
                break
            case "ブランデー":
                image = UIImage(named: "brandy")!
                break
            case "リキュール":
                image = UIImage(named: "liqueur")!
                break
            case "ワイン":
                image = UIImage(named: "wine")!
                break
            case "ビール":
                image = UIImage(named: "beer")!
                break
            case "日本酒":
                image = UIImage(named: "japSake")!
                break
            case "ノンアルコール":
                image = UIImage(named: "nonAlc")!
                break
            default:
                break
        
        }
        return image
    }
}
