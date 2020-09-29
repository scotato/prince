//
//  ContentView.swift
//  Shared
//
//  Created by Scott Dodge on 9/26/20.
//

import SwiftUI

struct ScannerView: View {
    @EnvironmentObject private var model: PrinceModel
    @State private var isShowingScanner = false
    
    var body: some View {
        VStack {
            Text(model.auth ?? "Scan Key")
            Button(action: {
                isShowingScanner = true
            }) {
                Text("Scan API Key")
            }
                .padding()
        }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "F68451F7F711044E6F25445D96978B55", completion: self.handleScan)
            }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            model.storeAuth(code)
        case .failure(let error):
            print("Scanning failed", error)
        }
    }
}

struct ScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
