//
//  BaseCadastroVC.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 27/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CadastroBaseVC: UIViewController, CadastroViewControllerProtocol {
    weak var delegate: CadastroControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftBarButtonItemTapped(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rightBarButtonItemTapped(sender: UIBarButtonItem){
        if self.saveUpdates() {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func saveUpdates() -> Bool{
        print("Base Save Updates (doing nothing)")
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
