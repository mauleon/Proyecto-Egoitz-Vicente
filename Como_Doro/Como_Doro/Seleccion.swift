//
//  Seleccion.swift
//  Como_Doro
//
//  Created by  on 7/1/16.
//  Copyright © 2016 Egibide. All rights reserved.
//

import UIKit

class Seleccion: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
self.view.backgroundColor = UIColor(patternImage: UIImage(named: "tomato.jpg")!)        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func Atras(sender: UIBarButtonItem) {
    
    
        self.dismissViewControllerAnimated(true, completion: {})
    }  /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
