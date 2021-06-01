//
//  FormView.swift
//  LifeHourglass
//
//  Created by 柴英嗣 on 2021/04/25.
//

import Foundation
import UIKit
import Eureka
import Cartography
import SCLAlertView

class FormView : FormViewController {
    
    var sex : String = ""
    var Birth : Date?
    var backimage : String = ""
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        form
        +++ Section("あなたの生年月日を選択")
            <<< DateRow("生年月日"){
                $0.title = "生年月日"
                $0.value = self.Birth ?? Date(timeIntervalSinceReferenceDate: 0)
                self.Birth = $0.value
            }.onChange({ [unowned self] row in
                self.Birth = row.value ?? nil
            })
        +++ Section("なりたい歴史上の人物を選択")
            <<< PushRow<String>(){
                $0.title = "人物名"
                $0.options = ["織田信長","坂本龍馬","豊臣秀吉","卑弥呼","徳川家康","西郷隆盛","福沢諭吉","平清盛","菅原道真","源頼朝","徳川慶喜","足利尊氏","足利義満","吉田松陰","清少納言","近藤勇","土方歳三","宮本武蔵","勝海舟","大久保利通","岩崎弥太郎","山内容堂","徳川家光","木戸孝允","正岡子規","板垣退助","高杉晋作","伊能忠敬","徳川綱吉","武市半平太","後藤象二郎","秋山真之"]
                $0.value = self.sex
                $0.selectorTitle = "人物名"
                self.sex = $0.value ?? ""
            }.onPresent{ from, to in
                to.dismissOnSelection = true
                to.dismissOnChange = false
            }.onChange({ [unowned self] row in
                self.sex = row.value ?? ""
            })
        +++ Section("アプリの背景画像を選択")
            <<< PushRow<String>(){
                $0.title = "スタイル"
                $0.options = ["富士山の浮世絵","日本庭園の砂","日本庭園の橋","城1","城2","昔の張り紙","京都の竹林","金閣寺","青空と寺"]
                $0.value = self.backimage
                $0.selectorTitle = "画像"
                self.backimage = $0.value ?? "富士山の浮世絵"
            }.onPresent{ from, to in
                to.dismissOnSelection = true
                to.dismissOnChange = false
            }.onChange({ [unowned self] row in
                self.backimage = row.value ?? "富士山の浮世絵"
            })
        +++ Section("選択した歴史上の人物の享年から残りの人生時間を算出しています")
            <<< ButtonRow("Button1") {row in
                    row.title = "登録"
                    row.onCellSelection{[unowned self] ButtonCellOf, row in
                        
                        if self.Birth == nil || self.sex == "" || self.sex == nil || self.backimage == "" || self.backimage == nil {
                            let alertView = SCLAlertView()
                            alertView.showInfo("", subTitle: "正しい情報を設定してください", closeButtonTitle: "OK")
                        }
                        else{
                        
                            let userDefaults = UserDefaults.standard
                            let BirthArray = self.Birth
                            let Sex = self.sex
                            // 配列の保存
                            userDefaults.set(BirthArray, forKey: "BirthArray")
                            userDefaults.set(Sex, forKey: "sex")
                            userDefaults.set(self.backimage, forKey: "style")

                            // userDefaultsに保存された値の取得
                            let birtharray = userDefaults.object(forKey: "BirthArray")
                            let sex = userDefaults.string(forKey: "sex")
                            print(load(key: "BirthArray"))
                            print(sex)
                            print(userDefaults.string(forKey: "style"))
                            
                            let appearance = SCLAlertView.SCLAppearance(
                                showCloseButton: false
                            )
                            let alertView = SCLAlertView(appearance: appearance)
                            alertView.addButton("OK") {
                                print("OK")
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                NotificationCenter.default.post(name: Notification.Name("onChangeItem"), object: nil)
                                    self.dismiss(animated: true, completion: nil)
                                }
                            }
                            alertView.showSuccess("", subTitle: "設定を登録しました")
                        }
                        
                    }
            }
    }
    private func load(key: String) -> Date? {
        let value = UserDefaults.standard.object(forKey: key)
        guard let date = value as? Date else {
            return nil
        }
        return date
    }
}
extension FormView {
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
    }
}
