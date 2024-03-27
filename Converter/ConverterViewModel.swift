import Foundation

enum CalculateBehaviour: Equatable {
    case appendNumberAfterDot(_ number: Int)
    case appendNumberBeforeDot(_ number: Int)
}

class ConverterViewModel {
    
    enum Constants {
        static let title = "Currency Converter"
    }
    
    var firstCurrencyFlag: String
    var secondCurrencyFlag: String
    var isFirstFlagSelected: Bool
    var isSecondFlagSelected: Bool
    var dotPressed: Bool
    var currencyArray: [Currency]
    var initialNumber: String
    var secondNumber: String
    
    var onUpdate: (() -> Void) = {}
    
    init(firstCurrencyFlag: String = "USD",
         secondCurrencyFlag: String = "BTC",
         isFirstFlagSelected: Bool = false,
         isSecondFlagSelected: Bool = false,
         dotPressed: Bool = false,
         currencyArray: [Currency] = [],
         initialNumber: String = "0",
         secondNumber: String = "0.00"
    ) {
        self.firstCurrencyFlag = firstCurrencyFlag
        self.secondCurrencyFlag = secondCurrencyFlag
        self.isFirstFlagSelected = isFirstFlagSelected
        self.isSecondFlagSelected = isSecondFlagSelected
        self.dotPressed = dotPressed
        self.currencyArray = currencyArray
        self.initialNumber = initialNumber
        self.secondNumber = secondNumber
    }
    
    func fetchCurrencyData(baseCurrency: String, secondaryCurrency: String) {
        NetworkManager.shared.fetchCurrencyData(baseCurrency: baseCurrency, secondaryCurrency: secondaryCurrency) { [weak self] result in
            switch result {
            case .success(let currency):
                self?.currencyArray = currency
                print(currency)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func hasTwoDecimalPlaces(_ number: String) -> Bool {
        if let dotIndex = number.firstIndex(of: ".") {
            let decimalPart = number[dotIndex...]
            return decimalPart.dropFirst().count == 2
        }
        return false
    }
    
    func didSelectFlag(url: String, currency: String) {
        if isFirstFlagSelected {
            firstCurrencyFlag = currency
            isFirstFlagSelected = false
        } else if isSecondFlagSelected {
            secondCurrencyFlag = currency
            isSecondFlagSelected = false
        }
    }
    
    func calculateBehaviour(tag: Int, currentText: String) -> String {
        var text = currentText
        
        let behaviour = nav(number: tag)
        
        switch behaviour {
        case .appendNumberBeforeDot(let number):
            if text.count < 10 && !hasTwoDecimalPlaces(text) {
                text += String(number)
            }
        case .appendNumberAfterDot(let number):
            if !hasTwoDecimalPlaces(text) {
                text += String(number)
            }
        }
        return text
    }
    
    func nav(number: Int) -> CalculateBehaviour {
        if dotPressed {
            return .appendNumberAfterDot(number)
        } else {
            return .appendNumberBeforeDot(number)
        }
    }
    
    func updateSecondNumber() {
        guard let initial =  Float(initialNumber), let currency = currencyArray.first else { return }
        let value = initial * currency.rate
        secondNumber = value.roundedString
    }
}
