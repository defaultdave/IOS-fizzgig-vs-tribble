//
//  ViewController.swift
//  fizzgig-vs-tribble
//
//  Created by David Fleming on 8/28/16.
//  Copyright © 2016 defaultdave. All rights reserved.
//


/*
 Add SpriteKit
 Add SKView to view, does not auto complete
 Setup GameScene file
 present game scene from View controller
 */


import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}