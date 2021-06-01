//
//  ViewController.swift
//  LifeHourglass
//
//  Created by 柴英嗣 on 2021/04/25.
//

import UIKit
import Eureka
import Cartography
import SCLAlertView

class LaunchViewController : UIViewController{
        
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.white
        let logo:UIImage = UIImage(named:"launchview")!
        let imageView = UIImageView(image:logo)
        imageView.layer.cornerRadius = 18
        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        constrain(imageView, self.view) { i, view in
            i.center == i.superview!.center
            i.width == 200
            i.height == 200
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if let storedData = UserDefaults.standard.object(forKey: "BirthArray") as? Data {
            print("sign")
            self.performSegue(withIdentifier: "sign", sender: nil)

        } else {
            print("nosign")
            let vc = FormView()
            vc.title = "設定"
//            vc.navigationItem.rightBarButtonItem = {
//                let btn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(self.onPressClose(_:)))
//                return btn
//            }()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    @objc func onPressClose(_ sender : Any){
        self.dismiss(animated: true, completion: nil)
    }
}


extension UIColor {
    class func hex ( string : String, alpha : CGFloat) -> UIColor {
        let string_ = string.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: string_ as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            return UIColor.white;
        }
    }
}
