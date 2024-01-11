//
//  ContentView.swift
//  FIndMyAppTestProject
//
//  Created by Narendran Elumalai on 11/01/24.
//

import SwiftUI

public struct FindMyIPView: View {
    
    @StateObject var getIPViewModel:GetIPViewModel = GetIPViewModel(networking: NetworkManager())
    
    @State var showNetworkView = false

    @StateObject var networkMonitor: NetworkMonitor = NetworkMonitor()

    public init(){
        
    }
    
    public var body: some View {
        NavigationView {
            
            if !showNetworkView{
                ZStack{
                    switch getIPViewModel.state {
                    case .initial:
                        idleView()
                    case .loading:
                        ProgressView()
                            .tint(Color.blue)
                    case .failed(let error):
                        ErrorView(error: error) {
                            if networkMonitor.isConnected {
                                self.getIPViewModel.state = .initial
                                showNetworkView = false
                            }
                        }
                    case .success:
                        successView()
                        
                    }
                }
                .navigationTitle("IP Details")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if self.getIPViewModel.state != .initial{
                            Button {
                                self.getIPViewModel.state = .initial
                            } label: {
                                HStack {
                                    Image(systemName: "chevron.backward")
                                }
                            }
                        }
                        
                    }
                }
            }else{
                NetworkErrorView {
                    if networkMonitor.isConnected {
                        self.getIPViewModel.state = .initial
                        showNetworkView = false
                    }
                }
            }
            
            
        }
    }
    
    
    func successView() -> some View{
        
        ZStack{
            
            if let response = self.getIPViewModel.getIPAPIResponse{
                ScrollView{
                    
                    LazyVStack(alignment: .leading){
                        
                        CustomFieldsView(key: "IP", value: response.ip)
                        
                        CustomFieldsView(key: "Network", value: response.network)
                        
                        CustomFieldsView(key: "Org", value: response.org)
                        
                        CustomFieldsView(key: "ASN", value: response.asn)
                        
                        CustomFieldsView(key: "Languages", value: response.languages)
                        
                        CustomFieldsView(key: "TimeZone", value: response.timezone)
                        
                        CustomFieldsView(key: "UTC Offset", value: response.utcOffset)
                        
                        CustomFieldsView(key: "Lattitude", value: response.latitude)
                        
                        CustomFieldsView(key: "Longintude", value: response.longitude)
                        
                        CustomFieldsView(key: "City", value: response.city)
                        
                        CustomFieldsView(key: "Country", value: response.country)
                        
                        CustomFieldsView(key: "Country Code", value: response.countryCode)
                        
                        CustomFieldsView(key: "Country Name", value: response.countryName)
                        
                        CustomFieldsView(key: "Country Capital", value: response.countryCapital)
                        
                        CustomFieldsView(key: "Country TLD", value: response.countryTLD)
                        
                        CustomFieldsView(key: "Country Calling Code", value: response.countryCallingCode)
                        
                        CustomFieldsView(key: "Country Area", value: response.countryArea)
                        
                        CustomFieldsView(key: "Country Population", value: response.countryPopulation)
                        
                        CustomFieldsView(key: "Postal", value: response.postal)
                        
                        
                        CustomFieldsView(key: "Region", value: response.region)
                        
                        CustomFieldsView(key: "Region Code", value: response.regionCode)
                        
                        CustomFieldsView(key: "inEu", value: response.inEu)
                        
                        
                        Spacer()
                        
                    }
                }
            }else{
                noDataView()
            }
        }
    }
    
    
    func noDataView() -> some View{
        VStack{
            Spacer()
            Text("No Data")
            Spacer()
        }
    }
    
    
    
    func idleView() -> some View{
        
        VStack{
            
            Text("Check Your IP Details")
                .font(.headline)          
                .foregroundColor(.black)
                .padding(.bottom,5)
          
            Button {
                if networkMonitor.isConnected {
                    getIPViewModel.getIpAPI()
                }else{
                    showNetworkView = true
                }
            } label: {
                ZStack(alignment: .center) {
                    Text("Get Here")
                        .font(.customFont(fontWeight: .regular, fontSize: 16))
                        .foregroundColor(.white)
                }
                .padding([.leading, .trailing])
                .frame(width:200, height: 50, alignment: .center)
                .background(Color.blue)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 0.5)
                        .stroke(Color(red: 0, green: 0.1, blue: 0.26).opacity(0.08), lineWidth: 1)
                )
            }
        }
    }
    
    
    
    func CustomFieldsView<T: CustomStringConvertible>(key: String, value: T?) -> some View {
        HStack {
            Text("\(key):")
                .font(.customFont(fontWeight: .bold, fontSize: 20))
            Text(value?.description ?? "-")
                .font(.customFont(fontWeight: .medium, fontSize: 15))
        }
        .padding(8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding()
    }
}

#Preview {
    FindMyIPView()
}
