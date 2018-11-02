//
//  ViewControllerGame.swift
//  TicTacToeSwift
//
//  Created by Julien on 31/10/2018.
//  Copyright © 2018 Julien. All rights reserved.
//

// Create the delegate
protocol  getDataDelegateWiner  {
    func getDataFromMainVC(dataWinner: String)
}

import UIKit

class ViewControllerGame: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // The grid
    var tableauTTT : [Int] = []
    // Size of the row
    var tabSize = Int()
    // first player's turn
    var turnPlayer = 1
    
    // Collection's size
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    var winner : Int = 0
    
    // Label to inform the turn
    @IBOutlet weak var labelInfo: UILabel!
    
    // CollectionView for the game's grid
    @IBOutlet weak var CollectionViewGridGame: UICollectionView!
    
    var delegateCustom : getDataDelegateWiner?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        screenSize = CollectionViewGridGame.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // Resizing of Cells
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/CGFloat(tabSize), height: screenWidth/CGFloat(tabSize))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        CollectionViewGridGame!.collectionViewLayout = layout
        
        // Init tableauTTT
        for _ in 0...tabSize * tabSize - 1 {
            tableauTTT.append(0)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // Delegate/DataSource Methods
    
    // Fonction to return the size of the grid
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabSize * tabSize
    }
    
    // Design of each cells
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionCell: UICollectionViewCell! = collectionView.dequeueReusableCell(withReuseIdentifier: "CellGridGame", for: indexPath)
        

        collectionCell.layer.borderWidth = 2
        collectionCell.contentView.backgroundColor = UIColor.white
    
        return collectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedCell:UICollectionViewCell = CollectionViewGridGame.cellForItem(at: indexPath)!
        
        // Treatment of each actions about the grid
        if tableauTTT[indexPath.row] == 0 {
            if turnPlayer == 1 {
                turnPlayer = 2
                tableauTTT[indexPath.row] = 1
                selectedCell.contentView.addSubview(UIImageView(image: resizeImage(image: #imageLiteral(resourceName: "circle-4b44b38442350d956dd27160273af5da"),targetSize: selectedCell.bounds.size)))
                labelInfo.text = "Tour du joueur 2"
            }
            else {
                turnPlayer = 1
                tableauTTT[indexPath.row] = 2
                selectedCell.contentView.addSubview(UIImageView(image: resizeImage(image: #imageLiteral(resourceName: "cross-24-512"),targetSize: selectedCell.bounds.size)))
                labelInfo.text = "Tour du joueur 1"
            }
        }
        
        // Check if the game is over
        winner = isWin()
        if winner > 0 {
            showAlert(withTitleAndMessage: "Game Over", message: String(format:"Le joueur %@ a gagné", String(winner)))
        }
        else if isWin() < 0 {
            showAlert(withTitleAndMessage: "Game Over", message: "Match nul")
        }
        
    }
    
    // Function who allow to stop the game and display the winner
    func showAlert(withTitleAndMessage title:String, message:String) {
        // Return of the main view after "Ok"
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
            action in
                //_ = self.navigationController?.popViewController(animated: true)
            //calling method defined in first View Controller with Object
            self.delegateCustom?.getDataFromMainVC(dataWinner: String(format:"Le dernier vainqueur est : joueur %@", String(self.winner)))
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: { () in print("The game will be reset...")})
    }
    
    // Function who allow to resize the picture depending of the cells's size
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,  height:size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // Function who allow to check if the game is over and to find the winner
    func isWin() -> Int {
        // display who will win
        var isWin : Int = 0
        // The sum of good horizontal row
        var countWinH : Int = 0
        // The sum of good vertical row
        var countWinV : Int = 0
        // The sum of good diagonal row
        var countWinD1 : Int = 0
        var countWinD2 : Int = 0
        // The sum of void cells
        var countVoidCell : Int = 0
        // The current line horrizontal
        var countLineH : Int = 0
        // The current line Vertical
        var countLineV : Int = 0
        // The current line diagonal
        var countLineD1 : Int = 0
        var countLineD2 : Int = 0
        
        for i in 1...2 {
            countLineH = 0
            if isWin == 0 {
                for j in 0...tabSize - 1 {
                    if isWin == 0 {
                        countWinH = 0
                        countWinV = 0
                        countWinD1 = 0
                        countWinD2 = 0
                        countLineV = 0
                        countLineD1 = 0
                        countLineD2 = 0
                        for k in 0...tabSize - 1 {
                            // Horrizontal check
                            if tableauTTT[k + countLineH] == i {
                                countWinH += 1
                            }
                            
                            // Vertical check
                            if tableauTTT[j + countLineV] == i {
                                countWinV += 1
                            }
                            
                            // Diagonal check
                            if j == 0 && tableauTTT[countLineD1] == i {
                                countWinD1 += 1
                            }
                            
                            if j == tabSize - 1 && tableauTTT[j + countLineD2] == i {
                                countWinD2 += 1
                            }
                            
                            if tableauTTT[k + countLineH]  == 0 {
                                countVoidCell += 1
                            }
                            
                            countLineV += tabSize
                            countLineD1 += tabSize + 1
                            countLineD2 += tabSize - 1
                        }
                        countLineH += tabSize
                        if (countWinH == tabSize || countWinV == tabSize || countWinD1 == tabSize || countWinD2 == tabSize) {
                            isWin = i
                        }
                    }
                }
            }
        }
        
        if (isWin == 0 && countVoidCell == 0) {
            isWin = -1
        }
        
        return isWin
    }

}
