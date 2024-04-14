import HealthKit
import UserNotifications

class HeartRateMonitor {

    let healthStore = HKHealthStore()

    init() {
        // Check if health data is available
        if HKHealthStore.isHealthDataAvailable() {
            // Request authorization to read heart rate data
            let typesToRead: Set<HKObjectType> = [HKObjectType.quantityType(forIdentifier: .heartRate)!]
            healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
                if !success {
                    // Handle error
                    print("Error: \(error?.localizedDescription ?? "Unknown")")
                }
            }
        } else {
            // Health data not available on this device
            print("Health data not available")
        }
    }

    func startMonitoringHeartRate() {
        // Create a query to retrieve heart rate data
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let query = HKObserverQuery(sampleType: heartRateType, predicate: nil) { (query, completionHandler, error) in
            if let error = error {
                // Handle error
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Query data successfully
            self.fetchLatestHeartRateSample(completion: { (sample) in
                // Process the heart rate sample
                if let heartRate = sample?.quantity.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) {
                    print("Heart Rate: \(heartRate)")
                    // Check if heart rate exceeds threshold
                    if heartRate > 100 {
                        self.sendNotification()
                    }
                }
            })
        }
        
        // Execute the query
        healthStore.execute(query)
        
        // Add the query to the health store to enable receiving updates
        healthStore.enableBackgroundDelivery(for: heartRateType, frequency: .immediate) { (success, error) in
            if !success {
                // Handle error
                print("Error: \(error?.localizedDescription ?? "Unknown")")
            }
        }
    }

    private func fetchLatestHeartRateSample(completion: @escaping (HKQuantitySample?) -> Void) {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { (query, samples, error) in
            if let error = error {
                // Handle error
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Retrieve the latest heart rate sample
            let heartRateSample = samples?.first as? HKQuantitySample
            completion(heartRateSample)
        }
        
        // Execute the query
        healthStore.execute(query)
    }

    private func sendNotification() {
        // Create and configure the notification content
        let content = UNMutableNotificationContent()
        content.title = "High Heart Rate Detected"
        content.body = "Your heart rate is above 100 bpm."
        content.sound = UNNotificationSound.default
        
        // Create the notification request
        let request = UNNotificationRequest(identifier: "highHeartRateNotification", content: content, trigger: nil)
        
        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

// Example usage

