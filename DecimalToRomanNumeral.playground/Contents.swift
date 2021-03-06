
import UIKit
import Foundation


func decimalToRomanNumeral(decimal:Int) -> String {
    
    // Output string and decimal number
    var roman:String = ""
    var number = decimal
    
    // Change negative to positive
    if number < 0 {
        number *= -1
    }
    
    // Convert to cooresponding roman numeral
    while number > 0 {
        if number >= 1000 {
            number -= 1000
            roman += "M"
        } else if number >= 900 {
            number -= 900
            roman += "CM"
        } else if number >= 500 {
            number -= 500
            roman += "D"
        } else if number >= 400 {
            number -= 400
            roman += "CD"
        } else if number >= 100 {
            number -= 100
            roman += "C"
        } else if number >= 90 {
            number -= 90
            roman += "XC"
        } else if number >= 50 {
            number -= 50
            roman += "L"
        } else if number >= 40 {
            number -= 40
            roman += "XL"
        } else if number >= 10 {
            number -= 10
            roman += "X"
        } else if number >= 9 {
            number -= 9
            roman += "IV"
        } else if number >= 5 {
            number -= 5
            roman += "V"
        } else if number >= 4 {
            number -= 4
            roman += "IV"
        } else if number > 0 {
            number -= 1
            roman += "I"
        }
    }
    
    return roman
}

print("\(decimalToRomanNumeral(decimal: 1954))")


func expressionToRomanNumeral(expresion:String) -> String? {
    
    let items = expresion.components(separatedBy: " + ")
    
    guard let firstNum = Int(items[0]),
         let secondNum = Int(items[1]) else {
            return ""
    }
    
    let answer = firstNum + secondNum
    
    let firstNumber = decimalToRomanNumeral(decimal: firstNum)
    let secondNumber = decimalToRomanNumeral(decimal: secondNum)
    let answerNumber = decimalToRomanNumeral(decimal: answer)
    
    return "\(firstNumber) + \(secondNumber) = \(answerNumber)"
}


let output = expressionToRomanNumeral(expresion: "256X + 178")
print("\(output)")


