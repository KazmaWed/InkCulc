import UIKit
class TopViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//----------ナビゲーションバー----------
		
		title = "ギアセット"
		
		navigationController?.navigationBar.barTintColor = InkColor.darkGray
		self.navigationController?.navigationBar.isTranslucent = false
		self.navigationController?.navigationBar.tintColor = .white
		
		//----------データ取得----------
		
		getInkApi()
		
		//----------テーブルビュー----------
		
//		tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil),forCellReuseIdentifier: "cell")
		tableView.delaysContentTouches = false
		
		//----------その他----------
		
		view.addSubview(imageViewFowAnimation)
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
	
		//テーブルビュー更新
		self.tableView.reloadData()
		
		if Static.gearsets.count != 0 {
			let indexPath = IndexPath(row: 0, section: 0)
			tableView.scrollToRow(at: indexPath, at: .top, animated: false)
		}
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		
		//アニメ有効化
		UIView.setAnimationsEnabled(true)
		
		//追加ボタン生成
		if viewFirstAppear { setNavigationButton() }
		//スライドイン
		naviButtonSlide(out: false)
		
		//セル追加アニメ
		if fromGearSetDetailView { tableViewAppearWithNewCell() }
		
	}
	
	
	//--------------------IBアウトレット・インスタンス--------------------
	
	
	@IBOutlet weak var tableView: UITableView!
	
	//次のビューに渡す値
	var selectedGearSet:Gearset?
	
	//起動時確認
	var viewFirstAppear = true
	//遷移元ビュー
	var fromGearSetDetailView = false
	
	//アニメ用フレーム
	var gearsetFrame:CGRect?
	var imageViewFowAnimation = UIImageView()
	
	
	//--------------------メソッド--------------------
	
	
	//Api通信
	func getInkApi() {
		
		//画像ダウンロード済みの場合
		if UserDefaults.standard.object(forKey: "weaponImages") != nil {
			
			//ロードして
			let data = UserDefaults.standard.object(forKey: "weaponInfo")  as! Data
			inkApi.weaponInfo = try! JSONDecoder().decode(WeaponInfo.self, from: data)
			inkApi.weaponImageData = UserDefaults.standard.array(forKey: "weaponImages") as! [Data]
			//変換
			inkApi.decodeWeaponInfo()
			inkApi.dataToUIImage()
			print("Image and Data loaded")
			
			//ブキ情報再ダウンロード
			inkApi.getWeapons(closure: { () -> Void in
				//保存
				let data = try! JSONEncoder().encode(inkApi.weaponInfo)
				UserDefaults.standard.set(data, forKey: "weaponInfo")
				inkApi.decodeWeaponInfo()
				print("Data redownloaded...")
			})
			
		} else {
			
			//API通信
			inkApi.getWeapons(closure: { () -> Void in
				
				//ブキ情報保存
				let data = try! JSONEncoder().encode(inkApi.weaponInfo)
				inkApi.decodeWeaponInfo()
				UserDefaults.standard.set(data, forKey: "weaponInfo")
				print("Data downloaded...")
				
				//画像取得
				inkApi.getWeaponImages(closure: { () -> Void in
					let data = inkApi.weaponImageData
					UserDefaults.standard.set(data, forKey: "weaponImages")
					inkApi.dataToUIImage()
					print("Image downloaded")
				})
				
			})
			
		}
		
	}
	
	//右下追加ボタン
	func setNavigationButton() {
		
		let viewWidth = view.frame.size.width
		let screenHeight = UIApplication.shared.keyWindow!.frame.size.height
		let safeAreaBottomInset = view.safeAreaInsets.bottom
		let inset:CGFloat = 16
		let buttonSize = viewWidth * 14/100
		let buttonX = viewWidth + inset
		let buttonY = screenHeight - safeAreaBottomInset - buttonSize
		
		navigationButton.frame.origin = CGPoint(x: buttonX, y: buttonY)
		navigationButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
		navigationButton.layer.cornerRadius = buttonSize / 2
		navigationButton.backgroundColor = navigationController?.navigationBar.barTintColor
		navigationButton.backgroundColor = InkColor.red
		navigationButton.setTitleColor(UIColor.white, for: .normal)
		
		navigationButton.layer.shadowColor = shadowColor
		navigationButton.layer.shadowOffset = shadowOffset
		navigationButton.layer.shadowRadius = shadowRadius
		navigationButton.layer.shadowOpacity = shadowOpacity
		
		navigationButton.setTitle("+", for: .normal)
		navigationButton.titleLabel?.font = InkFont.Navi
		navigationButton.addTarget(self, action: #selector(addBarButtonTapped(_:)), for: .touchUpInside)
		
		UIApplication.shared.keyWindow!.addSubview(navigationButton)
		viewFirstAppear = false
		
	}
	
	//スライドイン・アウト
	func naviButtonSlide(out:Bool = true) {
		
		let viewWidth = view.frame.size.width
		let inset:CGFloat = 18
		
		if out {
			UIView.animate(withDuration: 0.3, delay: 0,
						   options: .curveEaseIn, animations: { () -> Void in
							navigationButton.frame.origin.x = viewWidth + inset
						   })
		} else {
			let viewWidth = view.frame.size.width
			let viewHeight =  view.frame.size.height
			let inset:CGFloat = 18
			let buttonSize = navigationButton.frame.size.height
			let buttonX = viewWidth - buttonSize - inset
			
			UIView.animate(withDuration: 0.3, delay: 0,
						   options: .curveEaseOut, animations: { () -> Void in
							navigationButton.frame.origin.x = buttonX
						   })
		}
		
	}
	
	//右上追加ボタン
	@objc func addBarButtonTapped(_ sender: UIBarButtonItem) {
		tableView.reloadData()
		self.performSegue(withIdentifier: "addItem", sender: self)
		naviButtonSlide(out: true)
	}
	
	
	//--------------------画面遷移--------------------
	
	
	//新規セルアニメ
	func tableViewAppearWithNewCell() {
		
		//内枠
		let clipingFrame = UIView()
		clipingFrame.layer.cornerRadius = cornerRadius
		clipingFrame.frame.size = imageViewFowAnimation.frame.size
		clipingFrame.clipsToBounds = true
		
		let indexPath = IndexPath(row: 0, section: 0)
		let originalCell = tableView.cellForRow(at: indexPath)
		let originalCellContent = originalCell!.contentView
		let viewInContent = originalCellContent
		let cardInContent = originalCellContent.viewWithTag(2)!
		
		let viewInContentImageView = UIImageView(image: viewInContent.withoutShadow().makeImage())
		let sizeRatio:CGFloat = viewInContent.frame.size.width / gearsetFrame!.size.width
		viewInContentImageView.frame.size = CGSize(width: viewInContent.frame.size.width / sizeRatio,
												   height: viewInContent.frame.size.height / sizeRatio)
		viewInContentImageView.contentMode = .scaleToFill
		
		let gearsetCardView = GearsetCardView()
		gearsetCardView.frame.size = gearsetFrame!.size
		gearsetCardView.gearset = Static.gearsets[0]
		gearsetCardView.setSize()
		gearsetCardView.shadow(off: true)
		gearsetCardView.layer.cornerRadius = 0
		let gearsetCardImageView = UIImageView(image: gearsetCardView.makeImage())
		gearsetCardImageView.frame = gearsetCardView.frame
		
		clipingFrame.addSubview(viewInContentImageView)
		clipingFrame.addSubview(gearsetCardImageView)
		imageViewFowAnimation.addSubview(clipingFrame)
		view.addSubview(imageViewFowAnimation)
		
		originalCell!.isHidden = true
		tableView.isHidden = false
		
		UIView.animate(withDuration: 0.3, delay: 0,
					   options: .curveEaseInOut, animations: {

						self.imageViewFowAnimation.frame = viewInContent.frame
						clipingFrame.frame.size = viewInContent.frame.size
						viewInContentImageView.frame.size = viewInContent.frame.size
						gearsetCardImageView.frame = cardInContent.frame

					   }, completion: { _ in

						originalCell!.isHidden = false
						self.imageViewFowAnimation.removeFromSuperview()

					})
		
	}
	
	//遷移先に値渡し
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "addItem" {
			
			let next = segue.destination as! AddItemViewController
			
		} else if segue.identifier == "editGearset" {
			
			let next = segue.destination as! GearsetDetailViewController
			next.gearset = selectedGearSet!
			next.fromTopViewController = true
		}
		
	}
	
	
}


//--------------------テーブルビュー・セル--------------------


extension TopViewController: UITableViewDelegate, UITableViewDataSource {
	
	//セル数
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		Static.gearsets.count
	}
	
	//セル設定
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
//		let cell: CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell",
//																	  for: indexPath) as! CustomTableViewCell
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		let weaponLabel = cell.viewWithTag(1) as! UILabel
		let gearsetCardView = cell.viewWithTag(2) as! GearsetCardView
		
		let cellSelectedBgView = UIView()
		cellSelectedBgView.backgroundColor = UIColor.clear
		cell.selectedBackgroundView = cellSelectedBgView
		
		let gearset = Static.gearsets[indexPath.row]
		weaponLabel.text = "ギアセット No.\(Int(indexPath.row) + 1)"
		gearsetCardView.gearset = gearset
		
		return cell
		
	}
	
	//セルタップ
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if tableView.isEditing {
			tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
		} else {
			selectedGearSet = Static.gearsets[indexPath.row]
			self.performSegue(withIdentifier: "editGearset", sender: self)
		}
		
	}
	
	//ハイライト
	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		if !isEditing {
			UIView.animate(withDuration: 0.3) {
				tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
			}
		}
	}
	
	//アンハイライト
	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		UIView.animate(withDuration: 0.3) {
			tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 1, y: 1)
		}
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		Static.gearsets.remove(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: .automatic)
	}
	
	//選択解除時のデリゲートメソッド
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		UIView.animate(withDuration: 0.3) {
			tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 1, y: 1)
		}
		print(indexPath.row)
	}
	
	//セルの高さ
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return (view.frame.size.width - 24) * 2 / 3 + 12
	}
	
	
}
