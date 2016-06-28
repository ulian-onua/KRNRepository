//
//  KRNBarcode.swift
//  shtrixCode
//
//  Created by Drapaylo Yulian on 26.09.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

import UIKit
import Foundation

public enum LineType // тип рисуемой линии
{
    case simpleLine // обычная лииня
    case divideLine // разделительная линия
}


public protocol KRNBarcodeProtocol : class
{
    func drawLines(WithBitString string : String, lineType : LineType)->Bool;  // нарисовать линии в соответствии с битовой строкой, где string - битовая строка, а lineType - тип линии (обычная или разделительная)
    
    func drawCodeNums(num : String);
    
 
    func setOriginToStart()    // сброс начала рисования первой линии (возврат)
    
    func clearField () // очистить поле от линий
    
}



public class KRNBarcode: UIView, KRNBarcodeProtocol // класс рисующий код EAN-13 и линии к нему

{
    
    private var lineOriginX : CGFloat = 0 // начало первой линии (по умолчанию - 0)
    
    
    
    var numOfLines : Int = 0;
    
    private var simpleLineSize : CGSize = CGSizeMake(0, 0) // frame обычной линии (расчет будет осуществлен позже)
    
    private var divideLineSize : CGSize = CGSizeMake(0, 0) // frame разделительной линии (расчет будет осуществлен позже)
  
    
    internal
    
    override init (frame: CGRect) // designated initializer
    {
 
        super.init(frame: frame)
        
        self.calculateAndSetLinesSize() // расчитать размер линий
        
        self.setOriginToStart() // установить Origin в начальную точку


  
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        
        super.init(coder: aDecoder)
        self.calculateAndSetLinesSize()
        self.setOriginToStart()
    }
    
    
    convenience init (originX : CGFloat, originY: CGFloat, width: CGFloat, height: CGFloat)
    {
        self.init (frame: CGRectMake(originX, originY, width, height))
    }
    
    convenience init()
    {
        let deviceBounds : CGRect = UIScreen.mainScreen().bounds  // текущие границы устройства
        let deviceScale = UIScreen.mainScreen().scale;
        
        NSLog ("Bounds: \(deviceBounds). Scale: \(deviceScale)")
        NSLog ("Device resolution. Width: \(deviceBounds.width * deviceScale). Height: \(deviceBounds.height * deviceScale) ")
        
        // ширина и высота нашего поля в процентах (для iPhone)
        
        
       
        
        
        
        
        self.init (frame: KRNBarcode.countBarcodeFrame())  // 320 - 568
                                                            // 375-667
        
        
        
    }
    
    
    
    
    
    // ФУНКЦИЯ РАСЧЕТА FRAME нашего устройства в зависимости от параметров устройства
    
    class private func countBarcodeFrame() -> CGRect
    {
        let deviceOrientation : UIDeviceOrientation = UIDevice.currentDevice().orientation; // получаем ориентацию устройства
        
        let deviceBounds : CGRect = UIScreen.mainScreen().bounds;  // текущие границы устройства
        
        var devSize : CGSize = CGSize.init(); // размеры, которые затем нужны будут для расчетов
        
        if deviceOrientation == .Portrait || deviceOrientation == .PortraitUpsideDown || deviceOrientation == .Unknown
        {
            devSize = CGSize.init(width: deviceBounds.width, height: deviceBounds.height);
            
        }

        else if deviceOrientation == .LandscapeLeft || deviceOrientation == .LandscapeRight
        {
            devSize = CGSize.init(width: deviceBounds.height, height: deviceBounds.width);
        }
        
        var barcodeFrame : CGRect = CGRect.init();
        
    
        
        // определяем ширины нашего поля (для iPhone)
        barcodeFrame.size.width = devSize.width * 0.875; // стандартная ширина нашего поля - 87,5 процента от ширины экрана
        barcodeFrame.size.height  = devSize.height * 0.28845; // стандартная высота нашего поля - 28,845 процента от высоты экрана
        
        // определяет origin нашего поля в процентах (для iPhone)
        
        barcodeFrame.origin.x = (devSize.width * (1-0.875)) / 2;

        barcodeFrame.origin.y = (devSize.height * (1-0.28845)) / 2;
     
        
        return barcodeFrame;
        
    }
    

   
    
    // рисование
    
    override public func drawRect(rect: CGRect)
    {
       
        
        let context : CGContextRef? = UIGraphicsGetCurrentContext() // получаем текущий контекст
    
         CGContextClearRect(context, rect) // очищаем контекст (хорошая практика)
     
        CGContextSetRGBFillColor(context, 255, 255, 255, 1) // устанавливаем цвет
        CGContextFillRect(context, rect) // рисуем наш прямоугольник
        
         // рисуем рамку
        CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 1);
    
        CGContextStrokeRect(context, rect);    //this will draw the border


        
    }
    
    
    private func calculateAndSetLinesSize() // расчитать высоту и ширину полос
    {

        
        simpleLineSize.width =  self.frame.size.width / (81.0 + 25); // 81 - количество полос, 2 - позиция, чтобы хватило места в квадрате
        
        simpleLineSize.height = self.frame.size.height - (20+12)
        
        
        // расчитываем и устанавливаем фрейм увеличенной полосы
        divideLineSize = CGSizeMake(simpleLineSize.width, simpleLineSize.height+13)
        

    }
    
    
    func drawLine (color : UIColor, lineType : LineType = .simpleLine) // нарисовать линию с выбором типа
    {
        
        
        let line: UIView = UIView.init(frame: CGRectMake(lineOriginX, 2, simpleLineSize.width, lineType == .simpleLine ? simpleLineSize.height : divideLineSize.height)) // создаем линию

        line.backgroundColor = color // указываем цвет
        
        self.addSubview(line) // добавляем линию в наше view
        
        lineOriginX = lineOriginX + simpleLineSize.width// устанавливаем начало следующей линии

        
        
        self.numOfLines++
        
    }
    
    // нарисовать цифровой код внизу линий
    public func drawCodeNums(num : String)
    {
        // добавить проверку на соответствие строки 13 символам
        
        var codeOriginX = getStartOrigin() - 12 // для первого символа
        
        for i in 0..<num.characters.count  // i - индекс
        {
            let numLabel : UILabel = UILabel.init(frame: CGRectMake(codeOriginX, 2 + simpleLineSize.height-5, self.divideLineSize.width * 4, 30))
            numLabel.text = String(num [num.characters.startIndex.advancedBy(i)])
            numLabel.font = UIFont.systemFontOfSize(18.0)
            self.addSubview(numLabel)
            
            // определяем отступы после символов
            if (i == 0)
            {
                 codeOriginX = codeOriginX + (self.divideLineSize.width * 8) // увеличенный отступ после первого символа
            }
            else
            {
                codeOriginX = codeOriginX + (self.divideLineSize.width * (i != 6 ? 7.25 : 9.8)) // разные отступы после 7 символа и всех остальных
            }
            

        }
        
        
        
       // numLabel.text = num
        
     
        
        
    }
    

    
    public func drawLines(WithBitString string : String, lineType : LineType = LineType.simpleLine)-> Bool
        // нарисовать линии в соответствии с битовой строкой
        
    {
      
        
        // проверяем нашу битовую строку на наличие в ней только 0 и 1
        for character in string.characters //
        {
            if (Set.init(arrayLiteral: "0", "1").contains(character) == false)  //  если найден какой-то другой символ, кроме 0  и1
            {
                return false
            }
        }

        // рисуем строки
        
        for i in 0..<string.characters.count // перебираем все символы в строке
        {
            let index = string.startIndex.advancedBy(i)  // получаем очередной индекс
            
           let tempChr : Character = string[index] // получаем временный characted
            
            
            self.drawLine((tempChr == "0" ? UIColor.whiteColor() : UIColor.blackColor()), lineType : lineType)  // рисуем линию. Если очередной битовый символ равен нулю - белого цвета, если 1 - черного цвета
            
            
        }
        return true;
    }
    
    
    public func clearField () // очистить поле
    {
        for view in self.subviews
        {
            view.removeFromSuperview()
        }
        
       
    }
    
    // сброс начала рисования первой линии (вовзрат)
    public func setOriginToStart()
    {
        self.lineOriginX = self.getStartOrigin()
    }
    
    
    private func getStartOrigin() -> CGFloat
    {
        return 15.0
        
      //  return self.frame.size.width * 0.0536
    }
    
    
    
    
    
    

}
