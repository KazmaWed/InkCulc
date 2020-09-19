import UIKit

class MainDamageCulcView: UIView {
    
    var mainWeaponInfo:MainWeaponInfo?
    var mainWeaponDamage:Double?
    var bombDamage:[(String,Double)]?
    var specialDamage:[(String,Double)]?
    
    var totalDamages:[Double] = []
    var remainingHps:[Double] = []
    var thresholds:[Double] = []
    var decisiveAttack:[[(String,String,Double)?]] = []
    
    var topLabel = UILabel()
    var damageLabels:[UILabel] = []
    var remainingHpLabels:[UILabel] = []
    var decisiveAttackLabels:[[UILabel]] = []
    var buttons:[UIButton] = []
    var backgroundCardView = UIView()
    
    func culc(weapon:Weapon, gearpowerPoint:[String:Int]) {
        
        //配列初期化
        totalDamages = []
        remainingHps = []
        decisiveAttack = []
        
        //ブキ情報取得
        let mainWeaponNum = inkApi.mainWeaponNum(of: weapon)
        mainWeaponInfo = inkApi.mainWeaponInfo[mainWeaponNum]
        let subName = weapon.sub
        let specialName = weapon.special
        
        //メインダメージ取得
        if mainWeaponInfo?.mainPowerUpKey == "damage" && gearpowerPoint["メイン性能アップ"]! > 0 {
            
            let mainPowerupPoint:Int = gearpowerPoint["メイン性能アップ"]!
            let increasedValues = inkApi.increasedValues(of: weapon)
            
            for n in 0...gearpowerNums.count - 1 {
                if gearpowerNums[n] == mainPowerupPoint || n == increasedValues.count - 1 {
                    let gearpower = gearpowerNums[n]
                    mainWeaponDamage = increasedValues[gearpower]
                    break
                }
            }
            
        } else {
            mainWeaponDamage = mainWeaponInfo!.damage
        }
        
        //サブ・スペシャルダメージ取得
        bombDamage = inkApi.bombDamage(of: weapon)
        specialDamage = inkApi.specialDamage(of: weapon)
        
        let requiredHits:Int = Int(ceil(100.0 / mainWeaponDamage!))
        
        for n in 1...requiredHits {
            
            let arrayNum = n - 1
            
            //メインによるダメージと残りHP
            let hit:Int = requiredHits - n + 1
            let totalDamage:Double = Double(Int(Double(hit) * mainWeaponDamage! * 10)) / 10
            let remainingHp:Double = Double(Int((100.0 - totalDamage) * 10)) / 10
            totalDamages.append(totalDamage)
            remainingHps.append(remainingHp)
            
            //サブスペでとどめをさせるか
            decisiveAttack.append([])
            var ifFound = false
            
            if remainingHp > 0 && remainingHp < 10 {
                
                //擬似確フレーム
                let slipDamageFrame:Int = Int(ceil(remainingHp / 0.3))
                let slipDamage:Double = Double(Int((Double(slipDamageFrame) * 0.3) * 10)) / 10
                decisiveAttack[arrayNum].append(("相手インクダメージ", "\(slipDamageFrame)F ", slipDamage))
                
            } else {
                
                //確定ボムダメージ
                if bombDamage != nil {
                    for (key, damage) in bombDamage! {
                        if totalDamage < 100.0 && damage < 100.0 && damage >= remainingHp {
                            decisiveAttack[arrayNum].append((subName,key,damage))
                            ifFound = true
                            break
                        }
                    }
                }
                //確定スペシャルダメージ
                if specialDamage != nil {
                    for (key, damage) in specialDamage! {
                        if totalDamage < 100.0 && damage < 100.0 && damage >= remainingHp && damage >= 10.0 {
                            decisiveAttack[arrayNum].append((specialName,key,damage))
                            ifFound = true
                            break
                        }
                    }
                }
                
            }
                
            if !ifFound {
                decisiveAttack[arrayNum].append(nil)
            }
            
        }
        
    }
    
    func size() {
        
        //ビュー初期化
        removeElements()
        
        let width = self.frame.width
        
        var labelY:CGFloat = 0
        
        let topLabelHeight:CGFloat = 54
        let contentInset:CGFloat = 18
        let labelGap:CGFloat = 10
        
        self.frame.size.width = CGFloat(width)
        
        topLabel.text = "ダメージ計算"
        topLabel.textAlignment = .center
        topLabel.font = InkFont.Banana
        topLabel.textColor = UIColor.white
        topLabel.frame.size = CGSize(width: width, height: topLabelHeight)
        topLabel.backgroundColor = InkColor.green
        
        for n in 0...totalDamages.count - 1 {
            
            //与えるダメージ
            let hit = totalDamages.count - n
            let damage = String(totalDamages[n])
            damageLabels.append(UILabel())
            damageLabels[n].font = InkFont.Sans
            damageLabels[n].text = "メイン \(hit)発ヒット " + damage
            damageLabels[n].sizeToFit()
            damageLabels[n].frame.size.height *= 1.1
            
            //残りHP
            remainingHpLabels.append(UILabel())
            let remainingHp = remainingHps[n]
            if remainingHp < 0 {
                remainingHpLabels[n].text = "確定ダウン"
            } else if remainingHp < 10 {
                remainingHpLabels[n].text = "残りHP " + String(remainingHp) + " (擬似確)"
            } else {
                remainingHpLabels[n].text = "残りHP " + String(remainingHp)
            }
            remainingHpLabels[n].sizeToFit()
            remainingHpLabels[n].frame.size.height = damageLabels[n].frame.size.height
            
            //決定打ラベル
            decisiveAttackLabels.append([])
            for m in 0...decisiveAttack[n].count - 1 {
                if decisiveAttack[n][m] != nil {
                    decisiveAttackLabels[n].append(UILabel())
                    let text = "\(decisiveAttack[n][m]!.0) \(decisiveAttack[n][m]!.1) \(String(decisiveAttack[n][m]!.2))"
                    decisiveAttackLabels[n].last!.text = text
                    decisiveAttackLabels[n].last!.font = InkFont.Sans
                    decisiveAttackLabels[n].last!.textColor = InkColor.textBlue
                    decisiveAttackLabels[n].last!.sizeToFit()
                    decisiveAttackLabels[n].last!.frame.size.height *= 1.2
                }
            }
            
            //全ダメージテーブルボタン
            if n > 0 {
                let button = UIButton()
                button.setTitle("すべてのダメージ ＞", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.sizeToFit()
                
                let buttonInset:CGFloat = 8
                button.frame.size = CGSize(width: button.frame.width + buttonInset * 2,
                                           height: button.frame.height)
                button.layer.cornerRadius = button.frame.height / 2
                
                button.backgroundColor = InkColor.green
                button.layer.shadowColor = shadowColor
                button.layer.shadowOffset = shadowOffset
                button.layer.shadowRadius = shadowRadius
                button.layer.shadowOpacity = shadowOpacity
                
                button.tag = n - 1
                buttons.append(button)
                
                thresholds.append(remainingHps[n])
            }
            

        }
        
        //----------ラベルのフレーム----------
        
        labelY += topLabel.frame.size.height + contentInset
        
        for n in 0...damageLabels.count - 1 {
            
            //ダメージラベル
            damageLabels[n].frame.origin = CGPoint(x: contentInset, y: labelY)
            
            //残りHP
            let remainingHpLabelX = width -  remainingHpLabels[n].frame.size.width - contentInset
            remainingHpLabels[n].frame.origin = CGPoint(x: remainingHpLabelX, y: labelY)
            
            labelY += remainingHpLabels[n].frame.size.height + labelGap
            
            //決定打ラベル
            if decisiveAttackLabels[n].count > 0 {
                for m in 0...decisiveAttackLabels[n].count - 1 {
                    let decisiveAttackLabelX = width - decisiveAttackLabels[n][m].frame.size.width - contentInset
                    decisiveAttackLabels[n][m].frame.origin = CGPoint(x: decisiveAttackLabelX, y: labelY)
                    labelY += decisiveAttackLabels[n][m].frame.size.height + labelGap
                }
            }
            
            //ボタン
            if n > 0 {
                let m = n - 1
                let buttonX = width - buttons[m].frame.size.width - contentInset
                buttons[m].frame.origin = CGPoint(x: buttonX, y: labelY)
                labelY += buttons[m].frame.size.height + contentInset
            } else {
                labelY = damageLabels.first!.frame.origin.y + damageLabels.first!.frame.size.height + contentInset
            }
            
            //仕切り線
            if n != damageLabels.count - 1 {
                let border = UIView()
                border.frame.size = CGSize(width: width, height: 1)
                border.frame.origin.y = labelY
                border.backgroundColor = InkColor.lightGray
                backgroundCardView.addSubview(border)
            }
            
            labelY += contentInset
            
        }
        
        //----------ラベルをビューに追加・ビューのサイズ----------
        
        let viewHeight = buttons.last!.frame.origin.y + buttons.last!.frame.height + contentInset
        self.frame.size.height = viewHeight
        
        backgroundCardView.frame.size = self.frame.size
        backgroundCardView.clipsToBounds = true
        backgroundCardView.layer.cornerRadius = cornerRadius
        backgroundCardView.backgroundColor = UIColor.white
        
        backgroundCardView.addSubview(topLabel)
        
        for n in 0...damageLabels.count - 1 {
            backgroundCardView.addSubview(damageLabels[n])
            backgroundCardView.addSubview(remainingHpLabels[n])
            for label in decisiveAttackLabels[n] {
                backgroundCardView.addSubview(label)
            }
            
            if n > 0 {
                let m = n - 1
                backgroundCardView.addSubview(buttons[m])
            }
        }
        
        self.backgroundColor = UIColor.clear
        self.addSubview(backgroundCardView)
        
    }
    
    func removeElements() {
        
        for label in damageLabels {
            label.removeFromSuperview()
        }
        for label in remainingHpLabels {
            label.removeFromSuperview()
        }
        for array in decisiveAttackLabels {
            for label in array {
                label.removeFromSuperview()
            }
        }
        for button in buttons {
            button.removeFromSuperview()
        }
        backgroundCardView.removeFromSuperview()
        damageLabels = []
        remainingHpLabels = []
        decisiveAttackLabels = []
        buttons = []
        thresholds = []
        backgroundCardView = UIView()
        
    }
    
}
