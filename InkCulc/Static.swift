import Foundation
import UIKit

var inkApi = InkAPI()
let navigationButton = UIButton()

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
let shadowOffset = CGSize(width: 0, height: 1)
let shadowRadius:CGFloat = 3
let shadowOpacity:Float = 0.6

let cornerRadius:CGFloat = 8

class Static {
    static var gearsets:[Gearset] = []
}

class InkColor {
    static let blue = UIColor(red: 128/255, green: 148/255, blue: 255/255, alpha: 1)
    static let pink = UIColor(red: 255/255, green: 128/255, blue: 148/255, alpha: 1)
    static let yellow = UIColor(red: 232/255, green: 188/255, blue: 84/255, alpha: 1)
    static let green = UIColor(red: 104/255, green: 198/255, blue: 112/255, alpha: 1)
    static let lightGray = UIColor(red: 212/255, green: 212/255, blue: 212/255, alpha: 1)
    static let gray = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
    static let darkGray = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
    static let red = UIColor(red: 184/255, green: 74/255, blue: 74/255, alpha: 1)
    static let textBlue = UIColor.systemBlue
    
}

class InkFont {
    static let Banana = UIFont(name: "bananaslipplus", size: 24)
    static let Sans = UIFont(name: "HiraginoSans-W2", size: 18)
    static let Navi = UIFont(name: "HiraginoSans-W1", size: 28)
}


import UIKit

extension UIView {
    
    func shadow(off:Bool = false) {
        
        if !off {
            self.layer.shadowOpacity = shadowOpacity
            self.layer.shadowRadius = shadowRadius
            self.layer.shadowOffset = shadowOffset
            self.layer.shadowColor = shadowColor
        } else {
            self.layer.shadowOpacity = 0
            self.layer.shadowRadius = 0
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowColor = UIColor.clear.cgColor
        }
        
    }
    
    func withoutShadow() -> UIView {
        
        self.shadow(off: true)
        return self
        
    }
    
    func makeImage() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        layer.render(in: currentContext)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
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
    
}
