//
//  ViewController.swift
//  localeBMI
//
//  Created by mahmoudkhudairi on 05/12/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var heightLabel: UILabel! {
        didSet {
            heightLabel.text = "height".localized
        }
    }
    @IBOutlet weak var weightLabel: UILabel!{
        didSet {
            weightLabel.text = "weight".localized
        }
    }
    @IBOutlet weak var languageSegmentedControl: UISegmentedControl! {
        didSet {
            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.tintColor]
            languageSegmentedControl.setTitleTextAttributes(titleTextAttributes, for:.normal)
            
            let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
            languageSegmentedControl.setTitleTextAttributes(titleTextAttributes1, for:.selected)
            if let lang = UserDefaults.standard.string(forKey: "CurrentLanguage") {
                switch lang {
                    
                case "en":
                    languageSegmentedControl.selectedSegmentIndex = 1
                case "fr":
                    languageSegmentedControl.selectedSegmentIndex = 2
                case "ar":
                    languageSegmentedControl.selectedSegmentIndex = 0
                default:
                    languageSegmentedControl.selectedSegmentIndex = getIndexFromLocal()
                }
            }else {
                languageSegmentedControl.selectedSegmentIndex = getIndexFromLocal()
            }
            
        }
    }
    @IBOutlet weak var heightTextField: UITextField! {
        didSet {
            heightTextField.inputAccessoryView = setToolBar()
        }
    }
    
    @IBOutlet weak var weightTextField: UITextField!{
        didSet {
            weightTextField.inputAccessoryView = setToolBar()
        }
    }
    @IBOutlet weak var bmiButton: UIButton! {
        didSet {
            bmiButton.setTitle("calculate".localized, for: .normal)
        }
    }
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var bmiDescriptionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        if let lang = UserDefaults.standard.string(forKey: "CurrentLanguage") {
            print("LANG",lang)
            if lang == "ar" {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }else {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
        }
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func getIndexFromLocal() -> Int {
        let lang = Locale.current.languageCode
        switch lang {
        case "en":
            return 1
        case "fr":
            return 2
        case "ar":
            return 0
        default:
            return 1
        }
    }
    func setToolBar() -> UIToolbar {
        let bar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "done".localized, style: .plain, target: self, action: #selector(dismissKeyboard))
        bar.items = [flexSpace,done]
        bar.sizeToFit()
        return bar
    }
    
    @IBAction func calculateBMI(_ sender: Any) {
        if let weightText = weightTextField.text,
           let heightText = heightTextField.text{
            let calculationFormatter = NumberFormatter()
            calculationFormatter.decimalSeparator = heightText.contains("٫") || heightText.contains(",") ? "," : "."
            // making sure to handle "," and "." based on the locale
            if let heightNumber = calculationFormatter.number(from: heightText), let weightNumber = calculationFormatter.number(from: weightText) {
                print("HEllo")
                let height = Double(truncating: heightNumber)
                let weight = Double(truncating: weightNumber)
                let bmi = weight / pow(height,2)
                let displayFormatter = NumberFormatter()
                displayFormatter.maximumFractionDigits = 2
                let bmiString =  displayFormatter.string(from: NSNumber(value: bmi))
                let bmiDescription = getBMIDescription(bmi)
                bmiLabel.text = bmiString
                bmiDescriptionLabel.text = bmiDescription
            }
            
        }else {
            let alert = UIAlertController(title: "error", message: "please add height and weight to continue", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "ok", style: .default) { Action in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func languageChanged(_ sender: UISegmentedControl) {
        if let lang = (sender.titleForSegment(at: sender.selectedSegmentIndex))?.lowercased() {
            UserDefaults.standard.set(lang, forKey: "CurrentLanguage")
            // Update the language by swaping bundle
            Bundle.setLanguage(lang)
            reinstantiateViewController()
        }
    }
    func reinstantiateViewController() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate {
            sceneDelegate.window?.rootViewController = storyboard.instantiateInitialViewController()
        }
    }
    func getBMIDescription(_ bmi:Double) -> String {
        switch bmi {
        case 0...18.4:
            return "underweight".localized
        case 18.5...24.9:
            return "normal".localized
        case 25...30:
            return "overweight".localized
        default:
            return "obese".localized
        }
    }
    
}

