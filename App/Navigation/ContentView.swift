/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The app's root view.
*/

import SwiftUI
import FoodTruckKit

/// The root view in Food Truck.
///
/// This view is the root view in ``FoodTruckApp``'s scene.
/// On macOS, and iPadOS it presents a split navigation view, while on iOS devices it presents a navigation stack, as the main interface of the app.
struct ContentView: View {
    /// The app's model that the containing scene passes in.
    @ObservedObject var model: FoodTruckModel
    /// The in-app store state that the containing scene passes in.
    @ObservedObject var accountStore: AccountStore
    
    @State private var selection: Panel? = Panel.truck
    @State private var path = NavigationPath()

    #if os(iOS)
    @Environment(\.displayStoreKitMessage) private var displayStoreMessage
    @Environment(\.scenePhase) private var scenePhase
    #endif

    /// The view body.
    ///
    /// This view embeds a [`NavigatationSplitView`](https://developer.apple.com/documentation/swiftui/navigationsplitview),
    /// which displays the ``Sidebar`` view in the
    /// left column, and a [`NavigatationStack`](https://developer.apple.com/documentation/swiftui/navigationstack)
    /// in the detail column, which consists of ``DetailColumn``, on macOS and iPadOS.
    /// On iOS the [`NavigatationSplitView`](https://developer.apple.com/documentation/swiftui/navigationsplitview)
    /// display a navigation stack with the ``Sidebar`` view as the root.
    var body: some View {
        NavigationSplitView {
            Sidebar(selection: $selection)
        } detail: {
            NavigationStack(path: $path) {
                DetailColumn(selection: $selection, model: model)
            }
        }
        .onChange(of: selection) { _ in
            path.removeLast(path.count)
        }
        .environmentObject(accountStore)
        #if os(macOS)
        .frame(minWidth: 600, minHeight: 450)
        #elseif os(iOS)
        .onChange(of: scenePhase) { newValue in
            // If this view becomes active, tell the Messages manager to display
            // store messages in this window.
            if newValue == .active {
                StoreMessagesManager.shared.displayAction = displayStoreMessage
            }
        }
        .onPreferenceChange(StoreMessagesDeferredPreferenceKey.self) { newValue in
            StoreMessagesManager.shared.sensitiveViewIsPresented = newValue
        }
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    struct Preview: View {
        @StateObject private var model = FoodTruckModel()
        @StateObject private var accountStore = AccountStore()
        var body: some View {
            ContentView(model: model, accountStore: accountStore)
        }
    }
    static var previews: some View {
        Preview()
    }
}
