import UIKit

class GearsetDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //情報表示用ブキ・ギアパワー取得
        weapon = gearset!.weapon
        gearpowerNames = gearset!.gearpowerNames
        
        //ブキ・ギアパワー画像
        gearsetCardView.gearset = gearset
        gearsetCardView.withShadow = true
        
        //バーボタンアイテム
        setBarButtonItem()
        
        //影
        let views = [mainWeaponInfoView!, subWeaponInfoView!, specialWeaponInfoView!, mainDamageCulcView!]
        for view in views {
            view.clipsToBounds = false
            view.layer.shadowOpacity = shadowOpacity
            view.layer.shadowRadius = shadowRadius
            view.layer.shadowOffset = shadowOffset
            view.layer.shadowColor = shadowColor
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //ブキ基本情報ビュー
        setInfoViews()
        
        //ダメージテーブル
        setDamageTable()
        
        //スクロールビューコンテンツサイズ
        let contentSize = mainDamageCulcView.frame.origin.y + mainDamageCulcView.frame.size.height
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: contentSize)
        
        let gearpowerPoints = gearsetCardView.gearpowerFrameView.gearpowerPoint()
        mainWeaponInfoView.increasedLabelHighlight(gearpower: gearpowerPoints)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    

    //--------------------IBアウトレットなど--------------------
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var gearsetCardView: GearsetCardView!
    @IBOutlet weak var mainWeaponInfoView: MainWeaponInfoView!
    @IBOutlet weak var subWeaponInfoView: SubWeaponInfoView!
    @IBOutlet weak var specialWeaponInfoView: SpecialWeaponInfoView!
    @IBOutlet weak var mainDamageCulcView: MainDamageCulcView!
    
    var weapon:Weapon?
    var gearpowerNames:[[String]]?
    
    var gearset:Gearset?
    
    var fromTopViewController = false
    var fromSetGearpowerViewController = false
    
    var tappedButtonTag = 0
    
    var infoViewsAppeared = false
    
    
    //--------------------メソッド--------------------
    
    
    //メイン・サブ・スペシャルの基本情報ビュー
    func setInfoViews() {
        
        let infoViewInset:CGFloat = gearsetCardView.frame.origin.x
        let infoViewWidth = view.frame.size.width - infoViewInset * 2
        
        //メイン詳細ビュー
        mainWeaponInfoView.set(weapon: weapon!)
        let mainWeaponInfoY = gearsetCardView.frame.origin.y + gearsetCardView.frame.size.height + infoViewInset
        mainWeaponInfoView.frame = CGRect(x: infoViewInset, y: mainWeaponInfoY,
                                          width: infoViewWidth,
                                          height: mainWeaponInfoView.frame.size.height)
        
        if mainWeaponInfoView.buttons.count != 0 {
            mainWeaponInfoView.buttons[0].addTarget(self, action: #selector(showGearpowerEffect(sender:)),
                                                    for: .touchUpInside)
        }
        
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
        
    }
    
    //ダメージテーブル
    func setDamageTable() {
        
        let infoViewInset:CGFloat = 24
        let infoViewWidth = view.frame.size.width - infoViewInset * 2
        
        let gearpowerPoint = gearsetCardView.gearpowerFrameView.gearpowerPoint()
        mainDamageCulcView.culc(weapon: weapon!, gearpowerPoint: gearpowerPoint)
        mainDamageCulcView.size(width: infoViewWidth)
        mainDamageCulcView.frame.origin.x = infoViewInset
        mainDamageCulcView.frame.origin.y = specialWeaponInfoView.frame.origin.y + specialWeaponInfoView.frame.size.height + infoViewInset
        
        if mainDamageCulcView.buttons.count != 0 {
            for button in mainDamageCulcView.buttons {
                button.addTarget(self, action: #selector(showDamageTable(sender:)), for: .touchUpInside)
            }
        }
        
    }
    
    func setBarButtonItem() {
        
        if fromTopViewController {
            
            //変更ボタン
            let barButtonItem = UIBarButtonItem(title: "ギア変更", style: .done, target: self,
                                                action: #selector(editBarButtonTapped(sender:)))
            self.navigationItem.rightBarButtonItems = [barButtonItem]
            
        } else if fromSetGearpowerViewController {
            
            //保存ボタン
            let barButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self,
                                                action: #selector(saveBarButtonTapped(sender:)))
            self.navigationItem.rightBarButtonItems = [barButtonItem]
            
        }
        
    }
    
    
    //--------------------画面遷移--------------------
    
    
    @objc func editBarButtonTapped(sender: UIBarButtonItem) {
        performSegue(withIdentifier: "changeGearpower", sender: self)
    }
    
    @objc func showGearpowerEffect(sender:UIButton) {
        performSegue(withIdentifier: "showGearpowerEffect", sender: self)
    }
    
    @objc func showDamageTable(sender:UIButton) {
        tappedButtonTag = sender.tag
        performSegue(withIdentifier: "showDamageTable", sender: self)
    }
    
    //保存ボタン
    @objc func saveBarButtonTapped(sender: UIBarButtonItem) {
        
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
            next.gearpowerNames = gearsetCardView.gearpowerFrameView.gearpowerNames
            next.fromGearsetDetailViewController = true
            
            //変更後のギアパワーを受け取って、ビュー更新
            next.closure = {(changedNames : [[String]]) -> Void in
                self.gearsetCardView.gearpowerFrameView.gearpowerNames = changedNames
                
                self.gearset!.gearpowerNames = changedNames
                Static.gearsets[self.gearset!.id!] = self.gearset!
            }
            
        } else if segue.identifier == "showGearpowerEffect" {
            
            let next = segue.destination as! GearpowerEffectViewController
            next.weapon = weapon
            
        } else if segue.identifier == "showDamageTable" {
            
            let next = segue.destination as! DamageTableViewController
            let threshold = mainDamageCulcView.thresholds[tappedButtonTag]
            next.threshold = threshold
            
        }
        
    }
    
    
}
