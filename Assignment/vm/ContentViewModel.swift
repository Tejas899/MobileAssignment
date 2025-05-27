//
//  ContentViewModel.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation


class ContentViewModel : ObservableObject {
    
    private let apiService = ApiService()
    @Published var navigateDetail: DeviceData? = nil
    @Published var dispalyListdata: [DeviceData] = []
    @Published var actualData: [DeviceData] = []

    @Published var searchText: String = ""

    func fetchAPI() {
        apiService.fetchDeviceDetails(completion: { item in
            Task{
                await MainActor.run {
                    self.actualData = item
                    self.dispalyListdata = item
                }
            }
        })
    }
    
    func navigateToDetail(navigateDetail: DeviceData) {
        self.navigateDetail = navigateDetail
    }
}
