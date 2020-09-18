import Foundation

let inkApi = InkAPI()

let gearPartNames = ["general","headgear","clothing","shoes"]
let allGearpowerNames = ["general":["インク効率アップ(メイン)","インク効率アップ(サブ)","インク回復力アップ",
                      "メイン性能アップ","サブ性能アップ","ヒト移動速度アップ","イカダッシュ速度アップ",
                      "スペシャル増加量アップ","スペシャル減少量ダウン","スペシャル性能アップ","復活時間短縮",
                      "スーパージャンプ時間短縮","相手インク影響軽減","爆風ダメージ軽減・改"],
                      "headgear":["スタートダッシュ","ラストスパート","逆境強化","カムバック"],
                      "clothing":["イカニンジャ","リベンジ","サーマルインク","復活ペナルティアップ"],
                      "shoes":["ステルスジャンプ","受け身術","対物攻撃力アップ"]]

let gearpowerNums = [0,3,6,9,10,12,13,15,16,18,
                     19,20,21,22,23,24,25,26,27,28,
                     29,30,31,32,33,34,35,36,37,38,
                     39,41,42,44,45,47,48,51,54,57]

let shadowColor = UIColor.black.cgColor
let shadowOffset = CGSize(width: 0, height: 2)
let shadowRadius:CGFloat = 4
let shadowOpacity:Float = 0.5

let cornerRadius:CGFloat = 4

class Static {
    static var gearsets:[Gearset] = []
}

import UIKit

extension UIView {
    
    func addBackground(name: String) {
        
        // スクリーンサイズの取得
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        // スクリーンサイズにあわせてimageViewの配置
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        //imageViewに背景画像を表示
        imageViewBackground.image = UIImage(named: name)
        
        // 画像の表示モードを変更。
        imageViewBackground.contentMode = UIView.ContentMode.scaleAspectFill
        
        // subviewをメインビューに追加
        self.addSubview(imageViewBackground)
        // 加えたsubviewを、最背面に設置する
        self.sendSubviewToBack(imageViewBackground)
        
    }
    
    func addTileBackground(name: String) {
        
        // スクリーンサイズの取得
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let tileImageForSize = UIImageView(image: UIImage(named: name))
        
        let tileWidth = tileImageForSize.image!.size.width
        let tileHeight = tileImageForSize.image!.size.height
        
        let tileHeightFixed = tileHeight * (width / tileWidth)
        let tileNum = Int(ceil(height / tileHeightFixed))
        
        for n in 0...tileNum {
            
            let tileImage = UIImageView(image: UIImage(named: name))
            let tileY = Int(tileHeightFixed) * n
            tileImage.frame.size = CGSize(width: width, height: tileHeightFixed)
            tileImage.frame.origin = CGPoint(x:0, y: tileY)
            self.addSubview(tileImage)
            self.sendSubviewToBack(tileImage)
            
        }
    }
    
    func addCardStyleBackground() {
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        let cornerRadious:CGFloat = 32
        
        let cardTopImage = UIImageView(image: UIImage(named: "card_white_wide"))
        let cardBottomImage = UIImageView(image: UIImage(named: "card_white_wide"))
        let cardHeight = width * cardTopImage.image!.size.height / cardTopImage.image!.size.width
        
        cardTopImage.frame.size = CGSize(width: width, height: cardHeight)
        cardTopImage.contentMode = .scaleAspectFill
        
        cardBottomImage.frame.size = CGSize(width: width, height: cardHeight)
        cardBottomImage.contentMode = .scaleAspectFill
        
        //----------
        
        let cardTopView = UIView()
        let cardBodyView = UIView()
        let cardBottomView = UIView()
        
        cardTopView.frame.size = CGSize(width: width, height: cornerRadious)
        cardTopView.clipsToBounds = true
        cardTopView.addSubview(cardTopImage)
        
        cardBottomView.frame.size = CGSize(width: width, height: cornerRadious)
        cardBottomView.clipsToBounds = true
        cardBottomView.frame.origin.y = height - cornerRadious
        cardBottomView.addSubview(cardBottomImage)
        cardBottomImage.frame.origin.y = cornerRadious - cardHeight
        
        
        cardBodyView.frame.size = CGSize(width: width,
                                         height: height - cornerRadious * 2)
        cardBodyView.frame.origin.y = cornerRadious
        cardBodyView.backgroundColor = UIColor.white
        
        self.addSubview(cardTopView)
        self.addSubview(cardBottomView)
        self.addSubview(cardBodyView)
        
        self.sendSubviewToBack(cardTopView)
        self.sendSubviewToBack(cardBottomView)
        self.sendSubviewToBack(cardBodyView)
        
    }
}
