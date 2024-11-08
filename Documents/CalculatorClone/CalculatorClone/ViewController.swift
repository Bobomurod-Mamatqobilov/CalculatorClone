//
//  ViewController.swift
//  CalculatorClone
//
//  Created by MacBook Pro on 08/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    let hd = UIScreen.main.bounds.height
    let wd = UIScreen.main.bounds.width
    lazy var mg = wd/16
    
    let resultLabel = UILabel()
    
    let calcArr = [
        Calc(titleColor: .black, backColor: AppColor.gray, textTitle: "AC", buttonTag: 19),
        Calc(titleColor: .black, backColor: AppColor.gray, textTitle: "+/-", buttonTag: 18),
        Calc(titleColor: .black, backColor: AppColor.gray, textTitle: "％", buttonTag: 17),
        Calc(titleColor: .white, backColor: AppColor.yellow, textTitle: "÷", buttonTag: 16),
        Calc(titleColor: .white, backColor: AppColor.darkGray, textTitle: "7", buttonTag: 7),
        Calc(titleColor: .white, backColor: AppColor.darkGray, textTitle: "8", buttonTag: 8),
        Calc(titleColor: .white, backColor: AppColor.darkGray, textTitle: "9", buttonTag: 9),
        Calc(titleColor: .white, backColor: AppColor.yellow, textTitle: "x", buttonTag: 15),
        Calc(titleColor: .white, backColor: AppColor.darkGray, textTitle: "4", buttonTag: 4),
        Calc(titleColor: .white, backColor: AppColor.darkGray, textTitle: "5", buttonTag: 5),
        Calc(titleColor: .white, backColor: AppColor.darkGray, textTitle: "6", buttonTag: 6),
        Calc(titleColor: .white, backColor: AppColor.yellow, textTitle: "-", buttonTag: 14),
        Calc(titleColor: .white, backColor: AppColor.darkGray, textTitle: "1", buttonTag: 1),
        Calc(titleColor: .white, backColor: AppColor.darkGray, textTitle: "2", buttonTag: 2),
        Calc(titleColor: .white, backColor: AppColor.darkGray, textTitle: "3", buttonTag: 3),
        Calc(titleColor: .white, backColor: AppColor.yellow, textTitle: "+", buttonTag: 13),
        Calc(titleColor: .white, backColor: AppColor.darkGray, textTitle: "0", buttonTag: 10),
        Calc(titleColor: .white, backColor: AppColor.darkGray, textTitle: ".", buttonTag: 11),
        Calc(titleColor: .white, backColor: AppColor.yellow, textTitle: "=", buttonTag: 12),
    ]
    
    
    var curVal: Float = 0
    var oldVal: Float = 0
    var curOper: Int = 0
    var isOper = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        resultLabel.frame = CGRect(x: 3, y: 250, width: wd-9, height: 3*mg)
        resultLabel.backgroundColor = .clear
        resultLabel.textColor = .white
        resultLabel.text = "0"
        resultLabel.font = .systemFont(ofSize: 95, weight: .semibold)
        resultLabel.numberOfLines = 1
        resultLabel.textAlignment = .right
        view.addSubview(resultLabel)
        
        var k = 0
        let h = (wd - 5*mg)/4
        
        for j in 0...4 {
            for i in 0...3 {
                if i==1 && j == 4 { continue }
                let btn = UIButton()
                let wb = (i==0 && j==4) ? mg+2*h : h
                btn.frame = CGRect(x: mg+CGFloat(i)*(mg+h),
                                   y: 280+3*mg+CGFloat(j)*(mg+h),
                                   width: wb, height: h)
                btn.backgroundColor = calcArr[k].backColor
                btn.setTitle(calcArr[k].textTitle, for: .normal)
                btn.setTitleColor(calcArr[k].titleColor, for: .normal)
                btn.tag = calcArr[k].buttonTag
                btn.layer.cornerRadius = h/2
                btn.titleLabel?.font = .systemFont(ofSize: 36)
                btn.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
                view.addSubview(btn)
                k += 1
            }
        }
    }
    
    func counttext(){
        if resultLabel.text?.count ?? 0 < 7 {
            resultLabel.font = .systemFont(ofSize: 95)
        }
        if resultLabel.text?.count == 7 {
            resultLabel.font = .systemFont(ofSize: 80)
        }
        if resultLabel.text?.count == 8 {
            resultLabel.font = .systemFont(ofSize: 70)
        }
        if resultLabel.text?.count == 9 {
            resultLabel.font = .systemFont(ofSize: 60)
        }
        if resultLabel.text?.count ?? 0 > 9 {
            resultLabel.text?.removeLast()
        }
        if resultLabel.text == "1" {
            resultLabel.font = .systemFont(ofSize: 95)
        }
    }
    
    @objc func btnClicked(_ sender: UIButton){
        var tag = sender.tag
        if tag >= 1 && tag <= 10 {
            tag = tag == 10 ? 0 : tag
            if isOper {
                oldVal = curVal
                resultLabel.text = "0"
                isOper = false
            }
            var text = resultLabel.text ?? ""
            text += "\(tag)"
            resultLabel.text = clearZero(text)
            counttext()
            curVal = Float(resultLabel.text ?? "-88") ?? 0
        } else if tag >= 13, tag <= 16 {
            curOper = tag
            isOper = true
        } else if tag == 12 {
            if curOper != 0 {
                curVal = doOper(curOper, oldVal, curVal)
                if String(curVal).count > 1{
                    resultLabel.text = clearZero("\(curVal)")
                }else{
                    resultLabel.text = "\(curVal)"
                }
            }
        } else if tag == 19 {
            curVal = 0
            oldVal = 0
            curOper = 0
            isOper = false
            resultLabel.text = "0"
            counttext()
        }else if tag == 18{
            curVal = -1*curVal
            resultLabel.text = clearZero("\(curVal)")
        }else if tag == 17{
            curVal = curVal/100
            resultLabel.text = clearZero("\(curVal)")
        }
        
        print("BtnTag: \(sender.tag) || CurVal: \(curVal)  ||  CurOper: \(curOper)")
    }
    
    func doOper(_ cO: Int, _ oV: Float, _ cV: Float) -> Float {
        switch cO {
        case 13: return oV+cV
        case 14: return oV-cV
        case 15: return oV*cV
        default: return oV/cV
        }
    }
    func clearZero(_ str: String) -> String {
        var myStr = str
        
        while myStr.count > 1 && myStr.first == "0" && myStr[myStr.index(after: myStr.startIndex)] != "." {
            myStr.removeFirst()
        }

        if myStr.contains(".") {
            while myStr.last == "0" {
                myStr.removeLast()
            }
            if myStr.last == "." {
                myStr.removeLast()
            }
        }
        
        return myStr
    }



}

//  Home Work
// 1. +/- ni ishlatish
// 2. % ni ishlatish
// 3. 4 ta amal va = ni ishlatish(bir necha marta) (harakat qib ko'ringlar)
// Labelda font o'lchami o'zgarishi.



class Calc{
    var titleColor: UIColor?
    var backColor: UIColor?
    var textTitle: String?
    var buttonTag: Int
    
    init(titleColor: UIColor?,backColor: UIColor?,textTitle: String?,buttonTag: Int){
        self.titleColor = titleColor
        self.backColor = backColor
        self.textTitle = textTitle
        self.buttonTag = buttonTag
    }
}

class AppColor{
    static let gray = UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1)
    static let yellow = UIColor(red: 242/255, green: 164/255, blue: 60/255, alpha: 1)
    static let darkGray = UIColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 1)
}

