import UIKit

class MainDamageCulcView: UIView {
    
    var mainWeaponInfo:MainWeaponInfo?
    var mainWeaponDamage:Double?
    var bombDamage:[(String,Double)]?
    var specialDamage:[(String,Double)]?
    
    var totalDamages:[Double] = []
    var remainingHps:[Double] = []
    var decisiveAttack:[[(String,String,Double)?]] = []
    
    var topLabel = UILabel()
    var damageLabels:[UILabel] = []
    var remainingHpLabels:[UILabel] = []
    var decisiveAttackLabels:[[UILabel]] = []
    
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
                let slipDamage:Double = Double(slipDamageFrame) * 0.3
                decisiveAttack[arrayNum].append(("相手インクダメージ", "\(slipDamageFrame)F", slipDamage))
                
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
    
    func size(width:CGFloat) {
        
        //ビュー初期化
        removeElements()
        
        var labelY:CGFloat = 0
        
        let labelGap:CGFloat = 10
        
        self.frame.size.width = CGFloat(width)
        topLabel.text = "ダメージ計算"
        topLabel.font = UIFont(name: "bananaslipplus", size: 24)
        topLabel.sizeToFit()
        
        for n in 0...totalDamages.count - 1 {
            
            //与えるダメージ
            let hit = totalDamages.count - n
            let damage = String(totalDamages[n])
            damageLabels.append(UILabel())
            damageLabels[n].text = "メイン \(hit)発ヒット " + damage
            damageLabels[n].sizeToFit()
            
            //残りHP
            remainingHpLabels.append(UILabel())
            let remainingHp = remainingHps[n]
            if remainingHp < 0 {
                remainingHpLabels[n].text = "確定キル"
            } else if remainingHp < 10 {
                remainingHpLabels[n].text = "残りHP " + String(remainingHp) + " (擬似確)"
            } else {
                remainingHpLabels[n].text = "残りHP " + String(remainingHp)
            }
            remainingHpLabels[n].sizeToFit()
            
            //決定打ラベル
            decisiveAttackLabels.append([])
            for m in 0...decisiveAttack[n].count - 1 {
                if decisiveAttack[n][m] != nil {
                    decisiveAttackLabels[n].append(UILabel())
                    decisiveAttackLabels[n].last!.text = "\(decisiveAttack[n][m]!.0) \(decisiveAttack[n][m]!.1) \(String(decisiveAttack[n][m]!.2))"
                    decisiveAttackLabels[n].last!.sizeToFit()
                }
            }

        }
        
        //----------ラベルのフレーム----------
        
        labelY += topLabel.frame.size.height + labelGap
        
        for n in 0...damageLabels.count - 1 {
            
            //ダメージラベル
            damageLabels[n].frame.origin = CGPoint(x: 0, y: labelY)
            let remainingHpLabelX = width -  remainingHpLabels[n].frame.size.width
            
            //残りHP
            remainingHpLabels[n].frame.origin = CGPoint(x: remainingHpLabelX, y: labelY)
            
            labelY += remainingHpLabels[n].frame.size.height + labelGap
            
            //決定打ラベル
            if decisiveAttackLabels[n].count > 0 {
                for m in 0...decisiveAttackLabels[n].count - 1 {
                    let decisiveAttackLabelX = width - decisiveAttackLabels[n][m].frame.size.width
                    decisiveAttackLabels[n][m].frame.origin = CGPoint(x: decisiveAttackLabelX, y: labelY)
                    labelY += decisiveAttackLabels[n][m].frame.size.height + labelGap
                }
            }
                
        }
        
        //----------ラベルをビューに追加・ビューのサイズ----------
        
        self.addSubview(topLabel)
        
        for n in 0...damageLabels.count - 1 {
            self.addSubview(damageLabels[n])
            self.addSubview(remainingHpLabels[n])
            for label in decisiveAttackLabels[n] {
                self.addSubview(label)
            }
        }
        
        self.frame.size.height =  labelY
        
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
        damageLabels = []
        remainingHpLabels = []
        decisiveAttackLabels = []
        
    }
    
}
