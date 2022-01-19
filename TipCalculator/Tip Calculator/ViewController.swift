//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Chao Jiang on 1/10/22.
//

import UIKit

class TipCalculatorViewController: UIViewController {

/*initial UIStackView and its 4 subviews*/
    
    private let mainStack: UIStackView = {
        let st = UIStackView()
        st.distribution = .fillEqually
        st.axis = .vertical
        return st
    }()
    
    private let firstLine: UIStackView = {
        let fl = UIStackView()
        fl.distribution = .fillEqually
        fl.alignment = .center
        return fl
    }()
    
    private let secondLine: UIStackView = {
        let sl = UIStackView()
        sl.distribution = .fillEqually
        sl.alignment = .center
        return sl
    }()
    
    private let thirdLine: UIView = {
        let view = UIView()
        return view
    }()
    
    private let lastLine: UIStackView = {
        let ll = UIStackView()
        ll.distribution = .fillEqually
        ll.alignment = .center
        return ll
    }()
    
/*initial each editable elements in stack*/
    private var billAmountextField: UITextField = {
        var tf = UITextField()
        tf.isEnabled = true
        tf.placeholder = "$"
        tf.textAlignment = .right
        tf.keyboardType = .decimalPad
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(billAmountTextFieldDidChanged(_:)), for: .allEditingEvents)
        return tf
    }()
    
    private var tipAmount: UILabel = {
        var tip = UILabel()
        tip.text = "$0.00"
        tip.textAlignment = .right
        tip.font = .systemFont(ofSize: 18)
        return tip
    }()
    
    private let thirdLineSegControl:UISegmentedControl = {
        let seg = UISegmentedControl(items: ["15%", "18%", "20%"])
        seg.addTarget(self, action: #selector(thirdLineSegControlDidChanged(_:)), for: .valueChanged)
        return seg
    }()
    
    private var totalAmount: UILabel = {
        var total = UILabel()
        total.isEnabled = true
        total.text = "$0.00"
        total.font = .systemFont(ofSize: 18)
        total.textAlignment = .right
        return total
    }()
    
//main
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(mainStack)
        addStackConstraints(to: mainStack)
        
        //First row
        mainStack.addArrangedSubview(firstLine)
        firstLine.addArrangedSubview({
            let label: UILabel = UILabel()
            label.text = "Bill Amount"
            label.font = .boldSystemFont(ofSize: 18)
            return label
        }())
        firstLine.addArrangedSubview(billAmountextField)
        addBillAmountTFConstraints()
        
        //Second row
        mainStack.addArrangedSubview(secondLine)
        secondLine.addArrangedSubview({
            let label = UILabel()
            label.text = "Tip"
            label.font = .boldSystemFont(ofSize: 18)
            return label
        }())
        secondLine.addArrangedSubview(tipAmount)
        
        //Third row
        mainStack.addArrangedSubview(thirdLine)
        thirdLine.addSubview(thirdLineSegControl)
        addsegControlConstraints()
        
        //Last row
        mainStack.addArrangedSubview(lastLine)
        lastLine.addArrangedSubview({
            let totalLabel = UILabel()
            totalLabel.text = "Total"
            totalLabel.font = .boldSystemFont(ofSize: 18)
            return totalLabel
        }())
        lastLine.addArrangedSubview(totalAmount)
        
        
        
    }
//View Constraints
    func addStackConstraints(to st: UIStackView) {
        st.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            st.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            st.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5),
            st.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            st.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func addBillAmountTFConstraints() {
        billAmountextField.translatesAutoresizingMaskIntoConstraints = false
        billAmountextField.heightAnchor.constraint(equalTo: firstLine.heightAnchor, multiplier: 0.5).isActive = true
        billAmountextField.widthAnchor.constraint(equalTo: firstLine.widthAnchor, multiplier: 0.3).isActive = true
//        print(firstLine.arrangedSubviews[1])
    }
    
    func addsegControlConstraints() {
        thirdLineSegControl.translatesAutoresizingMaskIntoConstraints = false
        thirdLineSegControl.centerXAnchor.constraint(equalTo: thirdLine.centerXAnchor).isActive = true
        thirdLineSegControl.centerYAnchor.constraint(equalTo: thirdLine.centerYAnchor).isActive = true
        thirdLineSegControl.leadingAnchor.constraint(equalTo: thirdLine.leadingAnchor).isActive = true
        thirdLineSegControl.trailingAnchor.constraint(equalTo: thirdLine.trailingAnchor).isActive = true
    }
    
//Calculation
    @objc func thirdLineSegControlDidChanged(_ segControl: UISegmentedControl){
        updating(by: billAmountextField, andBy: segControl) }
    
    @objc func billAmountTextFieldDidChanged(_ tf: UITextField) {
        updating(by: tf, andBy: thirdLineSegControl)
    }
    
    func calculation(bill: Double, tipercentage: Double) {
        tipAmount.text = "$" + String(round(bill*tipercentage*100)/100 )
        totalAmount.text = "$" + String(round(bill*(1+tipercentage)*100)/100)
    }
    
    func updating(by blTxField: UITextField,andBy seg: UISegmentedControl) {
        guard let text = blTxField.text?.drop(while: { c in
            c == "$"
        }) else{ return }
        
        if(text.count == 0) {
            calculation(bill: 0, tipercentage: 0)
            blTxField.text = ""
        }
        
        guard let bill = Double(text) else { return }
        
        switch seg.selectedSegmentIndex {
        case 0:
            calculation(bill: bill, tipercentage: 0.15)
        case 1:
            calculation(bill: bill, tipercentage: 0.18)
        case 2:
            calculation(bill: bill, tipercentage: 0.2)
        default:
            break
        }
        blTxField.text = "$" + text
        
    }
    

}

