//
//  ContentView.swift
//  Assignment
//
//  Created by Kunal on 03/01/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    @State private var path: [DeviceData] = [] // Navigation path
    var offlineText: String{
        Reachability.isConnectedToNetwork() ? "" : "(Offline)"
    }
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !viewModel.dispalyListdata.isEmpty {
                    DevicesList(devices: viewModel.dispalyListdata) { selectedComputer in
                        viewModel.navigateToDetail(navigateDetail: selectedComputer)
                    }
                } else {
                    ProgressView("Loading...")
                }
            }
            .onChange(of: viewModel.navigateDetail, {
                let navigate = viewModel.navigateDetail
                path.append(navigate!)
            })
            .navigationTitle("Devices \(offlineText)")
            .navigationDestination(for: DeviceData.self) { computer in
                DetailView(device: computer)
            }
            .onAppear {
                viewModel.fetchAPI()
            }
        }
        .searchable(text: $viewModel.searchText)
        .onChange(of: viewModel.searchText) { oldValue, newValue in
            self.viewModel.updateSearchResult()
        }
    }
}
