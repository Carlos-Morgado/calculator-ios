//
//  HomeViewController.swift
//  iOS-Calculator
//
//  Created by Carlos Morgado on 7/2/23.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // OUTLETS
    
    // RESULTS
    @IBOutlet private weak var resultLabel: UILabel!
    
    // NUMBERS
    @IBOutlet weak var number0: UIButton!
    @IBOutlet weak var number1: UIButton!
    @IBOutlet weak var number2: UIButton!
    @IBOutlet weak var number3: UIButton!
    @IBOutlet weak var number4: UIButton!
    @IBOutlet weak var number5: UIButton!
    @IBOutlet weak var number6: UIButton!
    @IBOutlet weak var number7: UIButton!
    @IBOutlet weak var number8: UIButton!
    @IBOutlet weak var number9: UIButton!
    @IBOutlet weak var numberDecimal: UIButton!
    
    // OPERATORS
    @IBOutlet weak var operatorAC: UIButton!
    @IBOutlet weak var operatorPlusMinus: UIButton!
    @IBOutlet weak var operatorPercent: UIButton!
    @IBOutlet weak var operatorResult: UIButton!
    @IBOutlet weak var operatorAddition: UIButton!
    @IBOutlet weak var operatorSubstraction: UIButton!
    @IBOutlet weak var operatorMultiplication: UIButton!
    @IBOutlet weak var operatorDivision: UIButton!
    
    // VARIABLES
    private var totalValue: Double = 0                      // Total value
    private var temporalValue: Double = 0                   // Value per screen
    private var operatorIsSelected = false                  // Indicate if an operator has been selected
    private var decimal = false                             // Indicate if the value is decimal
    private var operation: OperationType = .none            // Actual operation
    
    // CONSTANTS
    private enum OperationType {
        case none, addition, substraction, multiplication, division, percent
    }
    private let kDecimalSeparator = Locale.current.decimalSeparator!
    private let kMaxLength = 9
    private let totalMemory = "total"
    
    // FORMATTERS
    // Formatting of auxiliary values
    private let auxFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formatting Total Auxiliary Values
    private let auxTotalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ""
        formatter.decimalSeparator = ""
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 100
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 100
        return formatter
    }()
    
    // Formatting of values ​​on screen by default
    private let printFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        let locale = Locale.current
        formatter.groupingSeparator = locale.groupingSeparator
        formatter.decimalSeparator = locale.decimalSeparator
        formatter.numberStyle = .decimal
        formatter.maximumIntegerDigits = 9
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 8
        return formatter
    }()
    
    // Formatting of values ​​per screen in scientific format
    private let printScientificFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.maximumFractionDigits = 3
        formatter.exponentSymbol = "e"
        return formatter
    }()
    
    // INITIALIZATION
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI
        number0.round()
        number1.round()
        number2.round()
        number3.round()
        number4.round()
        number5.round()
        number6.round()
        number7.round()
        number8.round()
        number9.round()
        numberDecimal.round()
        
        operatorAC.round()
        operatorPlusMinus.round()
        operatorPercent.round()
        operatorResult.round()
        operatorAddition.round()
        operatorSubstraction.round()
        operatorMultiplication.round()
        operatorDivision.round()
        
        numberDecimal.setTitle(kDecimalSeparator, for: .normal)
        
        totalValue = UserDefaults.standard.double(forKey: totalMemory)
        
        result()
    }
    
    // BUTTON ACTIONS
    @IBAction func operatorACAction(_ sender: UIButton) {
        clear()
        // We call to the 'clear' function we created before, in "CLEAN VALUES"
        sender.shine()
    }
    @IBAction func operatorPlusMinusAction(_ sender: UIButton) {
        temporalValue = temporalValue * (-1)
        resultLabel.text = printFormatter.string(from: NSNumber(value: temporalValue))
        sender.shine()
    }
    @IBAction func operatorPercentAction(_ sender: UIButton) {
        if operation != .percent {
            result()
        }
        operatorIsSelected = true
        operation = .percent
        result()
        sender.shine()
    }
    @IBAction func operatorResultAction(_ sender: UIButton) {
        result()
        // it do the operation that it has to do inside the switch
        sender.shine()
    }
    @IBAction func operatorAdditionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operatorIsSelected = true
        operation = .addition
        // With the function 'result' we do the operation that it has to do inside the switch. If we select the addition button  although we haven't selected the result operator, automatically we resolve the last operation forcing the 'result' function and we can continue with the next operation.
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operatorSubstractionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operatorIsSelected = true
        operation = .substraction
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operatorMultiplicationAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operatorIsSelected = true
        operation = .multiplication
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func operatorDivisionAction(_ sender: UIButton) {
        if operation != .none {
            result()
        }
        operatorIsSelected = true
        operation = .division
        sender.selectOperation(true)
        sender.shine()
    }
    @IBAction func numberDecimalAction(_ sender: UIButton) {
        let currentTemp = auxTotalFormatter.string(from: NSNumber(value: temporalValue))!
        if !operatorIsSelected && currentTemp.count >= kMaxLength {
            return
        }
        resultLabel.text = resultLabel.text! + kDecimalSeparator
        decimal = true
        selectVisualOperation()
        sender.shine()
    }
    @IBAction func numberAction(_ sender: UIButton) {
        operatorAC.setTitle("C", for: .normal)
        var currentTemp = auxTotalFormatter.string(from: NSNumber(value: temporalValue))!
        if !operatorIsSelected && currentTemp.count >= kMaxLength {
            return
        }
        
        currentTemp = auxFormatter.string(from: NSNumber(value: temporalValue))!
        
        // We've selected an operation
        if operatorIsSelected {
            totalValue = totalValue == 0 ? temporalValue : totalValue
                resultLabel.text = ""
                currentTemp = ""
                operatorIsSelected = false
        }
        
        // We've selected decimals
        if decimal {
            currentTemp = "\(currentTemp)\(kDecimalSeparator)"
            decimal = false
        }
        
        let number = sender.tag
        temporalValue = Double(currentTemp + String(number))!
        resultLabel.text = printFormatter.string(from: NSNumber(value: temporalValue))
        selectVisualOperation()
        sender.shine()
        print(sender.tag)
    }
    
    // CLEAN VALUES
    private func clear() {
        operation = .none
        operatorAC.setTitle("AC", for: .normal)
        // During some calculation, the "AC" button becomes "C", because there are temporary values ​​and we can delete them.
        if temporalValue != 0 {
        // If there are temporary results, we press the "C" button, and the temporary result is deleted. When there are no temporary results, we press the "C" button again and the total result is deleted.
            temporalValue = 0
            resultLabel.text = "0"
        } else {
            totalValue = 0
            // It means that the only thing that exists is only a total value.
            result()
        }
    }
    
    // GET FINAL VALUE
    private func result(){
        switch operation {
             
        case .none:
            // We do nothing
            break
        case .addition:
            totalValue = totalValue + temporalValue
            break
        case .substraction:
            totalValue = totalValue - temporalValue
            break
        case .multiplication:
            totalValue = totalValue * temporalValue
            break
        case .division:
            totalValue = totalValue / temporalValue
            break
        case .percent:
            temporalValue = temporalValue / 100
            totalValue = temporalValue
            break
        }
        
        // SCREEN FORMATTER
        if let currentTotal = auxTotalFormatter.string(from: NSNumber(value: totalValue)), currentTotal.count > kMaxLength {
            resultLabel.text = printScientificFormatter.string(from: NSNumber(value: totalValue))
        } else {
            resultLabel.text = printFormatter.string(from: NSNumber(value: totalValue))
        }
        
        operation = .none
        
        selectVisualOperation()
        
        UserDefaults.standard.set(totalValue, forKey: totalMemory)
        
        print("TOTAL: \(totalValue)")
    }
    
    // Shows visually the selected operation
    private func selectVisualOperation() {
            
        if !operatorIsSelected {
            // We are not operating
            operatorAddition.selectOperation(false)
            operatorSubstraction.selectOperation(false)
            operatorMultiplication.selectOperation(false)
            operatorDivision.selectOperation(false)
        } else {
            switch operation {
            case .none, .percent:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .addition:
                operatorAddition.selectOperation(true)
                operatorSubstraction.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
                case .substraction:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(true)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(false)
                break
            case .multiplication:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorMultiplication.selectOperation(true)
                operatorDivision.selectOperation(false)
                break
            case .division:
                operatorAddition.selectOperation(false)
                operatorSubstraction.selectOperation(false)
                operatorMultiplication.selectOperation(false)
                operatorDivision.selectOperation(true)
                break
            }
        }
    }
}
