import UIKit

class GearpowerKeyboardView: UIView {

    var keys:[[UIButton]] = [[],[],[],[]]
    let deleteKey = UIButton()
    
    var keyFrames:[UIView] = []
    let keySetNames = ["ギアパワー","アタマ専用","フク専用","クツ専用"]
    
    func setSize(view:UIView) {
        
        let width = view.frame.size.width
        let safeAreaBottomInset = view.safeAreaInsets.bottom
        let sideInset:CGFloat = 16
        let keyGap:CGFloat = 8
        let keySize:CGFloat = (width - sideInset * 2 - keyGap * 6) / 7
        var keyTag = 0
        
        for n in 0...gearPartNames.count - 1 {
            
            keyFrames.append(UIView())
            let part = gearPartNames[n]
            
            for m in 0...allGearpowerNames[part]!.count - 1 {
                //ボタン生成
                let button = UIButton()
                button.tag = keyTag
                    
                keyTag += 1
//                button.addTarget(self, action: #selector(keyTapped(sender:)), for: .touchUpInside)
                
                //ギアパワー画像
                let gearpowerName = allGearpowerNames[part]![m]
                let imageFileName = gearpowerName + ".png"
                let gearpowerImage = UIImage(named: imageFileName)
                button.setImage(gearpowerImage, for: .normal)
                
                //座標計算
                var row = 0; if m >= 7 { row = 1 }
                var column = m; if row == 1 { column -= 7 }
                var buttonX = sideInset + (keySize + keyGap) * CGFloat(column)
                if n == 3 { buttonX =  keyGap / 2 + (keySize + keyGap) * CGFloat(column)}
                let buttonY = (keySize + keyGap) * CGFloat(row)
                
                button.frame.size = CGSize(width: keySize, height: keySize)
                button.frame.origin = CGPoint(x: buttonX, y: buttonY)
                
                //配列・ビューに追加
                keys[n].append(button)
                keyFrames[n].addSubview(keys[n][m])
            }
            
            let keyFrameHeight:CGFloat = keys[n].last!.frame.origin.y + keys[n].last!.frame.size.height + keyGap
            var keyFrameWidth = width
            if n == 1 || n == 2 {
                keyFrameWidth = keys[n].last!.frame.origin.x + keys[n].last!.frame.size.width + keyGap / 2
            }
            keyFrames[n].frame.size = CGSize(width: keyFrameWidth, height: keyFrameHeight)
            
            self.addSubview(keyFrames[n])
            
            
//            //テスト用バックグラウンドカラー
//            let background:[UIColor] = [UIColor.systemPink, UIColor.systemBlue, UIColor.systemTeal, UIColor.systemOrange]
//            keyFrames[n].backgroundColor = background[n]
        }
        
//        deleteKey.backgroundColor = UIColor.systemPurple
        
        //座標計算
        let frame0Y = sideInset
        keyFrames[0].frame.origin = CGPoint(x: 0, y: frame0Y)
        
        let frame1Y = keyFrames[0].frame.size.height + keyFrames[0].frame.origin.y
        keyFrames[1].frame.origin = CGPoint(x: 0, y: frame1Y)
        
        let frame2Y = keyFrames[1].frame.size.height + keyFrames[1].frame.origin.y
        keyFrames[2].frame.origin = CGPoint(x: 0, y: frame2Y)
        
        let frame3X = keyFrames[1].frame.size.width
        let frame3Width = width - frame3X
        keyFrames[3].frame.origin = CGPoint(x: frame3X, y: frame1Y)
        keyFrames[3].frame.size.width = frame3Width
        
        //削除キー
        deleteKey.setImage(UIImage(named: "Delete.png"), for: .normal)
        deleteKey.imageView?.tintColor = UIColor.black

        let deleteX = width - keySize - sideInset
        let deleteY = keyFrames[3].frame.origin.y + keyFrames[3].frame.size.height
        deleteKey.frame = CGRect(x: deleteX, y: deleteY,
                                 width: keySize, height: keySize)
        
        let keyboardHeight = keyFrames[2].frame.origin.y + keyFrames[2].frame.size.height + sideInset * 2 + safeAreaBottomInset
        let keyboardY = safeAreaBottomInset - keyboardHeight
        self.frame.origin = CGPoint(x: 0, y: keyboardY)
        self.frame.size = CGSize(width: width, height: keyboardHeight)
        
        self.backgroundColor = UIColor.systemGray5
        
        self.addSubview(deleteKey)
        
        self.isHidden = true
        
    }
    
    func appear(view: UIView) {
        
        let viewHeight = view.frame.size.height
        let safeAreaInset = view.safeAreaInsets.bottom
        let yTo = viewHeight - self.frame.size.height
        
        self.frame.origin.y = viewHeight
        self.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.frame.origin.y = yTo
        })
        
    }
    
    func getKeyName(tag: Int) -> String {
        var n = 0
        var m = tag
        
        while m >= allGearpowerNames[gearPartNames[n]]!.count {
            m -= allGearpowerNames[gearPartNames[n]]!.count
            n += 1
        }
        
        let keyName = allGearpowerNames[gearPartNames[n]]![m]
        return keyName
    }

    func enableLimitedKeys(part: String = "non") {
        
        for n in 1...3 {
            keyFrames[n].isUserInteractionEnabled = false
            keyFrames[n].alpha = 0.4
        }
        
        var m = 0
        
        if part == gearPartNames[1] {
            m = 1
        } else if part == gearPartNames[2] {
            m = 2
        } else if part == gearPartNames[3] {
            m = 3
        }
        
        if m != 0 {
            keyFrames[m].isUserInteractionEnabled = true
            keyFrames[m].alpha = 1
        }
        
    }
}
