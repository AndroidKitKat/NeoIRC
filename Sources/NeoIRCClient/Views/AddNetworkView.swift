//
//  AddNetworkView.swift
//  Danshou IRC
//
//  Created by skg on 6/28/21.
//  Copyright © 2021 Mike Eisemann. All rights reserved.

//

import SwiftUI
import IRC

struct AddNetworkView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var serviceManager: IRCServiceManager
    
    var randomNickNumber: String
    
    // Network Information
    @State private var newNetworkName: String = ""
    @State private var newNetworkAddress: String = ""
    @State private var newNetworkPort: String = ""
    @State private var newNetworkUseSSL: Bool = true
    @State private var newNetworkPassword: String = ""
    @State private var newNetworkAutoconnect: Bool = true
    
    // Identity Information
    @State private var newNetworkNick: String = ""
    @State private var newNetworkUsername: String = ""
    @State private var newNetworkRealName: String = ""
    @State private var newNetworkPersonalPassword: String = ""
    @State private var newNetworkWaitForAuth: Bool = false
    
    var saveDisabled: Bool {
        return (newNetworkName.isEmpty || newNetworkAddress.isEmpty) || !newNetworkPort.isInt
    }
    
    var serverPort: String {
        return newNetworkUseSSL ? "6697" : "6667"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Cool IRC Network", text: $newNetworkName)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Address")
                        Spacer()
                        TextField("irc.example.com", text: $newNetworkAddress)
                            .multilineTextAlignment(.trailing)
                            .autocapitalization(.none)
                    }
                    HStack {
                        Text("Port")
                        Spacer()
                        TextField("\(serverPort)", text: $newNetworkPort)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    Toggle("Secure Connection", isOn: $newNetworkUseSSL)
                    HStack {
                        Text("Password")
                        Spacer()
                        SecureField("p4ssw0rd", text: $newNetworkPassword)
                            .multilineTextAlignment(.trailing)
                            .autocapitalization(.none)
                    }
                    Toggle("Autoconnect", isOn: $newNetworkAutoconnect)
                }
                Section(header: Text("Identity"), footer: Text("Danshou will wait for NickServ or SASL authentication before joining channels")) {
                    HStack {
                        Text("Nickname")
                        Spacer()
                        TextField("Guest\(randomNickNumber)", text: $newNetworkNick)
                            .multilineTextAlignment(.trailing)
                            .autocapitalization(.none
                            )
                    }
                    HStack {
                        Text("Username")
                        Spacer()
                        TextField("danshou", text: $newNetworkUsername)
                            .multilineTextAlignment(.trailing)
                            .autocapitalization(.none)
                    }
                    HStack {
                        Text("Real name")
                        Spacer()
                        TextField("Danshou User", text: $newNetworkRealName)
                            .multilineTextAlignment(.trailing)
                            .autocapitalization(.words)
                    }
                    HStack {
                        Text("Password")
                        Spacer()
                        SecureField("NickServ or SASL", text: $newNetworkPersonalPassword)
                            .multilineTextAlignment(.trailing)
                            .autocapitalization(.none)
                    }
                    Toggle("Wait for authentication", isOn: $newNetworkWaitForAuth)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationBarTitle("Add network...", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
            })
            .navigationBarItems(trailing: Button(action: {
                print("save network")
                serviceManager.addAccount(IRCAccount(id: UUID(), host: newNetworkAddress, port: Int(newNetworkPort)!, nickname: newNetworkNick, activeRecipients: [ "#danshou" ]))
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "checkmark.circle.fill")
            }
                                    .disabled(saveDisabled))
        }
    }
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
