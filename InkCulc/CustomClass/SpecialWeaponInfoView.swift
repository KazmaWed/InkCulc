import UIKit

class SpecialWeaponInfoView: UIView {
    
    let topLabel = UILabel()
    var keyLabels:[UILabel] = []
    var valueLabels:[UILabel] = []
    var buttons:[UIButton] = []
    
    func set(weapon:Weapon) {
        
        removeElements()
        
        let specialWeaponName = weapon.special
        //        let specialWeaponNum = inkApi.subWeaponNum(of: weapon)
        //        let subWeaponInfo = inkApi.specialInfo[specialWeaponNum]
        
        var keyLabelWidth:CGFloat = 0
        var labelY:CGFloat = 0
        
        let labelGap:CGFloat = 10
        
        //----------ラベルのテキスト----------
        
        topLabel.text = specialWeaponName
        topLabel.font = UIFont(name: "bananaslipplus", size: 24)
        topLabel.sizeToFit()
        
        //ダメージ
        let damagesRaw = inkApi.specialDamage
        if let damages = inkApi.dict(keysAndNumValues: damagesRaw)[specialWeaponName] {
            for (key, value) in damages {
                
                let keyLabel = UILabel()
                keyLabel.text = key
                keyLabel.sizeToFit()
                
                if keyLabelWidth < keyLabel.frame.size.width {
                    keyLabelWidth = keyLabel.frame.size.width
                }
                
                let valueLabel = UILabel()
                valueLabel.text = String(Double(Int(value * 10)) / 10)
                valueLabel.sizeToFit()
                
                keyLabels.append(keyLabel)
                valueLabels.append(valueLabel)
                
            }
        }
        
        //その他情報
        let infoRaw = inkApi.specialInfo
        if let info = inkApi.dict(keysAndStringValues: infoRaw)[specialWeaponName] {
            for (key, value) in info {
                
                let keyLabel = UILabel()
                keyLabel.text = key
                keyLabel.sizeToFit()
                
                if keyLabelWidth < keyLabel.frame.size.width {
                    keyLabelWidth = keyLabel.frame.size.width
                }
                
                let valueLabel = UILabel()
                valueLabel.text = value
                valueLabel.sizeToFit()
                
                keyLabels.append(keyLabel)
                valueLabels.append(valueLabel)
                
            }
        }
        
        
        //----------ラベルのフレーム----------
        
        labelY = topLabel.frame.size.height + labelGap
        
        for n in 0...keyLabels.count - 1 {
            
            keyLabels[n].frame.origin.y = labelY
            valueLabels[n].frame.origin.x = keyLabelWidth + labelGap * 2
            valueLabels[n].frame.origin.y = labelY
            
            labelY += valueLabels[n].frame.size.height + labelGap
            
        }
        
        //----------ラベルをビューに追加・ビューのサイズ----------
        
        self.addSubview(topLabel)
        for n in 0...keyLabels.count - 1 {
            self.addSubview(keyLabels[n])
            self.addSubview(valueLabels[n])
        }
        self.frame.size.height = valueLabels.last!.frame.origin.y + valueLabels.last!.frame.size.height
        
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
