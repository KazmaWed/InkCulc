import UIKit

class MainWeaponInfoView: UIView {

    let topLabel = UILabel()
    var keyLabels:[UILabel] = []
    var valueLabels:[UILabel] = []
    var buttons:[UIButton] = []
    
    var mainWeaponInfo:MainWeaponInfo?
    
    func set(weapon: Weapon) {
        
        //
        removeElements()
        
        let mainWeaponNum = inkApi.mainWeaponNum(of: weapon)
        mainWeaponInfo = inkApi.mainWeaponInfo[mainWeaponNum]
        
        var keyLabelWidth:CGFloat = 0
        var labelY:CGFloat = 0
        
        let labelGap:CGFloat = 10
        
        //----------ラベルのテキスト----------
        
        let keysJp = ["ダメージ","射程","連射間隔","インク消費", //0...3
            "ヒト速","ヒト速(攻撃中)","イカ速", //4...6
            "メイン性能アップ効果"] //7
        
        topLabel.text = "メインブキ性能"
        topLabel.font = UIFont(name: "bananaslipplus", size: 24)
        topLabel.sizeToFit()
        
        for n in 0...7 {
            
            let keyLabel = UILabel()
            keyLabel.text = keysJp[n]
            keyLabel.sizeToFit()
            
            if keyLabelWidth < keyLabel.frame.size.width {
                keyLabelWidth = keyLabel.frame.size.width
            }
            
            let valueLabel = UILabel()
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
            
            keyLabels.append(keyLabel)
            valueLabels.append(valueLabel)
            
        }
        
        //----------ラベルのフレーム----------
        
        labelY += topLabel.frame.size.height + labelGap
        
        for n in 0...keyLabels.count - 1 {
         
            keyLabels[n].frame.origin.y = labelY
            valueLabels[n].frame.origin.x = keyLabelWidth + labelGap * 2
            valueLabels[n].frame.origin.y = labelY
            
            labelY += valueLabels[n].frame.size.height + labelGap
            
        }
        
        if mainWeaponInfo!.mainPowerUpKey != "" {
            let detailButton = UIButton()
            detailButton.setTitle(">", for: .normal)
            detailButton.setTitleColor(UIColor.darkText, for: .normal)
            detailButton.contentHorizontalAlignment = .right
            detailButton.frame.size.width = self.frame.size.width
            detailButton.frame.size.height = keyLabels[7].frame.size.height
            detailButton.frame.origin.y = keyLabels[7].frame.origin.y
            detailButton.tag = 0
            buttons.append(detailButton)
        }
        
        //----------ラベルをビューに追加・ビューのサイズ----------
        
        self.addSubview(topLabel)
        for n in 0...keyLabels.count - 1 {
            self.addSubview(keyLabels[n])
            self.addSubview(valueLabels[n])
        }
        for button in buttons {
            self.addSubview(button)
        }
        self.frame.size.height = valueLabels.last!.frame.origin.y + valueLabels.last!.frame.size.height
        
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
                    keyLabels[num].textColor = UIColor.red
                    valueLabels[num].textColor = UIColor.red
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
        valueLabels[increasedLabelNum!].textColor = UIColor.systemRed
        keyLabels[increasedLabelNum!].textColor = UIColor.systemRed
        
        
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
        
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons = []
        
    }
    
}
