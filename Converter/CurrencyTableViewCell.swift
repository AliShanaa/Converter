import UIKit
import BEMCheckBox

protocol CurrencyCellDelegate {
    func update(sender name: String, with newValue: Double)
}

protocol CurrencyCellDelegateForCheckBox {
    func add(currency: String)
    func remove(currency: String)
    func updateTableView()
    func makeSearchBarOk()
}

class CurrencyTableViewCell: UITableViewCell {

    var delegate: CurrencyCellDelegate!

    var delegateForCheckBoxActions: CurrencyCellDelegateForCheckBox!

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UITextField!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var checkbox: BEMCheckBox!

    var startEditing = true

    @IBAction func valueEditingDidBegin(_ sender: UITextField) {
        startEditing = true
    }

    @IBAction func valueChanged() {

        if startEditing {
            value.text = String(describing: value.text!.characters.last ?? "0")
            startEditing = false
        }

        guard value.text!.characters.count <= 9 else {
            value.text = value.text!.substring(to: value.text!.index(value.text!.startIndex, offsetBy: 9))
            return
        }

        let newValue = Double(value.text!)

        if newValue != nil {
            delegate.update(sender: name.text!, with: newValue!)
        } else {
            delegate.update(sender: name.text!, with: 0)
        }
    }

    func checkboxValueDidChange() {
        if checkbox.on {
            delegateForCheckBoxActions.add(currency: name.text!)
        } else {
            delegateForCheckBoxActions.remove(currency: name.text!)
        }

        delegateForCheckBoxActions.makeSearchBarOk()
        delegateForCheckBoxActions.updateTableView()
    }
}