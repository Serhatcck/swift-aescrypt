//
//  ContentView.swift
//  aescrypt
//
//  Created by Serhat Çiçek on 10.07.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var plainText = ""
    @State private var encryptedText = "12312"
    
    @State private var password = "foo"
    @State private var salt = AES256.randomSalt()
    
    //For Encrypt
    @State private var static_iv = Data()
    @State private var static_secret =  Data()
    
    
    //For Random Encrpyt
    @State private var dynamic_iv = Data()
    @State private var dynamic_secret = Data()
    
    var body: some View {
        VStack(spacing:30){
            HStack{
            TextEditor(text:$plainText)
                .frame(height: 120.0)
                .border(Color.gray,width: 1)
                .padding()
                
                
            }
            HStack{
                TextEditor(text:$encryptedText)
                    .frame(height: 120.0)
                    .border(Color.gray,width: 1)
                    .padding()
                    
            }
            HStack{
                
                Button(action:{
                    self.encryptWithRandom()
                }){
                    Text("RANDOM KEY ENCRYPT")
                }
                .padding()
                .border(Color.black,width: 1)
                    
                
                
                Button(action:{
                    self.encrypt()
                }){
                    Text("ENCRYPT")
                }
                .padding()
                .border(Color.black,width: 1)
            }
           
        }
    }
    
    private func encrypt(){
        if static_iv.isEmpty && static_secret.isEmpty{
            do{
                static_iv = AES256.randomIv()
                //Create Secret key with salt
                static_secret =  try AES256.createKey(password: password.data(using: .utf8)!, salt: salt)
            }catch{
                print(error)
            }
        }
        self.coreEncrypt(secret:static_secret,iv:static_iv)
       
    }
    private func encryptWithRandom(){
        do{
            dynamic_iv = AES256.randomIv()
            //Create Secret key with salt
            dynamic_secret =  try AES256.createKey(password: password.data(using: .utf8)!, salt: salt)
        }catch{
            print(error)
        }
        self.coreEncrypt(secret:dynamic_secret,iv:dynamic_iv)
    }
    
    private func coreEncrypt(secret:Data,iv:Data){
        do{
            //Create aes object
            let aes = try AES256(key: secret, iv: iv)
            
            //Encrypt digest
            let encrypted = try aes.encrypt(plainText.data(using: .utf8)!)
            
            encryptedText = encrypted.base64EncodedString()
        }catch{
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
