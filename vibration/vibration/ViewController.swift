//
//  ViewController.swift
//  vibration
//
//  Created by 内堀保貴 on 2022/12/15.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet weak var onetime: UIButton!
    
    @IBOutlet weak var vibepatternSelector: UIPickerView!
    
    let dataList = [  "成功時のバイブ"
                     ,"失敗時のバイブ"
                     ,"警告時のバイブ"
                     ,"軽いバイブ"
                     ,"普通のバイブ"
                     ,"強いバイブ"
                     ,"フィードバック時のバイブ"
                    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        vibepatternSelector.delegate = self
        vibepatternSelector.dataSource = self
    }

    @IBAction func onetimePressed(_ sender: Any) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、リストの数
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return dataList.count
    }
    
    // UIPickerViewの最初の表示
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return dataList[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
        switch dataList[row] {
        case "成功時のバイブ":
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case "失敗時のバイブ":
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case "警告時のバイブ":
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case "軽いバイブ":
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case "普通のバイブ":
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case "強いバイブ":
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case "フィードバック時のバイブ":
            UISelectionFeedbackGenerator().selectionChanged()
        default:
            break;
        }
    }
    
}

