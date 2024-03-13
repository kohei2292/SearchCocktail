//
//  Response.swift
//  SearchGithub
//
//  Created by 布川浩平 on 2021/10/24.
//

import Foundation
import RealmSwift
// GitHub SearchAPIのレスポンスをデータオブジェクトに変換する型
struct Cocktail:Decodable, Hashable {
    var cocktailId:Int = 0              // id
    var cocktailName:String? = ""           // 名前
    var baseName:String? = ""               // 名前
    var cocktailDesc:String? = ""           // 説明
    var tasteName:String? = ""              // テイスト
    var recipeDesc:String? = ""             // レシピ
    var recipes: [Recipe]
}


