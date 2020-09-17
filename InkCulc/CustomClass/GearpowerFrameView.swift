import UIKit

class GearpowerFrameView: UIView {

    var iconFrameView = UIView()
    var partIcons:[UIImageView] = []
    var icons:[[UIButton]] = []
    
    var gearpowerNames:[[String]] = []
    var highlightened:[Int]?

    func setSize() {
        
        removeElements()
        self.backgroundColor = UIColor.clear
        
        //----------アイコン準備----------
        
        let width = self.frame.size.width
        let height = self.frame.size.height
        
        //パートアイコン
        let partIconImageNames = ["ギアアイコン_アタマ","ギアアイコン_フク","ギアアイコン_クツ"]
        for n in 0...2 {
            let partImage = UIImage(named: partIconImageNames[n])
            let partIcon = UIImageView(image: partImage)
            partIcon.contentMode =  UIView.ContentMode.scaleAspectFit
            partIcons.append(partIcon)
        }
        
        //ギアパワーアイコン
        var tag = 0
        for n in 0...2 {
            //空配列を追加
            icons.append([])
            gearpowerNames.append([])
            
            //枠を4個追加
            for _ in 0...3 {
                //パワーアイコン
                let icon = UIButton()
                icon.setImage(UIImage(named: "未設定"), for: .normal)
                
                icon.tag = tag
                tag += 1
                
                icons[n].append(icon)
                
                //空パワー名
                gearpowerNames[n].append("未設定")
            }
        }
        
        //ビューに追加
        for icon in partIcons {
            iconFrameView.addSubview(icon)
        }
        for row in icons {
            for icon in row {
                iconFrameView.addSubview(icon)
            }
        }
        self.addSubview(iconFrameView)
        
        //----------アイコン設定----------
        
        //サイズ定義
        let iconColumnInset:CGFloat = 5
        let iconRowInset:CGFloat = 10
        let largeIconSize:CGFloat = (height - iconRowInset * 2) / 3
        let smallIconSize:CGFloat = largeIconSize * 0.8
        
        //パートアイコン
        for n in 0...2 {
            let iconY:CGFloat = (largeIconSize + iconRowInset) * CGFloat(n)
            
            partIcons[n].frame = CGRect(x: 0, y: iconY,
                                        width: largeIconSize, height: largeIconSize)
        }
        
        //ギアパワーアイコン
        for n in 0...2 {
            var iconY:CGFloat = (largeIconSize + iconRowInset) * CGFloat(n)
            
            for m in 0...3 {
            
                //サイズ
                var iconSize:CGFloat = smallIconSize; if m == 0 { iconSize = largeIconSize }
                //Y座標
                if m == 1 { iconY += largeIconSize - smallIconSize}
                //X座標
                var iconX:CGFloat = 0
                if m == 0 {
                    iconX = partIcons[n].frame.size.width + iconColumnInset * 2
                } else {
                    iconX = icons[n][m - 1].frame.size.width + icons[n][m - 1].frame.origin.x + iconColumnInset
                }
                
                icons[n][m].frame = CGRect(x: iconX, y: iconY,
                                           width: iconSize, height: iconSize)
                icons[n][m].layer.cornerRadius = iconSize / 2
            }
        }
        
        //----------テスト用背景色----------

//        for icon in partIcons {
//            icon.backgroundColor = UIColor.systemGreen
//        }
//        for row in icons {
//            for icon in row {
//                icon.backgroundColor = UIColor.darkGray
//            }
//        }
//        iconFrameView.backgroundColor = UIColor.systemBlue
//        self.backgroundColor = UIColor.systemRed
        
        //----------フレーム----------
        
        let frameHeight = height
        let frameWidth:CGFloat = icons.first!.last!.frame.origin.x + icons.first!.last!.frame.size.width
        self.frame.size = CGSize(width: width, height: height)
        iconFrameView.frame.size = CGSize(width: frameWidth, height: frameHeight)
        
        let contentAspect = frameHeight / frameWidth
        let viewAspect = height / width
        let viewIsHeiher:Bool = viewAspect / contentAspect > 1
        
        //ビューサイズに収まるよう縮小・センタリング
        if viewIsHeiher {
            let ratio =  self.frame.size.width / frameWidth
            let frameY = (self.frame.size.height - frameHeight) / 2
            iconFrameView.frame.origin.y = frameY
            iconFrameView.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            iconFrameView.frame.origin.x = 0
        } else {
            let ratio = self.frame.size.height / frameHeight
            let frameX = (self.frame.size.width - frameWidth) / 2
            iconFrameView.frame.origin.x = frameX
            iconFrameView.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            iconFrameView.frame.origin.y = 0
        }
        
    }

    //選択中アイコン強調表示
    func highlight(at: [Int]? = nil) {
        if at != nil { highlightened = at! } else { highlightened = nil }
        
        for n in 0...2 {
            for m in 0...3 {
                if at != nil && [n,m] == at {
                    icons[n][m].layer.borderWidth = 4
                    icons[n][m].layer.borderColor = UIColor.systemPink.cgColor
                } else {
                    icons[n][m].layer.borderWidth = 0
                    icons[n][m].layer.borderColor = UIColor.clear.cgColor
                }
            }
        }
    }
    
    func selectedMainGearpowerIcon() -> String {
        
        var part = "non"

        guard highlightened != nil else { return part }
        
        if highlightened![1] == 0 {
            
            switch highlightened![0] {
            case 0:
                part = gearPartNames[1]
            case 1:
                part = gearPartNames[2]
            case 2:
                part = gearPartNames[3]
            default:
                break
            }
            
        }
        
        return part
    }
    
    
    //アイコンに新しいパワーをセット
    func setPower(_ powerName: String, to: [Int], highlightNext:Bool = true) {
        gearpowerNames[to[0]][to[1]] = powerName
        reloadIcon()
        
        if !highlightNext {
            highlight(at: [to[0], to[1]])
        } else if let blank = blankIcon(after: highlightened!) {
            highlight(at: blank)
        } else if let blank = blankIcon(after: [0,0]) {
            highlight(at: blank)
        } else {
            highlight()
        }
    }
    
    //アイコンの座標取得
    func coordinate(tag:Int) -> [Int] {
        
        var n = 0
        var m = tag
        
        while m > 3 {
            n += 1
            m -= 4
        }
        
        return [n,m]
    }
    
    //未設定のアイコンの座標取得
    func blankIcon(after:[Int] = [0,0]) -> [Int]? {
        
        var ifFound = false
        var blankIcon:[Int]?
        
        let nStart = after[0]
        
        for n in nStart...2 {
            var mStart = 0
            if n == nStart { mStart = after[1] }
            for m in mStart...3 {
                if icons[n][m].currentImage == UIImage(named: "未設定") {
                    blankIcon = [n,m]
                    ifFound = true
                    break
                }
            }
            if ifFound { break }
        }
        
        return blankIcon
    }
    
    //ギアパワーのポイントを辞書で取得
    func gearpowerPoint() -> [String:Int] {
        
        var outputDict:[String:Int] = [:]
        
        for n in 0...allGearpowerNames.count - 1 {
            //ギアのパート名
            let part = gearPartNames[n]
            for m in 0...allGearpowerNames[gearPartNames[n]]!.count - 1 {
                
                let gearpowerName = allGearpowerNames[part]![m]
                outputDict[gearpowerName] = 0
                
                for a in 0...2 {
                    for b in 0...3 {
                        if gearpowerNames[a][b] == gearpowerName {
                            var gearpower = 3
                            if b == 0 { gearpower = 10 }
                            outputDict[gearpowerName]! += gearpower
                        }
                    }
                }
                
            }
        }
        
        return outputDict
        
    }
    
    //ギアパワーのポイント取得
    func gearpowerPoint(of: String) -> Int {
        
        let gearpowerPointDict = gearpowerPoint()
        return gearpowerPointDict[of]!
        
    }

    //アイコンが未設定かどうか取得
    func ifBlank(at: [Int]) -> Bool {
        let n = at[0]; let m = at[1]
        return icons[n][m].currentImage == UIImage(named: "未設定")
    }
    
    //アイコン更新
    func reloadIcon() {
        for n in 0...2 {
            for m in 0...3 {
                let fileName = gearpowerNames[n][m]
                let iconImage = UIImage(named: fileName)
                if fileName == "未設定" || iconImage == nil {
                    icons[n][m].setImage(UIImage(named: "未設定"), for: .normal)
                } else {
                    icons[n][m].setImage(iconImage, for: .normal)
                }
            }
        }
    }
    
    //初期化
    func removeElements() {
        
        iconFrameView.removeFromSuperview()
        iconFrameView = UIView()
        for part in partIcons {
            part.removeFromSuperview()
        }
        partIcons = []
        for part in icons {
            for icon in part {
                icon.removeFromSuperview()
            }
        }
        icons = []
        
        gearpowerNames = []
        highlightened = nil
    }
}
