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
            self.navigationController?.navigationBar.barTintColor = UIColor.mediumGreen
            navBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        }
        tabBar.barTintColor = UIColor.mediumGreen
        tabBar.tintColor = UIColor.darkGreen
        tabBar.unselectedItemTintColor = UIColor.lightGreen
        
        
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
