//
//  NeoIRCClientView.swift
//  Danshou IRC
//
//  -=-=- Original author & copyright -=-=-
//  Created by Helge Heß on 21.05.20.
//  Copyright © 2020 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

/**
 * The "main page" or "root view".
 */
public struct NeoIRCClientView: View {
    
    @EnvironmentObject private var serviceManager : IRCServiceManager
    
    @State var showingNewNetworkSheet = false
    @State var showingSettingsSheet = false
    @State var showingNewChannelSheet = false
    
    /* https://stackoverflow.com/a/60492031 */
    @State var settingsButtonID = UUID()
    @State var newNetworkButtonID = UUID()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ServerListView()
                .navigationBarTitle("Networks")
            
                .navigationBarItems(leading: Button {
                    showingSettingsSheet.toggle()
                } label: {
                    Image(systemName: "gearshape.fill").foregroundColor(Color.accentColor)
                }).id(settingsButtonID)

                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu {
                            Button(action: {
                                showingNewNetworkSheet.toggle()
                            }) {
                                Label("Add network", systemImage: "network")
                            }

                            Button(action: {
                                showingNewChannelSheet.toggle()
                            }) {
                                Label("Join channel", systemImage: "plus.message.fill")
                            }
                        }
                        label: {
                            Label("Add", systemImage: "plus")
                        }
                    }
                }.id(self.newNetworkButtonID)
            
                .sheet(isPresented: $showingNewNetworkSheet, onDismiss: updateButtonIDs) {
                    AddNetworkView(serviceManager: serviceManager, randomNickNumber: String(Int.random(in: 0...1000)))
                }
                .sheet(isPresented: $showingSettingsSheet, onDismiss: updateButtonIDs) {
                    Text("SETTINGS")
                }
                .sheet(isPresented: $showingNewChannelSheet, onDismiss: updateButtonIDs) {
                    Text("NEW CHANNEL")
                }
        }
    }
    
    private func updateButtonIDs() {
        newNetworkButtonID = UUID()
        settingsButtonID = UUID()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NeoIRCClientView()
            .environmentObject(IRCServiceManager(passwordProvider: ""))
    }
}
