//
//  TaskListViewController.swift
//  slokara
//
//  Created by Yoshiki Izumi on 2019/12/18.
//  Copyright © 2019 Sab_swiftlin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController, NavigationChildViewController, UITabBarDelegate {

    @IBOutlet weak var topSpacer: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let taskText: [String] = [
        "ゴブリンを10匹倒せ！",
        "モンスターを３匹倒せ！",
        "スライムを５匹倒せ！",
        "おばけを２匹倒せ！",
        "ゴブリンとスライムを倒せ！",
    ]
    let emblemName: [String] = [
        "emblem_copper",
        "emblem_gold",
        "emblem_silver",
        "emblem_stone",
        "emblem_wood",
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 400, height: 2000)
        tabBar.delegate = self
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            item.badgeColor = UIColor.red
            for i in 0..<5 {
                let image = UIImageView(image: UIImage(named: "scroll"))
                let imageCredits = UIImageView(image: UIImage(named: "school_credits"))
                let imageCoin = UIImageView(image: UIImage(named: "coin"))
                let imagePassed = UIImageView(image: UIImage(named: "scroll_passed_stamp"))
                
                let imageTypeDark   = UIImageView(image: UIImage(named: "reel_dark_a"))
                let imageTypeFire   = UIImageView(image: UIImage(named: "reel_fire_a"))
                let imageTypeLight  = UIImageView(image: UIImage(named: "reel_light_a"))
                let imageTypeSoil   = UIImageView(image: UIImage(named: "reel_soil_a"))
                let imageTypeWater  = UIImageView(image: UIImage(named: "reel_water_a"))
                let imageTypeWind   = UIImageView(image: UIImage(named: "reel_wind_a"))

                let imageEmblem     = UIImageView(image: UIImage(named: emblemName[i]))
                
                image.frame = CGRect(x: 0, y: i * 200, width: 400, height: 100)
                imageEmblem.frame = CGRect(x: 30, y: i * 200, width: 50, height: 50)
                imageCredits.frame = CGRect(x: 140, y: i * 200 + 5, width: 30, height: 30)
                imageCoin.frame = CGRect(x: 200, y: i * 200 + 5, width: 30, height: 30)
                imagePassed.frame = CGRect(x: 100, y: i * 200, width: 310, height: 100)
                
                imageTypeDark.frame  = CGRect(x: 270, y: i * 200 + 15, width: 50, height: 50)
                imageTypeFire.frame  = CGRect(x: 300, y: i * 200 + 15, width: 50, height: 50)
                imageTypeLight.frame = CGRect(x: 330, y: i * 200 + 15, width: 50, height: 50)
                imageTypeSoil.frame  = CGRect(x: 270, y: i * 200 + 45, width: 50, height: 50)
                imageTypeWater.frame = CGRect(x: 300, y: i * 200 + 45, width: 50, height: 50)
                imageTypeWind.frame  = CGRect(x: 330, y: i * 200 + 45, width: 50, height: 50)

                
                let labelRank = CommonFontLabel()
                labelRank.text = (i + 1).description;
                labelRank.frame = CGRect(x:40, y: i * 200, width:50, height:50);
                labelRank.setFontSize(size: 50)
                
                let labelNew = CommonFontLabel()
                labelNew.text = "NEW";
                labelNew.frame = CGRect(x:100, y: i * 200, width:100, height:30);
                labelNew.setFontSize(size: 16)
                labelNew.textColor = UIColor.red

                
                let labelCreditsNum = CommonFontLabel()
                labelCreditsNum.text = "12";
                labelCreditsNum.frame = CGRect(x:170, y: i * 200 + 5, width:100, height:30);
                labelCreditsNum.setFontSize(size: 16)

                let labelCoinNum = CommonFontLabel()
                labelCoinNum.text = "3456";
                labelCoinNum.frame = CGRect(x:230, y: i * 200 + 5, width:100, height:30);
                labelCoinNum.setFontSize(size: 16)

                let labelType = CommonFontLabel()
                labelType.text = "MonsterType";
                labelType.frame = CGRect(x:280, y: i * 200, width:120, height:30);
                labelType.setFontSize(size: 14)


                let labelTask = CommonFontLabel()
                labelTask.text = taskText[i];
                labelTask.frame = CGRect(x:100, y: i * 200, width:350, height:100);
                labelTask.setFontSize(size: 16)
                labelTask.numberOfLines = 2

                scrollView.addSubview(image)
                scrollView.addSubview(imageEmblem)
                scrollView.addSubview(imageCoin)
                scrollView.addSubview(imageCredits)
                scrollView.addSubview(imageTypeDark)
                scrollView.addSubview(imageTypeFire)
                scrollView.addSubview(imageTypeLight)
                scrollView.addSubview(imageTypeSoil)
                scrollView.addSubview(imageTypeWater)
                scrollView.addSubview(imageTypeWind)
                scrollView.addSubview(imagePassed)

                scrollView.addSubview(labelRank)
                scrollView.addSubview(labelTask)
                scrollView.addSubview(labelNew)
                scrollView.addSubview(labelCoinNum)
                scrollView.addSubview(labelCreditsNum)
                scrollView.addSubview(labelType)

            }
            
        case 2:
            for i in 0..<5 {
                let image = UIImageView(image: UIImage(named: "scroll"))
                image.frame = CGRect(x: 0, y: i * 200, width: 400, height: 100)
                
                let label = CommonFontLabel()
                label.text = "幼稚園";
                label.frame = CGRect(x:50, y: i * 200, width:350, height:100);
                label.setFontSize(size: 16)
                label.numberOfLines = 2

                scrollView.addSubview(image)
                scrollView.addSubview(label)
            }
        case 3:
            for i in 0..<5 {
                let image = UIImageView(image: UIImage(named: "scroll"))
                image.frame = CGRect(x: 0, y: i * 200, width: 400, height: 100)
                
                let label = CommonFontLabel()
                label.text = "小学校";
                label.frame = CGRect(x:50, y: i * 200, width:350, height:100);
                label.setFontSize(size: 16)
                label.numberOfLines = 2

                scrollView.addSubview(image)
                scrollView.addSubview(label)
            }
        case 4:
            for i in 0..<5 {
                let image = UIImageView(image: UIImage(named: "scroll"))
                image.frame = CGRect(x: 0, y: i * 200, width: 400, height: 100)
                
                let label = CommonFontLabel()
                label.text = "中学校";
                label.frame = CGRect(x:50, y: i * 200, width:350, height:100);
                label.setFontSize(size: 16)
                label.numberOfLines = 2

                scrollView.addSubview(image)
                scrollView.addSubview(label)
            }
        case 5:
            for i in 0..<5 {
                let image = UIImageView(image: UIImage(named: "scroll"))
                image.frame = CGRect(x: 0, y: i * 200, width: 400, height: 100)
                
                let label = CommonFontLabel()
                label.text = "高校";
                label.frame = CGRect(x:50, y: i * 200, width:350, height:100);
                label.setFontSize(size: 16)
                label.numberOfLines = 2

                scrollView.addSubview(image)
                scrollView.addSubview(label)
            }

        default:
            return
        }
    }
}
