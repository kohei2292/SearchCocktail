//
//  RecipeView.swift
//  SearchCocktail
//
//  Created by 布川浩平 on 2021/11/29.
//

import SwiftUI

struct RecipeView: View {
    let cocktailName: String              // タイトル
    let iconImage: UIImage              // アイコン画像
    let recipeDesc: String
    
    var body: some View {
        VStack(alignment: .center){
            Image(uiImage: iconImage)
                // Buttonで包む際に色が変わらないようにする
                .renderingMode(.original)
                // 親のサイズに伸縮できるようにする
                .resizable()
                //アスペクト比を保つ
                .aspectRatio(contentMode: .fit)
                // サイズはw:60 h:60固定
                .frame(width: 120, height: 120)
        }
        VStack(alignment: .leading){
            Text(cocktailName)
                .font(.title)
                .padding(1)
            Text(recipeDesc)
        }
        
        
        /*VStack{
            
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
        .padding()*/
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(cocktailName: "",
                   iconImage: UIImage(named: "wine")!,
                   recipeDesc: "")
    }
}
