//
//  ShareSheetView.swift
//  
//
//  Created by Alex Nagy on 28.02.2021.
//

import SwiftUI

public struct ShareSheetView: UIViewControllerRepresentable {
    public typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    private var activityItems: [Any]
    private var applicationActivities: [UIActivity]? = nil
    private var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    private var callback: Callback? = nil
    
    /// Share Sheet View
    /// - Parameters:
    ///   - activityItems: activity items
    ///   - applicationActivities: application activities
    ///   - excludedActivityTypes: excluded activities
    ///   - callback: Callback
    public init(activityItems: [Any],
                applicationActivities: [UIActivity]? = nil,
                excludedActivityTypes: [UIActivity.ActivityType]? = nil,
                callback: Callback? = nil) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        self.excludedActivityTypes = excludedActivityTypes
        self.callback = callback
    }
    
    public func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}
