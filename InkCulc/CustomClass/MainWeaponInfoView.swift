import UIKit

class MainWeaponInfoView: UIView {

    let topLabel = UILabel()
    var keyLabels:[UILabel] = []
    var valueLabels:[UILabel] = []
    let powerupIcon = UIImageView(image: UIImage(named: "メイン性能アップ"))
    var buttons:[UIButton] = []
    var backgroundCardView = UIView()
    
    var mainWeaponInfo:MainWeaponInfo?
    
    func set(weapon: Weapon) {
        
        //初期化
        removeElements()
        
        let mainWeaponNum = inkApi.mainWeaponNum(of: weapon)
        mainWeaponInfo = inkApi.mainWeaponInfo[mainWeaponNum]
        
        var keyLabelWidth:CGFloat = 0
        var labelY:CGFloat = 0
        
        let topLabelHeight:CGFloat = 54
        let contentInset:CGFloat = 18
        let labelGap:CGFloat = 10
        
        let font = UIFont(name: "HiraMaruProN-W4", size: 17)
        
        //----------ラベルのテキスト----------
        
        let keysJp = ["ダメージ","射程","連射間隔","インク消費", //0...3
            "ヒト速","ヒト速 (攻撃中)","イカ速", //4...6
            "メイン性能アップ効果"] //7
        
        topLabel.text = "メインブキ性能"
        topLabel.textAlignment = .center
        topLabel.font = UIFont(name: "bananaslipplus", size: 24)
        topLabel.textColor = UIColor.white
        topLabel.frame.size = CGSize(width:self.frame.width, height: topLabelHeight)
        topLabel.backgroundColor = InkColor.Blue
        labelY += topLabel.frame.height + contentInset
        
        for n in 0...7 {
            
            let keyLabel = UILabel()
            let valueLabel = UILabel()
            keyLabel.font = font
            valueLabel.font = font
            
            if n < 7 { keyLabel.text = keysJp[n] } else { keyLabel.text = "の効果" }
            
            keyLabel.sizeToFit()
            keyLabel.frame.size.height *= 1.2
            
            if keyLabelWidth < keyLabel.frame.size.width {
                keyLabelWidth = keyLabel.frame.size.width
            }
            
            switch n {
            case 0:
                valueLabel.text = String(Double(Int(mainWeaponInfo!.damage * 10))/10)
            case 1:
                valueLabel.text = String(Double(Int(mainWeaponInfo!.range * 10))/10)
            case 2:
                valueLabel.text = String(Int(mainWeaponInfo!.fireRate)) + "F"
            case 3:
                valueLabel.text = String(Double(Int(mainWeaponInfo!.inkConsumption * 100))/100) + "%"
            case 4:
                valueLabel.text = String(Double(Int(mainWeaponInfo!.movementSpd * 100))/100)
            case 5:
                valueLabel.text = String(Double(Int(mainWeaponInfo!.movementSpdFiring * 100))/100)
            case 6:
                valueLabel.text = String(Double(Int(mainWeaponInfo!.swimingSpd * 100))/100)
            case 7:
                valueLabel.text = mainWeaponInfo!.mainPowerUp
            default:
                break
            }
            valueLabel.sizeToFit()
            valueLabel.frame.size.height = keyLabel.frame.size.height
            
            keyLabels.append(keyLabel)
            valueLabels.append(valueLabel)
            
        }
        
        //----------ラベルのフレーム----------
        
        for n in 0...6 {
         
            keyLabels[n].frame.origin.x = contentInset
            keyLabels[n].frame.origin.y = labelY
            
            valueLabels[n].frame.origin.x = contentInset + keyLabelWidth + labelGap * 2
            valueLabels[n].frame.origin.y = labelY
            
            labelY += valueLabels[n].frame.size.height + labelGap
            
        }

        //----------メイン性能アップアイコン----------
        
        let iconSize = valueLabels.last!.frame.size.height * 1.8
        powerupIcon.frame.size = CGSize(width: iconSize, height: iconSize)
        powerupIcon.frame.origin = CGPoint(x: contentInset, y:labelY + labelGap)
        powerupIcon.contentMode = .scaleAspectFit
        
        //メイン性能アップキーラベル
        let lastLabelY = powerupIcon.frame.origin.y + (iconSize - valueLabels.last!.frame.size.height) / 2
        let keyLabelX = powerupIcon.frame.origin.x + powerupIcon.frame.size.width + labelGap / 2
        keyLabels.last!.frame.origin = CGPoint(x: keyLabelX, y: lastLabelY)
        
        //メイン性能アップバリューラベル
        let valueLabelX = keyLabels.last!.frame.origin.x + keyLabels.last!.frame.size.width + labelGap * 2
        valueLabels.last!.frame.origin = CGPoint(x: valueLabelX, y: lastLabelY)
        
        //----------ラベルをビューに追加・ビューのサイズ----------
        
        self.frame.size.height = powerupIcon.frame.origin.y + powerupIcon.frame.size.height + contentInset
        
        backgroundCardView.frame.size = self.frame.size
        backgroundCardView.clipsToBounds = true
        backgroundCardView.layer.cornerRadius = cornerRadius
        backgroundCardView.backgroundColor = UIColor.white
        
        backgroundCardView.addSubview(topLabel)
        for n in 0...keyLabels.count - 1 {
            backgroundCardView.addSubview(keyLabels[n])
            backgroundCardView.addSubview(valueLabels[n])
        }
        backgroundCardView.addSubview(powerupIcon)
        
        self.backgroundColor = UIColor.clear
        self.addSubview(backgroundCardView)
        
        //----------メイン性能アップ詳細ボタン----------
        
        if mainWeaponInfo!.mainPowerUpKey != "" {
            let detailButton = UIButton()
            let buttonSize = valueLabels[7].frame.size.height * 2
            let buttonY = valueLabels.last!.frame.origin.y + (valueLabels.last!.frame.size.height - buttonSize) / 2
            let buttonX = self.frame.size.width - (self.frame.size.height - buttonY)
            
            detailButton.frame.origin = CGPoint(x: buttonX, y: buttonY)
            detailButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
            
            detailButton.layer.cornerRadius = detailButton.frame.size.height / 2
            detailButton.backgroundColor =  InkColor.Blue
            
            detailButton.layer.shadowColor = shadowColor
            detailButton.layer.shadowOffset = shadowOffset
            detailButton.layer.shadowRadius = shadowRadius
            detailButton.layer.shadowOpacity = shadowOpacity
            
            let tintedImage = UIImage(named: "tablecells_black")!.withRenderingMode(.alwaysTemplate)
            detailButton.setImage(tintedImage, for: .normal)
            detailButton.tintColor = UIColor.white
            detailButton.contentHorizontalAlignment = .center
            
            detailButton.tag = 0
            buttons.append(detailButton)
        }
        
        for button in buttons {
            backgroundCardView.addSubview(button)
        }
        
    }
    
    func increasedLabelHighlight(gearpower: [String:Int]) {
        
        let gearpowerPoints = [gearpower["インク効率アップ(メイン)"]!,
                               gearpower["ヒト移動速度アップ"]!,
                               gearpower["イカダッシュ速度アップ"]!]
        let labelNums = [[3], [4,5], [6]]
        
        for n in 0...gearpowerPoints.count - 1 {
            
            let gearpowerPoint = gearpowerPoints[n]
             
            if gearpowerPoint > 0 {
                for num in labelNums[n] {
                    keyLabels[num].textColor = UIColor.systemBlue
                    valueLabels[num].textColor = UIColor.systemBlue
                }
            }
            
        }
        
        //メイン性能アップの効果対象取得
        let mainPowerUpGearpoint = gearpower["メイン性能アップ"]!
        let mainPowerUpKey:String = mainWeaponInfo!.mainPowerUpKey
        var increasedLabelNum:Int?
        var increasedValue:Double?
        
        //上昇後の値
        if mainPowerUpKey == "damage" && mainPowerUpGearpoint > 0 {
            increasedLabelNum = 0
            increasedValue = Double(mainWeaponInfo!.getIncreasedValue(gearpowerPoint: mainPowerUpGearpoint))
        } else if mainPowerUpKey == "range" && mainPowerUpGearpoint > 0 {
            increasedLabelNum = 1
            increasedValue = Double(mainWeaponInfo!.range)
        }
        
        //ラベル変更があるかガード
        guard increasedLabelNum != nil else { return }
        
        //上昇後の値
        valueLabels[increasedLabelNum!].text = String(increasedValue!)
        valueLabels[increasedLabelNum!].sizeToFit()
        valueLabels[increasedLabelNum!].textColor = UIColor.systemBlue
        keyLabels[increasedLabelNum!].textColor = UIColor.systemBlue
        
        
    }

    func removeElements() {
        
        topLabel.removeFromSuperview()
        
        for label in keyLabels {
            label.removeFromSuperview()
        }
        keyLabels = []
        
        for label in valueLabels {
            label.removeFromSuperview()
        }
        valueLabels = []
        
        powerupIcon.removeFromSuperview()
        
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons = []
        
        backgroundCardView.removeFromSuperview()
        backgroundCardView = UIView()
        
    }
    
}
