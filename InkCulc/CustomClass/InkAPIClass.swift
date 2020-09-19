import Foundation
import Alamofire
import AlamofireImage

class InkAPI {
    
    var weaponInfo:WeaponInfo?
    var weaponImageData:[Data] = []
    var weaponList:[Weapon] = []
    var weaponImages:[UIImage] = []
    var mainWeaponInfo:[MainWeaponInfo] = []
    var subWeaponInfo:[SubWeaponInfo] = []
    var bombDamageRaw:[KeysAndValues] = []
    var specialInfo:[KeysAndValues] = []
    var specialDamageRaw:[KeysAndValues] = []
    
    var ifError = false
    
    //全ブキ取得
    func getWeapons(closure: @escaping () -> Void) {
        
        //URL
        let url = "https://script.google.com/macros/s/AKfycbzcLxKM3R4QJSqwwClqJ8ul8VFyVW6k2HrUvhhh-14tOcafu4zq/exec"
        //json形式で取得
        let headers: HTTPHeaders = ["Content-Type": "application/json"]
        
        ifError = false
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default,
                   headers: headers).responseJSON { response in
                    
                    //データなしガード
                    guard let data = response.data else { print("Error: No data obtained."); return }
                    
                    //data中のjsonを配列にして格納
                    do {
                        self.weaponInfo = try JSONDecoder().decode(WeaponInfo.self, from: data)
                        closure()
                    } catch let error {
                        self.ifError = true
                        print("Error: \(error)")
                        closure()
                    }
                    
        }
    }
    
    //全ブキ画像取得
    func getWeaponImages(closure: @escaping () -> Void) {
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        for eachWeapon in weaponList {
            
            dispatchGroup.enter()
            
            let url = eachWeapon.imageUrl()
            AF.request(url, method: .get).responseImage { response in
                guard let data = response.data else { print("Error: No data obtained."); return }
                
                self.weaponImageData.append(data)
                dispatchGroup.leave()
            }
            
        }
        
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            self.dataToUIImage()
            closure()
        }
        
    }
    
    //ブキのインデックス取得
    func weaponNum(of:Weapon) -> Int {
        var weaponNum:Int?
        
        for n in 0...weaponList.count - 1 {
            if weaponList[n].name == of.name {
                weaponNum = n
            }
        }
        
        return weaponNum!
    }
    //メイン武器のインデックス取得
    func mainWeaponNum(of:Weapon) -> Int {
        var mainWeaponNum = 0
        
        for n in 0...self.mainWeaponInfo.count - 1 {
            if mainWeaponInfo[n].name == of.main {
                mainWeaponNum = n
                break
            }
        }
        
        return mainWeaponNum
    }
    
    //サブのインデックス取得
    func subWeaponNum(of:Weapon) -> Int {
        
        var subWeaponNum = 0
        let subWeaponName = of.sub
        
        for n in 0...inkApi.subWeaponInfo.count - 1 {
            if inkApi.subWeaponInfo[n].name == subWeaponName {
                subWeaponNum = n
                break
            }
        }
        
        return subWeaponNum
    }
    
    //スペシャルのインデックス取得
    func specialWeaponNum(of:Weapon) -> Int {
        
        var specialWeaponNum = 0
        let specialWeaponName = of.special
        
        for n in 0...inkApi.subWeaponInfo.count - 1 {
            if inkApi.specialInfo[n].name == specialWeaponName {
                specialWeaponNum = n
                break
            }
        }
        
        return specialWeaponNum
    }
    
    //ブキをメインごとにグループ分け
    func weaponsGroupedByMain() -> [[Weapon]] {
        
        var weaponsGrouped:[[Weapon]] = []
        var weaponsRemain = weaponList
        
        while weaponsRemain.count > 0 {
            
            let firstWeapon = weaponsRemain[0]
            var group:[Weapon] = [firstWeapon]
            weaponsRemain.remove(at: 0)
            
            let weaponsRemainCount = weaponsRemain.count
            
            for n in 0...weaponsRemainCount - 1 {
                
                let m = weaponsRemainCount - 1 - n
                
                if weaponsRemain[m].main == firstWeapon.main {
                    group.insert(weaponsRemain[m], at: 1)
                    weaponsRemain.remove(at: m)
                }
                
            }
            
            weaponsGrouped.append(group)
            
        }
        
        return weaponsGrouped
        
    }
    
    
    //--------------------json変換メソッド--------------------
    
    func decodeWeaponInfo() {
        
        weaponList = weaponInfo!.weaponList
        mainWeaponInfo = weaponInfo!.mainWeaponInfo
        subWeaponInfo = weaponInfo!.subWeaponInfo
        bombDamageRaw = weaponInfo!.bombDamage
        specialInfo = weaponInfo!.specialInfo
        specialDamageRaw = weaponInfo!.specialDamage
        
    }
    
    func dataToUIImage() {
        
        for data in weaponImageData {
            weaponImages.append(UIImage(data: data)!)
        }
        
    }
    
    func increasedValues(of:Weapon) -> [Int:Double] {
        
        let mainWeaponNum = self.mainWeaponNum(of: of)
        let rowValues = mainWeaponInfo[mainWeaponNum].increasedValues
        let stringArray = rowValues.split(separator: ",")
        
        var doubleArray:[Int:Double] = [:]
        for n in 0...stringArray.count - 1 {
            let gP = gearpowerNums[n]
            let double = Double(stringArray[n])!
            doubleArray.updateValue(double, forKey: gP)
        }
        
        return doubleArray
    }
    
    func subWeaponInfoDict() -> [String:SubWeaponInfo] {
        
        var outputDict:[String:SubWeaponInfo] = [:]
        
        for n in 0...subWeaponInfo.count - 1 {
            let name = subWeaponInfo[n].name
            let info = subWeaponInfo[n]
            outputDict.updateValue(info, forKey: name)
        }
        
        return outputDict
    }
    
    func bombDamage(of weapon:Weapon) -> [(String,Double)]? {
        
        //出力用タプル配列(ダメージ小さい順)
        var output:[(String, Double)]?
        //出力前の辞書(ダメージソート前の値格納)
        var numberDict:[String:Double] = [:]
        
        let subName = weapon.sub
        
        for bomb in bombDamageRaw {
            if bomb.name == subName {
                let rawDict = bomb.dict()
                for eachone in rawDict {
                    numberDict[eachone.key] = Double(Int(Double(eachone.value)! * 10)) / 10
                }
                break
            }
        }
        
        //サブがボムじゃない時はnilを返す
        guard numberDict != [:] else { return nil }
        
        //辞書をソートしてタプル配列に変換
        output = numberDict.sorted(by: { a, b  -> Bool in
            return a.value < b.value
        })
        
        return output!
    }
    
    func damageArray(damageArrayRaw:[KeysAndValues]) -> [[(String,String,Double)]] {
        
        var output:[[(String,String,Double)]] = []
        
        for damages in damageArrayRaw {
            
            let name = damages.name
            var newArray:[(String,String,Double)] = []
            
            let keys = damages.keys.split(separator: ",")
            let values = damages.values.split(separator: ",")
            
            for n in 0...keys.count - 1 {
                
                let key = String(keys[n])
                let value = Double(values[n])!
                if value >= 10 {
                    let newTaple = (name, key, value)
                    newArray.append(newTaple)
                }
                    
            }
            
            if newArray.count > 0 {
                //ソート
                let sortedArray:[(String,String,Double)] = newArray.sorted(by: { a, b -> Bool in
                    return a.2 < b.2
                })
                
                output.append(sortedArray)
            }
        }
        
        return output
        
    }
    
    func specialDamage(of weapon: Weapon) -> [(String,Double)]? {
        
        //出力用タプル配列(ダメージ小さい順)
        var output:[(String, Double)]?
        //出力前の辞書(ダメージソート前の値格納)
        var numberDict:[String:Double] = [:]
        
        let specialName = weapon.special
        
        for special in specialDamageRaw {
            if special.name == specialName {
                let rawDict = special.dict()
                for eachone in rawDict {
                    numberDict[eachone.key] = Double(Int(Double(eachone.value)! * 10)) / 10
                }
                break
            }
        }
        
        //スペシャルが攻撃系じゃない時はnilを返す
        guard numberDict != [:] else { return nil }
        
        //辞書をソートしてタプル配列に変換
        output = numberDict.sorted(by: { a, b  -> Bool in
            return a.value < b.value
        })
        
        return output!
        
    }
    
    func specialInfoDict() -> [String:[String:String]] {
        
        var outputDict:[String:[String:String]] = [:]
        
        for n in 0...specialInfo.count - 1 {
            
            let name = specialInfo[n].name
            let keys = specialInfo[n].keys.split(separator: ",")
            let values = specialInfo[n].values.split(separator: ",")
            let valuesCount = values.count
            
            var outputInfo:[String:String] = [:]
            for n in 0...valuesCount - 1 {
                let key = String(keys[n])
                let value = String(values[n])
                outputInfo.updateValue(value, forKey: key)
            }
            
            outputDict.updateValue(outputInfo, forKey: name)
            
        }
        
        return outputDict
    }
    
}
