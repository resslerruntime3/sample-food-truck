/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The Wideget entry point.
*/

import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
    var body: some Widget {
        // MARK: - Accessory Widgets
        #if os(iOS) || os(watchOS)
        OrdersWidget()
        ParkingSpotAccessory()
        #endif
        
        // MARK: - Widgets
        #if os(iOS) || os(macOS)
        DailyDonutWidget()
        #endif
    }
}
 
