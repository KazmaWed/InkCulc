import Foundation
import Alamofire
import AlamofireImage

class InkAPI {
    
    var weaponInfo:WeaponInfo?
    var weaponList:[Weapon] = []
    var weaponImages:[UIImage] = []
    var mainWeaponInfo:[MainWeaponInfo] = []
    var subWeaponInfo:[SubWeaponInfo] = []
    var bombDamage:[KeysAndValues] = []
    var specialInfo:[KeysAndValues] = []
    var specialDamage:[KeysAndValues] = []
    
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
                        self.weaponList = self.weaponInfo!.weaponList
                        self.mainWeaponInfo = self.weaponInfo!.mainWeaponInfo
                        self.subWeaponInfo = self.weaponInfo!.subWeaponInfo
                        self.bombDamage = self.weaponInfo!.bombDamage
                        self.specialInfo = self.weaponInfo!.specialInfo
                        self.specialDamage = self.weaponInfo!.specialDamage
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
                
                let weaponImage = UIImage(data: data)
                self.weaponImages.append(weaponImage!)
                
                dispatchGroup.leave()
            }
            
        }
        
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            closure()
        }
        
    }
    
    //ブキのインデックス取得
    func weaponNum(of:Weapon) -> Int? {
        var weaponNum:Int?
        
        for n in 0...weaponList.count - 1 {
            if weaponList[n].name == of.name {
                weaponNum = n
            }
        }
        
        if weaponNum != nil {
            return weaponNum
        } else {
            return nil
        }
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
    
    
    func increasedValues(of:Weapon) -> [Int:Double] {
        
        let weaponNum = self.weaponNum(of: of)
        let rowValues = mainWeaponInfo[weaponNum!].increasedValues
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
    
    
    func dict(keysAndNumValues:[KeysAndValues]) -> [String:[String:Double]]{
        
        var outputDict:[String:[String:Double]] = [:]
        
        for n in 0...keysAndNumValues.count - 1 {
            
            let name = keysAndNumValues[n].name
            let keys = keysAndNumValues[n].keys.split(separator: ",")
            let values = keysAndNumValues[n].values.split(separator: ",")
            let valuesCount = values.count
            
            var outputInfo:[String:Double] = [:]
            for n in 0...valuesCount - 1 {
                let key = String(keys[n])
                let value = Double(values[n])!
                outputInfo.updateValue(value, forKey: key)
            }
            
            outputDict.updateValue(outputInfo, forKey: name)
            
        }
        
        return outputDict
    }
    
    func dict(keysAndStringValues:[KeysAndValues]) -> [String:[String:String]] {
        
        var outputDict:[String:[String:String]] = [:]
        
        for n in 0...keysAndStringValues.count - 1 {
            
            let name = keysAndStringValues[n].name
            let keys = keysAndStringValues[n].keys.split(separator: ",")
            let values = keysAndStringValues[n].values.split(separator: ",")
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
