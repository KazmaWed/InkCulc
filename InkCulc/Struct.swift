import Foundation
import UIKit
import AlamofireImage

class Gearset: Codable{
    var id:Int?
    var weapon:Weapon
    var gearpowerNames:[[String]]?
    
    init(weapon:Weapon) {
        self.weapon = weapon
    }
}


class Weapon: Codable {
    
    let name:String
    let main:String
    let collectionName:String?
    let sub:String
    let special:String
    let point:Int
    
    func imageUrl() -> URL {
        let imageUrlBase = "https://cdn.wikiwiki.jp/to/w/splatoon2mix/ブキ/::ref/メイン-"
        let imageUrlString = imageUrlBase + name + ".png"
        let encodeUrlString:String = imageUrlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let imageUrl:URL = URL(string: encodeUrlString)!
        
        return imageUrl
    }
    
}

class WeaponInfo: Codable {
    let weaponList:[Weapon]
    let mainWeaponInfo:[MainWeaponInfo]
    let subWeaponInfo:[SubWeaponInfo]
    let bombDamage:[KeysAndValues]
    let specialInfo:[KeysAndValues]
    let specialDamage:[KeysAndValues]
}

class MainWeaponInfo: Codable {
    let name:String
    let damage:Double
    let range:Double
    let fireRate:Int
    let inkConsumption:Double
    let movementSpd:Double
    let movementSpdFiring:Double
    let swimingSpd:Double
    let mainPowerUp:String
    let mainPowerUpKey:String
    let increasedValues:String
    
    func getIncreasedValue(gearpowerPoint: Int) -> Double {
        
        var increasedValue:Double?
        var valueIndex:Int?
        
        //ギアパワーが配列の何番目か取得
        for n in 0...gearpowerNums.count - 1 {
            if gearpowerNums[n] == gearpowerPoint {
                valueIndex = n
                break
            }
        }
        
        //配列から値を取得
        let increasedValuesArray = increasedValues.components(separatedBy: ",")
        for n in 0...valueIndex! {
            let m =  valueIndex! - n
            
            //ギアパワーによる効果の上限を超えてないか確認して値を取得
            if increasedValuesArray.count - 1 >= m {
                let increasedRawValue = Double(increasedValuesArray[m])!
                increasedValue = Double(Int(increasedRawValue * 10)) / 10
                break
            }
        }
        
        return increasedValue!
        
    }
}

class SubWeaponInfo: Codable {
    let name:String
    let inkConsumption:Double
    let subPowerUp:String
}

class KeysAndValues:Codable {
    let name:String
    let keys:String
    let values:String
    
    func dict() -> [String:String] {
        
        var output:[String:String] = [:]
        
        let keyArray = keys.split(separator: ",")
        let valueArray = values.split(separator: ",")
        
        for n in 0...keyArray.count - 1 {
            output.updateValue(String(valueArray[n]),
                               forKey: String(keyArray[n]))
        }
        
        return output
    }
    
}
