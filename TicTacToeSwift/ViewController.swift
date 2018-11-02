//
//  ViewController.swift
//  TicTacToeSwift
//
//  Created by Julien on 31/10/2018.
//  Copyright © 2018 Julien. All rights reserved.
//

import UIKit

class ViewController: UIViewController, getDataDelegateWiner {

    // Object connexion
    @IBOutlet weak var labelLineCount: UILabel!
    @IBOutlet weak var labelLastWinner: UILabel!
    @IBOutlet weak var sliderLineCount: UISlider!
    @IBOutlet weak var ButtonPlay: UIButton!
    
    // Standard line number
    var lineCount : Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // Slider bar updating label
    @IBAction func SliderLineCountChanged(_ sender: UISlider) {
        lineCount = Int(sender.value)
        labelLineCount.text = String(Int(sender.value))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func PlayButtonPushed(_ sender: Any) {
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "ViewControllerGame") as! ViewControllerGame
        myVC.tabSize = lineCount
        myVC.delegateCustom = self
        navigationController?.pushViewController(myVC, animated: true)
    }
    
    func getDataFromMainVC(dataWinner : String)
    {
        // dataString from GameVC
        labelLastWinner.text = dataWinner
    }
}

