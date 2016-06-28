//
//  KRBBarcodeLogic.swift
//  shtrixCode
//
//  Created by Drapaylo Yulian on 27.09.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

import Foundation
import UIKit



public class KRNBarcodeLogic
 {
    
    
    
    weak public var barcodeDrawObject : KRNBarcodeProtocol?  // класс, который будет рисовать логику
    
    private var digitCode : String;

    
    internal
    
    // иниациализация
    
    init(code : String)
    {
   
        self.digitCode = code;
        
    }
    
    
    internal class func firstSixCode(x : Character) -> String // расшифровываем 1-шесть цифр (кроме первой цифры)
    {
        switch (x)
        {
        case "0" : return "AAAAAA"
        case "1" : return "AABABB"
        case "2" : return "AABBAB"
        case "3" : return "AABBBA"
        case "4" : return "ABAABB"
        case "5" : return "ABBAAB"
        case "6" : return "ABBBAA"
        case "7" : return "ABABAB"
        case "8" : return "ABABBA"
        case "9" : return "ABBABA"
        default:
            return "Error"
        }
    }
    
    
    
    

     // раскодируем число по его коду
    
    internal class func decode (x : Character, code : Character) -> String
    {
        var tempStr : String = String() // создадим пустую строку
        
        
        // функция изменения строки наоборот
    
        func naoborot (var s : String) -> String
        {
            var x : Character // создаем символ
            
            for i in 1..<s.characters.count
            {
                x = s[s.startIndex.advancedBy(i)]; // получаем очередной символ строки
                s.removeAtIndex(s.startIndex.advancedBy(i)); // удаляем очередной индекс строки
                s = String.init(x) + s; // добавляем символ к полученной строке
                
            }
            
            return s;
        }
        
        
        // функция изменения бита в строке
        func changeBit (var str : String) -> String // меняем в строка 1 и 0 и наоборот
        {
            for i in 0..<str.characters.count
            {
                let index = str.startIndex.advancedBy(i)
                
                let ch : Character  = str[index]
                
                if (ch == "0" || ch == "1")
                {
                    str.removeAtIndex(index)
                    str.insert ((ch == "0" ? "1" : "0"), atIndex: index) // вставим противоположный знак
                    
                }
                
            }
            return str;
        }

        
        
        switch (x)
        {
        case "0": tempStr = "0001101"
        case "1": tempStr = "0011001"
        case "2": tempStr = "0010011"
        case "3": tempStr = "0111101"
        case "4": tempStr = "0100011"
        case "5": tempStr = "0110001"
        case "6": tempStr = "0101111"
        case "7": tempStr = "0111011"
        case "8": tempStr = "0110111"
        case "9": tempStr = "0001011"
        default: break
            
        }
        
        if (code == "C")
        {
            tempStr = changeBit(tempStr)
        }
        else if (code == "B")
        {
            tempStr = naoborot(changeBit(tempStr))
        }
        
        return tempStr
        
        
    }
    
    
  
    
    // проверяем правильно ли введен код

    internal class func checkForRightCode (code : String) -> Bool
    {
        if code.characters.count != 13 // если введенная строка не равна 13 символа
        {
            return false;
        }
        
        let codeDigitsSet : Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] // объявляем множество правильных символов
        
        
        // проверяем все ли символы есть в нашем множестве
        for character in code.characters //
        {
            if (codeDigitsSet.contains(character) == false)
            {
                return false
            }
        }
        
        return true
        
    }
    
    private func paintCode(code :String, x : Int) // отрисовываем код, используя класс
        
    {
        
        var i2 : Int = 0
        
        
        for i in x...x+5
        {
            let userNumberIndex = self.digitCode.startIndex.advancedBy(i)
            let codeIndex = code.startIndex.advancedBy(i2)
            
            self.barcodeDrawObject!.drawLines(WithBitString: KRNBarcodeLogic.decode(self.digitCode[userNumberIndex], code: code[codeIndex]), lineType : LineType.simpleLine)
            i2++
        }
        
        
        
        
    }
    
    
    // расчитать и нарисовать код - ОСНОВНАЯ ФУНКЦИЯ
    public func calculateAndDrawBarcode()
    {
    
   
    
    
    let firstCode : String = KRNBarcodeLogic.firstSixCode(digitCode[digitCode.startIndex]) // определяем код первых шести цифр
    
    let secCode : String = "CCCCCC"  // код вторых шести цифр
    
    
    
    // последовательно отрисовываем линии в соответствии с кодировкой
    
    self.barcodeDrawObject!.drawLines(WithBitString: "101", lineType: LineType.divideLine)
    self.paintCode(firstCode, x: 1)
    self.barcodeDrawObject!.drawLines(WithBitString: "01010", lineType: LineType.divideLine)
    self.paintCode(secCode, x: 7)
    self.barcodeDrawObject!.drawLines(WithBitString: "101", lineType: LineType.divideLine)
        
//    self.barcodeDrawObject!.setOriginToStart() // возвращаем первую линию обратно
        

    }
    
    
}
