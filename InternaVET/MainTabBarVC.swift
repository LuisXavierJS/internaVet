//
//  MainTabBarVC.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 16/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit
class MainTabBarVC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = 1
        self.title = self.tabBar.selectedItem?.title
        
        
        if let navBar = self.navigationController?.navigationBar{
//            let gradient = CAGradientLayer()
//            gradient.frame = navBar.bounds
//            gradient.colors = [UIColor.init(red: 68/255, green: 207/255, blue: 70/255, alpha: 1).cgColor, UIColor.init(red: 35/255, green: 186/255, blue: 85/255, alpha: 1).cgColor]
            self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 0/255, green: 113/255, blue: 20/255, alpha: 1)
            navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
//            self.navigationController?.navigationBar.layer.insertSublayer(gradient, at: 0)
        }
//        let gradient = CAGradientLayer()
//        gradient.frame = tabBar.bounds
//        gradient.colors = [UIColor.init(red: 18/255, green: 89/255, blue: 55/255, alpha: 1).cgColor, UIColor.init(red: 35/255, green: 186/255, blue: 85/255, alpha: 1).cgColor]
//        tabBar.layer.insertSublayer(gradient, at: 0)
        tabBar.barTintColor = UIColor.init(red: 0/255, green: 113/255, blue: 20/255, alpha: 1)//UIColor.darkGreen
        tabBar.tintColor =  UIColor.init(red: 0, green: 52/255, blue: 10/255, alpha: 1)
        tabBar.unselectedItemTintColor = UIColor.init(red: 129/255, green: 178/255, blue: 117/255, alpha: 1)//UIColor.darkGreen//UIColor.white
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view
        if fromView == toView {
            return false
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve) { (finished:Bool) in
            
        }
        return true
    }
    
    @IBAction func menuButtonTapped(sender: UIBarButtonItem){
        guard let sideMenuVC = self.sideMenuController else{return}
        sideMenuVC.showLeftViewAnimated()
    }
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem){
        guard let ctrlr = self.selectedViewController as? MainTabBarControllerItemProtocol else { return }
        ctrlr.addButtonTapped()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new
     view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
