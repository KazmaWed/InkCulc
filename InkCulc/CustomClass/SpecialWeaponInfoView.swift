import UIKit

class SpecialWeaponInfoView: UIView {
    
    let topLabel = UILabel()
    var keyLabels:[UILabel] = []
    var valueLabels:[UILabel] = []
    let powerupIcon = UIImageView(image: UIImage(named: "スペシャル性能アップ"))
    var buttons:[UIButton] = []
    var backgroundCardView = UIView()
    
    func set(weapon:Weapon) {
        
        removeElements()
        
        let specialWeaponName = weapon.special
        
        var keyLabelWidth:CGFloat = 0
        var labelY:CGFloat = 0
        
        let topLabelHeight:CGFloat = 54
        let contentInset:CGFloat = 18
        let labelGap:CGFloat = 10
        
        //----------ラベルのテキスト----------
        
        topLabel.text = specialWeaponName
        topLabel.textAlignment = .center
        topLabel.font = InkFont.Banana
        topLabel.textColor = UIColor.white
        topLabel.frame.size = CGSize(width:self.frame.width, height: topLabelHeight)
        topLabel.backgroundColor = InkColor.yellow
        
        //ダメージ
        if let damages = inkApi.specialDamage(of: weapon) {
            for (key, value) in damages {
                
                let keyLabel = UILabel()
                let valueLabel = UILabel()
                keyLabel.font = InkFont.Sans
                valueLabel.font = InkFont.Sans
                
                keyLabel.text = key
                keyLabel.sizeToFit()
                keyLabel.frame.size.height *= 1.2
                
                if keyLabelWidth < keyLabel.frame.size.width {
                    keyLabelWidth = keyLabel.frame.size.width
                }
                
                valueLabel.text = String(Double(Int(value * 10)) / 10)
                valueLabel.sizeToFit()
                valueLabel.frame.size.height = keyLabel.frame.size.height
                
                keyLabels.append(keyLabel)
                valueLabels.append(valueLabel)
                
            }
        }
        
        //その他情報
        if let info = inkApi.specialInfoDict()[specialWeaponName] {
            
            //スペシャル性能アップ以外
            for (key, value) in info {
                if key != "スペシャル性能アップ効果" {
                    
                    let keyLabel = UILabel()
                    let valueLabel = UILabel()
                    keyLabel.font = InkFont.Sans
                    valueLabel.font = InkFont.Sans
                    
                    keyLabel.text = key
                    keyLabel.sizeToFit()
                    keyLabel.frame.size.height *= 1.2
                    
                    if keyLabelWidth < keyLabel.frame.size.width {
                        keyLabelWidth = keyLabel.frame.size.width
                    }
                    
                    valueLabel.text = value
                    valueLabel.sizeToFit()
                    valueLabel.frame.size.height = keyLabel.frame.size.height
                    
                    keyLabels.append(keyLabel)
                    valueLabels.append(valueLabel)
                    
                }
            }
            
            //スペシャル性能アップ
            for (key, value) in info {
                if key == "スペシャル性能アップ効果" {
                    
                    let keyLabel = UILabel()
                    let valueLabel = UILabel()
                    keyLabel.font = InkFont.Sans
                    valueLabel.font = InkFont.Sans
                    
                    keyLabel.text = "の効果"
                    keyLabel.sizeToFit()
                    keyLabel.frame.size.height *= 1.2
                    
                    if keyLabelWidth < keyLabel.frame.size.width {
                        keyLabelWidth = keyLabel.frame.size.width
                    }
                    
                    valueLabel.text = value
                    valueLabel.sizeToFit()
                    valueLabel.frame.size.height = keyLabel.frame.size.height
                    
                    keyLabels.append(keyLabel)
                    valueLabels.append(valueLabel)
                    
                }
            }
            
        }
        
        
        //----------ラベルのフレーム----------
        
        labelY = topLabel.frame.size.height + contentInset
        
        for n in 0...keyLabels.count - 2 {
            
            keyLabels[n].frame.origin.x = contentInset
            keyLabels[n].frame.origin.y = labelY
            
            valueLabels[n].frame.origin.x = contentInset + keyLabelWidth + labelGap * 2
            valueLabels[n].frame.origin.y = labelY
            
            labelY += valueLabels[n].frame.size.height + labelGap
            
        }
        
        //----------性能アップアイコン----------
        
        let iconSize = valueLabels.last!.frame.size.height * 1.8
        powerupIcon.frame.size = CGSize(width: iconSize, height: iconSize)
        powerupIcon.frame.origin = CGPoint(x: contentInset, y:labelY)
        powerupIcon.contentMode = .scaleAspectFit
        
        //性能アップキーラベル
        let lastLabelY = powerupIcon.frame.origin.y + (iconSize - valueLabels.last!.frame.size.height) / 2
        let keyLabelX = powerupIcon.frame.origin.x + powerupIcon.frame.size.width + labelGap / 2
        keyLabels.last!.frame.origin = CGPoint(x: keyLabelX, y: lastLabelY)
        
        //性能アップバリューラベル
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
        
        backgroundCardView.removeFromSuperview()
        
    }
    
}
