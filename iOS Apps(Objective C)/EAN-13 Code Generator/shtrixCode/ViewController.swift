//
//  ViewController.swift
//  shtrixCode
//
//  Created by Drapaylo Yulian on 26.09.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//



import UIKit

// параметры экрана
let screenWidth = UIScreen.mainScreen().bounds.size.width
let screenHeight = UIScreen.mainScreen().bounds.size.height


var numEnterTextField : UITextField! // текстовое поле




class ViewController: UIViewController {
    
    var x : KRNBarcode?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        x = KRNBarcode.init()
        
        self.view.addSubview(x!)
        
        
        
        // добавим текстовое поле
        
        numEnterTextField = UITextField.init(frame: CGRectMake(screenWidth * 0.294, x!.frame.origin.y - 84, screenWidth * 0.5, 30))
        
        numEnterTextField.center.x = self.view.center.x
        numEnterTextField.borderStyle = UITextBorderStyle.Line
        
        numEnterTextField.text = "1111111111111"
       
        self.view.addSubview(numEnterTextField!)
        
        // добавим кнопку еще выше
        
        let buttonCount : UIButton = UIButton.init(type: UIButtonType.System)
        
        
        buttonCount.frame =  CGRectMake(screenWidth * 0.25, numEnterTextField.frame.origin.y - 40, 160, 30)
        
        buttonCount.setTitle("Показать штрих-код", forState: UIControlState.Normal)
      //  buttonCount.backgroundColor = UIColor.yellowColor()
        buttonCount.titleLabel?.font = UIFont.systemFontOfSize(15)
        
        
        buttonCount.addTarget(self, action: "makeNeededCalculations", forControlEvents: UIControlEvents.TouchUpInside)
        

        
        
        
        self.view.addSubview(buttonCount)
        
       
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.redColor()
       //  navigationBar.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Генератор EAN-13 кода"
        
        
      
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)

        
        /*
        let pinchGR : UIPinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: ("handlePinchGr:"))
        
        x!.addGestureRecognizer(pinchGR)
        
        */
        
        
     
        //[self.testView addGestureRecognizer:pinchGestureRecognizer];
        
        
        /*
        
       let myView : KRNMyView = KRNMyView.init(frame: CGRectMake(0, 0, 100, 100))
        
        myView.addSubview(UIView.init(frame: CGRectMake(0, 0, 10, 10)))
        myView.addSubview(UIView.init(frame: CGRectMake(0, 0, 20, 20)))
        
        
        myView.clearViewFromSubviews();
           myView.clearViewFromSubviews();
        
        
        */
        
    }
    
    /*
    func handlePinchGr (pinchGR : UIPinchGestureRecognizer)
    {
        x!.transform = CGAffineTransformScale(x!.transform, pinchGR.scale, pinchGR.scale)
    }
        */
    
       override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func makeNeededCalculations ()
    {

        
        let z : Bool = KRNBarcodeLogic.checkForRightCode(numEnterTextField.text!)
        
           if (z)
         {
            
        x!.clearField()
        x!.setOriginToStart()
        
        NSLog("\(x)");
        
        let barcodeLogic : KRNBarcodeLogic = KRNBarcodeLogic.init(code: numEnterTextField.text!)
        barcodeLogic.barcodeDrawObject = x
        
        
        barcodeLogic.calculateAndDrawBarcode()
        x!.drawCodeNums(numEnterTextField.text!)
        }
        
     //   x!.performSelector("clearField", withObject: self, afterDelay: 3.0)
        
        for view in self.view.subviews
        {
            view.resignFirstResponder();
        }
    }
    
    


}

