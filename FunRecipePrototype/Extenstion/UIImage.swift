//
//  UIImageView.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/20.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import UIKit

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}

// 指定URLから画像を読み込み、セットする
// defaultUIImageには、URLからの読込に失敗した時の画像を指定する
extension UIImageView {
    func loadImageAsynchronously(url: URL?, defaultUIImage: UIImage? = nil) -> Void {

        if url == nil {
            self.image = defaultUIImage
            return
        }

        DispatchQueue.global().async {
            do {
                let imageData: Data? = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    if let data = imageData {
                        self.image = UIImage(data: data)
                    } else {
                        self.image = defaultUIImage
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.image = defaultUIImage
                }
            }
        }
    }
}
