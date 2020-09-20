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
            view.shadow()
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
        if fromSetGearpowerViewController && firstAppear {
            weaponSetImageAnimate()
            firstAppear = false
        }
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
    
    //遷移アニメ用フレーム
    var cardFrame:CGRect?
    var imageFrame:CGRect?
    var gearpowerFrame:CGRect?
    var keyboardFrame:CGRect?
    var keyboardCopyView = UIImageView()
    
    //遷移元
    var fromTopViewController = false
    var fromSetGearpowerViewController = false
    var firstAppear = true
    
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
        mainDamageCulcView.size()
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
    
    
    //ギアパワーセッテビューからアニメ
    func weaponSetImageAnimate() {
        
        let weaponSetImage = WeaponSetImageView()
        let blankCard = UIView()
        let gearpowerImage = GearpowerFrameView()
        
        //ギアセット非表示
        self.gearsetCardView.isHidden = true
        
        //アニメ用カード(背景)ビュー設定
        blankCard.frame = cardFrame!
        blankCard.backgroundColor = UIColor.white
        blankCard.shadow()
        blankCard.layer.cornerRadius = cornerRadius
        
        //ブキ画像設定
        weaponSetImage.frame = imageFrame!
        weaponSetImage.weapon = weapon
        //画像化
        let uiImageWeaponView = UIImageView(image: weaponSetImage.makeImage())
        uiImageWeaponView.frame = imageFrame!
        
        //ギアパワー
        gearpowerImage.frame = gearpowerFrame!
        gearpowerImage.gearpowerNames = gearpowerNames!
        //画像化
        let uiImageGearpowerView = UIImageView(image: gearpowerImage.makeImage())
        uiImageGearpowerView.frame = gearpowerFrame!
        
        //キーボード
        view.addSubview(keyboardCopyView)
        
        //ビューに追加
        blankCard.addSubview(uiImageGearpowerView)
        blankCard.addSubview(uiImageWeaponView)
        view.addSubview(blankCard)
        
        let cardViewOrigin = CGPoint(x: gearsetCardView.frame.origin.x,
                                     y: gearsetCardView.frame.origin.y)
        let cardViewSize = gearsetCardView.frame.size
        
        //ギアセットアニメ
        UIView.animate(withDuration: 0.4, delay: 0,
                       options: .curveEaseOut, animations: {() -> Void in
                        
                        blankCard.frame = CGRect(origin: cardViewOrigin, size: cardViewSize)
                        uiImageWeaponView.frame = self.gearsetCardView.weaponSetImageView.frame
                        uiImageGearpowerView.frame = self.gearsetCardView.gearpowerFrameView.frame
                        
					   }, completion: { _ in
                        
						self.cardFrame = blankCard.frame
						
                        self.gearsetCardView.isHidden = false
                        blankCard.removeFromSuperview()
                        
                       })
        
        //キーボードアニメ
        UIView.animate(withDuration: 0.3, delay: 0,
                       options: .curveEaseIn, animations: {() -> Void in
                        
                        self.keyboardCopyView.frame.origin.y = self.view.frame.size.height
                        
                       }, completion: { _ in
                        
                        self.keyboardCopyView.removeFromSuperview()
                        
                       })
        
        infoViewSlideIn()
    }
    
    func infoViewSlideIn() {
        
        let views = [mainWeaponInfoView!, subWeaponInfoView!, specialWeaponInfoView!, mainDamageCulcView!]
        let distance = view.frame.size.height - (gearsetCardView.frame.height + gearsetCardView.frame.origin.y)
        
        for n in 0...3 {
            
            views[n].frame.origin.y += distance
            
            let delay = 0.3/3 * Double(n)
            
            UIView.animate(withDuration: 0.4, delay: delay,
                           options: .curveEaseOut, animations: {() -> Void in
                            views[n].frame.origin.y -= distance
                           })
            
        }
        
    }
    
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
        
        let newGearset = Gearset(weapon: weapon!)
        newGearset.gearpowerNames = gearpowerNames!
        newGearset.id = Static.gearsets.count
        
        Static.gearsets.insert(newGearset, at: 0)
        
        //トップビューに値渡し
        let rootVc = self.navigationController?.viewControllers[0] as! TopViewController
        rootVc.gearsetFrame = gearsetCardView.frame
        rootVc.fromGearSetDetailView = true
		rootVc.newCellAdded = true
		
		//トップビュー遷移前に画像作成
		rootVc.imageViewFowAnimation = UIImageView()
		rootVc.imageViewFowAnimation.layer.cornerRadius = cornerRadius
		rootVc.imageViewFowAnimation.backgroundColor = UIColor.red
		rootVc.imageViewFowAnimation.frame = cardFrame!
		rootVc.imageViewFowAnimation.shadow()
		rootVc.imageViewFowAnimation.image = gearsetCardView.makeImage()
		rootVc.viewsFromAnotherVC = imageViews()
        
        //アニメーション無効化
		let duration = sqrt(Double(scrollView.contentOffset.y / 10000))
		print(duration)
		UIView.animate(withDuration: duration, delay: 0,
					   options: .curveEaseInOut, animations: {() -> Void in
						
						self.scrollView.contentOffset.y = 0
						
					   }, completion: { _ in
					
						UIView.setAnimationsEnabled(false)
						self.navigationController?.popToRootViewController(animated: true)
						
						//表示
						rootVc.view.addSubview(rootVc.imageViewFowAnimation)
						rootVc.tableView.isHidden = true
						for eachView in rootVc.viewsFromAnotherVC {
							eachView.shadow()
							rootVc.view.addSubview(eachView)
						}
						
					})
    }
	
	func imageViews() -> [UIImageView] {
		
		var output:[UIImageView] = []
		
		let views = [mainWeaponInfoView!, subWeaponInfoView!, specialWeaponInfoView!, mainDamageCulcView!]
		
		for view in views {
			
			let imageView = UIImageView(image: view.withoutShadow().makeImage())
			imageView.layer.cornerRadius = cornerRadius
			imageView.frame = view.frame
			imageView.clipsToBounds = false
			output.append(imageView)
			
		}
		
		return output
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
