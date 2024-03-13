//
//  ContentView.swift
//  SearchGithub
//
//  Created by 布川浩平 on 2021/10/24.
//

import SwiftUI

struct CardView: View {
    struct Input{
        let cocktailId: UUID = UUID()       // Identifiable準拠に必要
        let cocktailName: String?           // タイトル
        let baseName: String?               // ベース
        let cocktailDesc: String?           // 説明
        let iconImage: UIImage              // アイコン画像
        let tasteName: String?              // テイスト
        let recipeDesc: String?             // レシピ
        let recipes: [Recipe]
    }
    
    let input: Input
    
    init(input: Input){
        self.input = input
    }
    
    var body: some View{
        
        // カード型UI全体レイアウト
        VStack{
            VStack(alignment: .center){
                Image(uiImage: input.iconImage)
                    // Buttonで包む際に色が変わらないようにする
                    .renderingMode(.original)
                    // 親のサイズに伸縮できるようにする
                    .resizable()
                    //アスペクト比を保つ
                    .aspectRatio(contentMode: .fit)
                    // サイズはw:60 h:60固定
                    .frame(width: 120, height: 120)
                    
                
            }
                
            // HStackで使用言語とスター（評価）を横に並べる
            HStack{
                Text(input.cocktailName ?? "")
                    .foregroundColor(.black)  // 明示的に色を指定しないとbuttonで包んでおかないとおかしくなる
                    .font(.body)
                    .fontWeight(.bold)
                // 隙間を自動調整であける
                Spacer()
                // 使用言語
                Text(input.baseName ?? "")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                // 隙間を自動調整であける
/*                Spacer()
                
                // スターと評価
                HStack(spacing: 4){
                    Image(systemName: "star")
                        // Imageを指定した色で塗りつぶす
                        .renderingMode(.template)
                        // 灰色に変更
                        .foregroundColor(.gray)
                    Text(String(input.star))
                        .font(.footnote)
                        .foregroundColor(.gray)
                }*/
            
            }
            VStack(alignment: .leading){
                Text(input.tasteName ?? "")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                Text(input.cocktailDesc ?? "")
                    .foregroundColor(.black)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
            }
        }
        // 枠線の中の余白を作る
        .padding(24)
        // 角丸の枠線を作る
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray, lineWidth: 1)
        )
        // カード型UIの最低サイズ
        .frame(minWidth: 140, minHeight: 180)
        // 枠線の外のパディング
        .padding()
    }
}


