//
//  HKUI.swift
//  PanicPulse
//
//  Created by Caitlyn Brown on 3/18/24.
//

import SwiftUI
import HealthKitUI


struct HKUI: View {
    @State var authenticated = false
    @State var trigger = false
    
    let healthStore = HKHealthStore()
    // Create the HealthKit data types your app
    // needs to read and write.
    let allTypes: Set = [
        HKQuantityType.workoutType(),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.distanceCycling),
        HKQuantityType(.distanceWalkingRunning),
        HKQuantityType(.distanceWheelchair),
        HKQuantityType(.heartRate)
    ]

    var body: some View {
        Button("Access health data") {
            // OK to read or write HealthKit data here.
        }
        .disabled(!authenticated)
        
        // If HealthKit data is available, request authorization
        // when this view appears.
        .onAppear() {
            
            // Check that Health data is available on the device.
            if HKHealthStore.isHealthDataAvailable() {
                // Modifying the trigger initiates the health data
                // access request.
                trigger.toggle()
            }
        }
        
        // Requests access to share and read HealthKit data types
        // when the trigger changes.
        .healthDataAccessRequest(store: healthStore,
                                 shareTypes: allTypes,
                                 readTypes: allTypes,
                                 trigger: trigger) { result in
            switch result {
                
            case .success(_):
                authenticated = true
            case .failure(let error):
                // Handle the error here.
                fatalError("*** An error occurred while requesting authentication: \(error) ***")
            }
        }
    }
}
#Preview {
    HKUI()
}
