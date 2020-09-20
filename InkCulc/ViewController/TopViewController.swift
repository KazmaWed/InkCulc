import UIKit
import MBCircularProgressBar


class TopViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//----------ナビゲーションバー----------
		
		title = "ギアセット"
		
		navigationController?.navigationBar.barTintColor = InkColor.darkRed
		self.navigationController?.navigationBar.isTranslucent = false
		self.navigationController?.navigationBar.tintColor = .white
		
		//----------アイコン----------
		
		squidImageView.backgroundColor = InkColor.darkRed
		
		//----------テーブルビュー----------
		
		tableView.isHidden = true
		tableView.delaysContentTouches = false
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 54, right: 0)
		tableView.separatorInset = UIEdgeInsets.zero
		
		//----------その他----------
		
		if newCellAdded { view.addSubview(imageViewFowAnimation) }
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
	
		if !viewFirstAppear {
			//テーブルビュー更新
			self.tableView.reloadData()
			
		}
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		
		//アニメ有効化
		UIView.setAnimationsEnabled(true)
		
		//追加ボタン生成
		if viewFirstAppear {
			getWeaponInfo()
			setNavigationButton()
			viewFirstAppear = false
		} else {
			//スライドイン
			naviButtonSlide(out: false)
		}
		
		//セル追加アニメ
		if newCellAdded { tableViewAppearWithNewCell(); newCellAdded = false }
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		naviButtonSlide(out: true)
	}
	
	
	//--------------------IBアウトレット・インスタンス--------------------
	
	
	@IBOutlet weak var squidImageView: UIImageView!
	@IBOutlet weak var tableView: UITableView!
	
	
	//起動時使用
	let uiView = UIView()
	var timer = Timer()
	var progress:Double = 0
	let label = UILabel()
	let backgroundBlankView = UIView()
	let progressView = MBCircularProgressBarView()
	
	
	//次のビューに渡す値
	var selectedGearSet:Gearset?
	
	//起動時確認
	var viewFirstAppear = true
	//遷移元ビュー
	var fromGearSetDetailView = false
	var newCellAdded = false
	
	//アニメ用ビューフレーム
	var gearsetFrame:CGRect?
	var imageViewFowAnimation = UIImageView()
	var viewsFromAnotherVC:[UIImageView] = []
	
	
	//--------------------メソッド--------------------
	
	
	//起動
	func getWeaponInfo() {
		
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
			
			openingAnime()
			
			//ブキ情報再ダウンロード
			inkApi.getWeapons(closure: { () -> Void in
				//保存
				let newdata = try! JSONEncoder().encode(inkApi.weaponInfo)
				UserDefaults.standard.set(newdata, forKey: "weaponInfo")
				inkApi.decodeWeaponInfo()
				print("Data redownloaded...")
			})
			
		} else {
			
			progressStart()
			
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
	
	func progressStart() {
		
		//プログレス設定
		progressView.maxValue = 130
		progressView.value = 0
		let progressViewSize = view.frame.size.width * 50/100
		let progressViewX = (view.frame.size.width - progressViewSize) / 2
		let progressViewY = (view.frame.size.height - progressViewSize) / 2
		progressView.showValueString = false
		progressView.frame.size = CGSize(width: progressViewSize, height: progressViewSize)
		progressView.frame.origin = CGPoint(x: progressViewX, y: progressViewY)
		progressView.progressRotationAngle = 50
		progressView.progressAngle = 100
		progressView.progressLineWidth = 3
		progressView.progressCapType = 0
		progressView.backgroundColor = UIColor.clear
		progressView.progressColor = UIColor.white
		progressView.progressStrokeColor = UIColor.clear
		progressView.emptyLineColor = UIColor.clear
		progressView.emptyLineStrokeColor = UIColor.clear
		view.addSubview(progressView)
		
		//ラベル設定
		label.text = "イカしたデータ取得中…"
		label.textAlignment = .center
		label.font = InkFont.Banana
		label.textColor = UIColor.white
		label.sizeToFit()
		label.frame.size.width = view.frame.size.width
		label.frame.origin.y = progressView.frame.origin.y - 64
		label.alpha = 0
		view.addSubview(label)
		
		UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .autoreverse, .repeat]) {
			self.label.alpha = 1
		}
		
		//タイマー設定
		timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
									 selector: #selector(self.counter), userInfo: nil, repeats: true)
		
		timer.fire()
		
	}
	
	func openingAnime() {
		
		//データ読み込み
		loadGearsets()
		self.tableView.reloadData()
		tableView.isHidden = false
		print(Static.gearsets.count)
		
		let circleView = UIView()
		circleView.frame = CGRect(x: view.frame.size.width / 2 - 5,
								  y: view.frame.size.height / 2 - 5,
								  width: 10, height: 10)
		circleView.layer.cornerRadius = 5
		circleView.backgroundColor = UIColor.white
		view.addSubview(circleView)
		
		UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: { () -> Void in
			
			circleView.transform = CGAffineTransform(scaleX: self.view.frame.size.height / 5,
													 y: self.view.frame.size.height / 5)
			
		}, completion: { _ in
			
			self.squidImageView.removeFromSuperview()
			UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { () -> Void in
				
				circleView.alpha = 0
				
			}, completion: { _ in
				
				circleView.removeFromSuperview()
				self.naviButtonSlide(out: false)
				
			})
		})
		
	}
	
	//タイマーメソッド
	@objc func counter() {
		progress = Double(inkApi.weaponImageData.count)
		if inkApi.weaponInfo != nil { progress += 1.0 }
		
		UIView.animate(withDuration: 0.1 , delay: 0, options: .curveEaseIn, animations: { () -> Void in
			self.progressView.value = CGFloat(self.progress)
		})
		
		if inkApi.weaponImages.count >= 129 {
			timer.invalidate()
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
				self.label.removeFromSuperview()
				self.progressView.removeFromSuperview()
				self.openingAnime()
			}
		}
	}
	
	//右下追加ボタン
	func setNavigationButton() {
		
		let viewWidth = view.frame.size.width
		let screenHeight = UIApplication.shared.keyWindow!.frame.size.height
		let safeAreaBottomInset = view.safeAreaInsets.bottom
		let inset:CGFloat = 20
		let buttonSize = viewWidth * 14/100
		let buttonX = viewWidth + inset
		let buttonY = screenHeight - safeAreaBottomInset - buttonSize
		
		navigationButton.frame.origin = CGPoint(x: buttonX, y: buttonY)
		navigationButton.frame.size = CGSize(width: buttonSize, height: buttonSize)
		navigationButton.layer.cornerRadius = buttonSize / 2
		navigationButton.backgroundColor = navigationController?.navigationBar.barTintColor
		navigationButton.backgroundColor = InkColor.darkRed
		navigationButton.setTitleColor(UIColor.white, for: .normal)
		
		navigationButton.layer.shadowColor = shadowColor
		navigationButton.layer.shadowOffset = shadowOffset
		navigationButton.layer.shadowRadius = shadowRadius
		navigationButton.layer.shadowOpacity = shadowOpacity
		
		navigationButton.setTitle("+", for: .normal)
		navigationButton.titleLabel?.font = InkFont.Navi
		navigationButton.addTarget(self, action: #selector(addBarButtonTapped(_:)), for: .touchUpInside)
		
		UIApplication.shared.keyWindow!.addSubview(navigationButton)
		
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
			let viewHeight =  view.frame.size.height
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
		self.performSegue(withIdentifier: "addItem", sender: self)
	}
	
	
	//--------------------画面遷移--------------------
	
	
	//新規セルアニメ
	func tableViewAppearWithNewCell() {
		
		//内枠
		let clipingFrame = UIView()
		clipingFrame.backgroundColor = UIColor.red
		clipingFrame.layer.cornerRadius = cornerRadius
		clipingFrame.frame.size = imageViewFowAnimation.frame.size
		clipingFrame.clipsToBounds = true
		
		//セル
		let indexPath = IndexPath(row: 0, section: 0)
		let originalCell = tableView.cellForRow(at: indexPath)!
		let originalCellContent = originalCell.contentView
		
		//セル内コンテンツ全体
		let viewInContent = originalCellContent.viewWithTag(1)!
		//ギア・ブキカードビュー
		let cardInContent = originalCellContent.viewWithTag(3)!
		
		//完成系セルのイメージ
		let viewInContentImageView = UIImageView(image: viewInContent.withoutShadow().makeImage())
		let sizeRatio:CGFloat = viewInContent.frame.size.width / gearsetFrame!.size.width
		viewInContentImageView.frame.size = CGSize(width: viewInContent.frame.size.width / sizeRatio,
												   height: viewInContent.frame.size.height / sizeRatio)
		viewInContentImageView.contentMode = .scaleToFill
		
		//ギアセットビュー
		let gearsetCardView = GearsetCardView()
		gearsetCardView.frame.size = gearsetFrame!.size
		gearsetCardView.gearset = Static.gearsets[0]
		gearsetCardView.gearpowerFrameView.gearpowerNames = Static.gearsets[0].gearpowerNames!
		gearsetCardView.gearpowerFrameView.reloadIcon()
		gearsetCardView.shadow(off: true)
		gearsetCardView.layer.cornerRadius = 0
		//画像化
		let gearsetCardImageView = UIImageView(image: gearsetCardView.makeImage())
		gearsetCardImageView.frame = gearsetCardView.frame
		
		//移動先座標
		let imageX = (originalCell.frame.size.width - viewInContent.frame.size.width) / 2
		let imageY = (originalCell.frame.size.height - viewInContent.frame.size.height) / 2
		
		clipingFrame.addSubview(viewInContentImageView)
		clipingFrame.addSubview(gearsetCardImageView)
		imageViewFowAnimation.addSubview(clipingFrame)
		view.addSubview(imageViewFowAnimation)
		
		originalCell.isHidden = true
		tableView.isHidden = false
		
		UIView.animate(withDuration: 0.4, delay: 0,
					   options: .curveEaseInOut, animations: {

						self.imageViewFowAnimation.frame.size = viewInContent.frame.size
						self.imageViewFowAnimation.frame.origin = CGPoint(x: imageX, y: imageY)
						
						clipingFrame.frame.size = viewInContent.frame.size
						viewInContentImageView.frame = viewInContent.frame
						gearsetCardImageView.frame = cardInContent.frame

					   }, completion: { _ in

						originalCell.isHidden = false
						self.imageViewFowAnimation.removeFromSuperview()

					})
		
		if Static.gearsets.count >= 2 {
			var count:Double = 0
			
			for n in 1...tableView.visibleCells.count - 1 {
				
				let indexPath = IndexPath(row: n, section: 0)
				let cell = tableView.cellForRow(at: indexPath)!
				if cell.frame.origin.y > view.frame.size.height { break }
				
				cell.isHidden = true
		
				let content = cell.contentView.viewWithTag(1)!
				let cellImageView = UIImageView(image: content.makeImage())
				cellImageView.frame.size = content.frame.size
				cellImageView.shadow()
				cellImageView.layer.cornerRadius = cornerRadius

				cellImageView.frame.origin.x = (view.frame.size.width - content.frame.size.width) / 2
				cellImageView.frame.origin.y = view.frame.size.height + shadowRadius
				
				view.addSubview(cellImageView)

				let yTo = cell.frame.origin.y + (cell.frame.size.height - content.frame.size.height) / 2
				let delay = 0.1 * count
				UIView.animate(withDuration: 0.4, delay: delay,
							   options: .curveEaseInOut, animations: {

								cellImageView.frame.origin.y = yTo

							   }, completion: { _ in

								cell.isHidden = false
								cellImageView.removeFromSuperview()

							})
				
				count += 1
				
			}
			
		}
		
		viewsWithdraw()
	}
	
	//ビュー退避
	func viewsWithdraw() {
		guard viewsFromAnotherVC.count > 1 else { return }
		
		for n in 0...viewsFromAnotherVC.count - 1 {
			view.sendSubviewToBack(viewsFromAnotherVC[n])
			let m = viewsFromAnotherVC.count - 1 - n
			let delay = 0.03 * Double(n)
			UIView.animate(withDuration: 0.4, delay: delay,
						   options: .curveEaseIn, animations: { () -> Void in
							
							self.viewsFromAnotherVC[m].frame.origin.y += self.view.frame.size.height + shadowRadius
							
						   }, completion: { _ in
							self.viewsFromAnotherVC[m].removeFromSuperview()
							self.viewsFromAnotherVC.removeLast()
						})
		}
		
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
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.layoutMargins = UIEdgeInsets.zero
		cell.preservesSuperviewLayoutMargins = false
		
		let frameView = cell.contentView.viewWithTag(1)!
		let label = cell.contentView.viewWithTag(2) as! UILabel
		let gearsetImageView = cell.contentView.viewWithTag(3) as! UIImageView
		let viewForShadow = cell.contentView.viewWithTag(4)!
		
		//ハイライト背景色
		let cellSelectedBgView = UIView()
		cellSelectedBgView.backgroundColor = UIColor.clear
		cell.selectedBackgroundView = cellSelectedBgView
		
		//枠
		frameView.layer.cornerRadius = cornerRadius
		frameView.clipsToBounds = true
		
		//影用ビュー
		viewForShadow.backgroundColor = UIColor.white
		viewForShadow.layer.cornerRadius = cornerRadius
		viewForShadow.shadow()
		
		//ラベル
		label.text = "IndexPath \(Int(indexPath.row + 1))"
		let cellNum = Int(indexPath.row)
		let colorNum = cellNum % InkColor.array.count
		let cellColor = InkColor.array[colorNum]
		label.backgroundColor = cellColor
		
		//画
		let gearset = Static.gearsets[indexPath.row]
		let cardForImage = GearsetCardView()
		cardForImage.frame.size = gearsetImageView.frame.size
		cardForImage.gearset = gearset
		cardForImage.gearpowerFrameView.reloadIcon()
		//適用
		gearsetImageView.image = cardForImage.makeImage()
		
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
	}
	
	//セルの高さ
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return (view.frame.size.width - 24) * 2 / 3 + 12
	}
	
	
}
