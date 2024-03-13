//
//  Response.swift
//  SearchGithub
//
//  Created by 布川浩平 on 2021/10/24.
//

import Foundation
import RealmSwift
// GitHub SearchAPIのレスポンスをデータオブジェクトに変換する型
struct Recipe:Decodable, Hashable {
    var ingredientId:Int = 0              // id
    var ingredientName:String? = ""           // 名前
    var amount:String? = ""           // 名前
    var unit:String? = ""           // 名前
}


