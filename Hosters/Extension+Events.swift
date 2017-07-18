//
//  Extension+Events.swift
//  Tyloo
//
//  Created by Kiarash Teymoury on 7/17/17.
//  Copyright © 2017 Kiarash Teymoury. All rights reserved.
//

import UIKit

enum serError: Error {

    case isMissing(String)
}

extension Events {
    
    func getEventDetailsFrom(_ event: Events) -> (coverURL:String, title:String, hosts:String, details:String, location:String, guestList:String, guestListEnabled:Bool) {
        
        let coverURL = event.coverURL ?? "emptyCover"
        let eventTitle = event.name ?? "No event Title"
        let eventHost = event.owner_name ?? "No Event Hosts ? (Doesnt Make Sence But Ok)"
    
        let eventDetails = event.details ?? "No Details For Event"
        
        let eventLocation = getPlaceName(event)
        let eventGuestList = getEventGuesListFrom(event)
        
        let isGuesListEnabled = event.guest_list_enabled

        return (coverURL, eventTitle, eventHost, eventDetails, eventLocation, eventGuestList, isGuesListEnabled)
    }
    
    fileprivate func getPlaceName(_ event:Events) -> String {
    
        let place_name = "📍\(event.place_name ?? "Place Name Not Available")"
        
        return place_name
    }
    
    fileprivate func getEventGuesListFrom(_ event:Events) -> String {
        
        let interestedCount = event.interested_count
        let declinedCount = event.declined_count
        let attendingCount = event.attending_count
        
        return "✅ Going: \(attendingCount) • 🤔 Interested: \(interestedCount) • ❌ Not Going: \(declinedCount)"
    }
}
