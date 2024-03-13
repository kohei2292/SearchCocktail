//
//  HomeView.swift
//  SearchGithub
//
//  Created by 布川浩平 on 2021/10/24.
//

import SwiftUI
import RealmSwift
struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel = .init(apiService: APIService())
    @State private var text = ""
    @State var selectedCocktailsIndex: Int = 0
    let myCocktails = ["ノンアルコール","ジン","ウォッカ","テキーラ","ラム","ウィスキー","ブランデー","リキュール","ワイン","ビール","日本酒"]
    var body: some View {
        // https://stackoverflow.com/questions/57499359/adding-a-text-field-to-navigationbar-with-swiftui
        NavigationView{
            // ロード中　isLoadingは@Published属性をつけているので、Viewは値の更新をキャッチすることができる。
            if viewModel.isLoading{
                Text("読み込み中...")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .offset(x: 0, y: -200)
                    .navigationBarTitle("", displayMode: .inline)
            } else {
                ScrollView(showsIndicators: false){
                    // カードの情報毎にButtonを作成する
                    ForEach(viewModel.cardViewInputs, id: \.cocktailId) { input in
                        Button(action: {
                            // アクセス
                            viewModel.apply(inputs: .tappedCardView(cocktailName: input.cocktailName ?? "",
                                                    recipeDesc: input.recipeDesc ?? ""))
                        }) {
                            CardView(input: input)
                        }
                    }
                }
                .padding(60)
                .navigationBarTitle("", displayMode: .inline)
                // ナビゲーションバーにViewを乗せる
                .navigationBarItems(leading: HStack{
                    Picker("", selection: $selectedCocktailsIndex) {
                        ForEach(0 ..< myCocktails.count) {
                            Text(self.myCocktails[$0])
                        }
                        
                    }
                    .onChange(of: selectedCocktailsIndex) { _ in
                        viewModel.apply(inputs: .onCommit(text: String(selectedCocktailsIndex)))
                    }
                    
                    /*TextField("検索キーワードを入力", text: $text, onCommit: {
                        // 検索値を引数に渡し検索する
                        viewModel.apply(inputs: .onCommit(text: text))
                    })*/
                    .pickerStyle(WheelPickerStyle())
                    // 角丸なデザイン
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.asciiCapable)
                    .font(.largeTitle)
                })
                // Safariで開く isShowSheetがtrueなら
                .sheet(isPresented: $viewModel.isShowSheet) {
                    RecipeView(cocktailName: viewModel.repoCocktailName,
                               iconImage: viewModel.convertImage(baseName: viewModel.repobaseName),
                               recipeDesc: viewModel.repoRecipeDesc)
                }
                
                // 通信エラー isShowErrorがtrueなら
                .alert(isPresented: $viewModel.isShowError){
                    Alert(title: Text("通信時にエラーが発生しました。もう一度やり直してください。"))
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
