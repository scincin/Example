//
//  LoginController.swift
//  FirebaseLoginRegister
//
//  Created by Selahattin on 28/09/2017.
//  Copyright © 2017 Selahattin. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class LoginController: UIViewController {
    
    
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    lazy var facebookLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(#imageLiteral(resourceName: "facebook_btn"), for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
        
        return button
    }()
    //Facebook login control
    @objc func handleFacebookLogin(){
        
    }
    lazy var twitterLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(#imageLiteral(resourceName: "twitter_btn"), for: UIControlState.normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTwitterLogin), for: .touchUpInside)
        
        return button
    }()
    //Facebook login control
    @objc func handleTwitterLogin(){
        
    }
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r:90, g:111, b:171)
        button.setTitle("Kayıt", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor((UIColor.white), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form not valid")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print(error as Any)
                return
            }
            //successfully logged in our user
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.show(withStatus: "Yükleniyor")
            SVProgressHUD.dismiss(withDelay: 1)
            self.dismiss(animated: true, completion: nil)
            
            
        }
    }
    
    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user: User?, error) in
            if error != nil{
                print(error as Any)
                return
            }
            guard let uid = user?.uid else{
                return
            }
            
            /*
             //Firebase data upload
             let strogeRef = Storage.storage().reference().child("profile.png")
             
             if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!){
             strogeRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
             if error != nil {
             print(error as Any)
             return
             }
             print(metadata as Any)
             })
             }
             */
            
            //successfully authenticated user
            let ref = Database.database().reference(fromURL: "https://kartvizitiniyap.firebaseio.com/")
            let usersReferance = ref.child("users").child(uid)
            let values = ["name": name,"email": email]
            
            usersReferance.updateChildValues(values, withCompletionBlock: {(err,ref) in
                
                
                if err != nil {
                    print(err as Any)
                    return
                }
                self.dismiss(animated: true, completion: nil)
                
            })
            
        })
    }
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Kullanıcı adı"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Şifre"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pk1")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Giriş","Kayıt"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
        return sc
    }()
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        // change height of inputContainerView
        inputContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //change height of nameTextField
        nameTextFieldHeigthAnchor?.isActive = false
        nameTextFieldHeigthAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor,multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeigthAnchor?.isActive = true
        
        emailTextFieldHeigthAnchor?.isActive = false
        emailTextFieldHeigthAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor,multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeigthAnchor?.isActive = true
        
        passwordTextFieldHeigthAnchor?.isActive = false
        passwordTextFieldHeigthAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor,multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeigthAnchor?.isActive = true
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61,g: 91,b: 151)
        
        view.addSubview(loginRegisterButton)
        view.addSubview(inputsContainerView)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        //view.addSubview(facebookLoginButton)
        //view.addSubview(twitterLoginButton)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        //setupFacebookLoginButton()
        //setuptwitterLoginButton()
    }
    func setupLoginRegisterSegmentedControl() {
        //need x,y,width, height constrains
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant:-12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor,multiplier: 0.5).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant:36).isActive = true
    }
    func setupProfileImageView() {
        //need x,y,width, height constrains
        profileImageView.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -30).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    var inputContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeigthAnchor: NSLayoutConstraint?
    var emailTextFieldHeigthAnchor: NSLayoutConstraint?
    var passwordTextFieldHeigthAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView() {
        //need x,y,width, height constrains
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        //need x,y,width, height constrains
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeigthAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeigthAnchor?.isActive = true
        //need x,y,width, height constrains
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        //need x,y,width, height constrains
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeigthAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeigthAnchor?.isActive = true
        //need x,y,width, height constrains
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //need x,y,width, height constrains
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeigthAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeigthAnchor?.isActive = true
    }
    func setupLoginRegisterButton() {
        //need x,y,width, height constrains
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: 12).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func setupFacebookLoginButton(){
        //need x,y,width, height constrains
        facebookLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        facebookLoginButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor).isActive = true
        facebookLoginButton.widthAnchor.constraint(equalTo: loginRegisterButton.widthAnchor, constant: -122).isActive = true
        facebookLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    func setuptwitterLoginButton(){
        //need x,y,width, height constrains
        twitterLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        twitterLoginButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 30).isActive = true
        twitterLoginButton.widthAnchor.constraint(equalTo: loginRegisterButton.widthAnchor, constant: -122).isActive = true
        twitterLoginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: 61/255, green: 91/255, blue: 151/255, alpha: 1)
    }
}
extension UIImageView {
    
    func makeRounded() {
        let radius = self.frame.width/2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}



