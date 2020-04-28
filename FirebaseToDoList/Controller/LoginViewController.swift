//
//	ViewController.swift
// 	FirebaseToDoList
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let segueIdentifier = "loginSegue"
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.cornerRadius = 15
        
        // Keyboard settings
        self.addKeyboardHideGesture()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            guard user != nil else { return }
            self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
        }
    }
    
    func clearAllFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func createAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        guard   let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
                createAlert(title: "Empty fields", message: "You must fill in all the fields, try again")
                return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            guard error == nil, user != nil else {
                self?.createAlert(title: "Error", message: error!.localizedDescription)
                return
            }
            self?.performSegue(withIdentifier: (self?.segueIdentifier)!, sender: nil)
            self?.clearAllFields()
        }
    
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, email != "", password != "" else {
                createAlert(title: "Empty fields", message: "You must fill in all the fields, try again")
                return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard error == nil, user != nil else {
                self?.createAlert(title: "Error", message: error!.localizedDescription)
                return
            }
        }
    }
    
    // deinit Notifications
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}

// MARK: - Work with keyboard dismiss
extension LoginViewController: UITextFieldDelegate { 
    
    // Move screen while editing textFields
    @objc func keyboardWillChange (notification: Notification) {
        guard let keyboardRect = (notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        
        if notification.name == UIResponder.keyboardWillShowNotification ||
            notification.name == UIResponder.keyboardWillChangeFrameNotification {
            view.frame.origin.y = -keyboardRect.height / 2
        } else {
            view.frame.origin.y = 0
        }
    }
    
    
    // Keyboard dismiss on some actions
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func addKeyboardHideGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                  action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


