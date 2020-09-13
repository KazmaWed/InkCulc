import UIKit

class GearsetDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weapon = gearset!.weapon
        gearpowerNames = gearset!.gearpowerNames
        
        //ブキ画像
        weaponSetImageView.setSize(width: weaponSetImageView.frame.size.width,
                                height: weaponSetImageView.frame.size.height)
        weaponSetImageView.set(weapon: weapon!)
        
        //ギアパワー画像
        gearpowerView.setSize(width: gearpowerView.frame.size.width,
                              height: gearpowerView.frame.size.height)
        gearpowerView.gearpowerNames = gearpowerNames!
        gearpowerView.reloadIcon()
        
        //バーボタンアイテム
        setBarButtonItem()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setInfoViews()
        
        let gearpowerPoints = gearpowerView.gearpowerPoint()
        mainWeaponInfoView.increasedLabelHighlight(gearpower: gearpowerPoints)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    

    //--------------------IBアウトレットなど--------------------
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weaponSetImageView: WeaponSetImageView!
    @IBOutlet weak var gearpowerView: GearpowerFrameView!
    @IBOutlet weak var mainWeaponInfoView: MainWeaponInfoView!
    @IBOutlet weak var subWeaponInfoView: SubWeaponInfoView!
    @IBOutlet weak var specialWeaponInfoView: SpecialWeaponInfoView!
    
    var weapon:Weapon?
    var gearpowerNames:[[String]]?
    
    var gearset:Gearset?
    
    var fromTopViewController = false
    var fromSetGearpowerViewController = false
    
    var infoViewsAppeared = false
    
    
    //--------------------メソッド--------------------
    
    
    func setInfoViews() {
        
        let infoViewInset:CGFloat = 24
        let infoViewWidth = view.frame.size.width - infoViewInset * 2
        
        //メイン詳細ビュー
        mainWeaponInfoView.set(weapon: weapon!)
        let mainWeaponInfoY = gearpowerView.frame.origin.y + gearpowerView.frame.size.height + 32
        mainWeaponInfoView.frame = CGRect(x: infoViewInset, y: mainWeaponInfoY,
                                          width: infoViewWidth,
                                          height: mainWeaponInfoView.frame.size.height)
        
        subWeaponInfoView.set(weapon: weapon!)
        let subWeaponInfoY = mainWeaponInfoView.frame.origin.y + mainWeaponInfoView.frame.size.height + infoViewInset
        subWeaponInfoView.frame = CGRect(x: infoViewInset, y: subWeaponInfoY,
                                         width: infoViewWidth,
                                         height: subWeaponInfoView.frame.size.height)
        
        specialWeaponInfoView.set(weapon: weapon!)
        let specialWeaponInfoY = subWeaponInfoView.frame.origin.y + subWeaponInfoView.frame.size.height + infoViewInset
        specialWeaponInfoView.frame = CGRect(x: infoViewInset, y: specialWeaponInfoY,
                                             width: infoViewWidth,
                                             height: specialWeaponInfoView.frame.size.height)
        
        let contentSize = specialWeaponInfoView.frame.origin.y + subWeaponInfoView.frame.size.height + infoViewInset
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: contentSize)
        
    }
    
    func setBarButtonItem() {
        
        if fromTopViewController {
            
            //変更ボタン
            let barButtonItem = UIBarButtonItem(title: "ギア変更", style: .done, target: self,
                                                action: #selector(editBarButtonTapped(_:)))
            self.navigationItem.rightBarButtonItems = [barButtonItem]
            
        } else if fromSetGearpowerViewController {
            
            //保存ボタン
            let barButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self,
                                                action: #selector(saveBarButtonTapped(_:)))
            self.navigationItem.rightBarButtonItems = [barButtonItem]
            
        }
        
    }
    
    
    //--------------------画面遷移--------------------
    
    
    @objc func editBarButtonTapped(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "changeGearpower", sender: self)
        
    }
    
    //保存ボタン
    @objc func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        
        let gearSet = Gearset(weapon: weapon!)
        gearSet.gearpowerNames = gearpowerNames!
        gearSet.id = Static.gearsets.count
        
        Static.gearsets.append(gearSet)
        navigationController?.popToRootViewController(animated: true)
    
    }
    
    //遷移先に値渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeGearpower" {
            
            //登録済みギアの変更
            let next = segue.destination as! SetGearpowerViewController
            next.weapon = weapon
            next.gearpowerNames = gearpowerView.gearpowerNames
            next.fromGearsetDetailViewController = true
            
            //変更後のギアパワーを受け取って、ビュー更新
            next.closure = {(changedNames : [[String]]) -> Void in
                self.gearpowerView.gearpowerNames = changedNames
                self.gearpowerView.reloadIcon()
                
                self.gearset!.gearpowerNames = changedNames
                Static.gearsets[self.gearset!.id!] = self.gearset!
            }
            
        }
        
    }
    
    
}
