//
//  Event.swift
//  Clique
//
//  Created by Infinum on 15.11.2022..
//

import Foundation

struct Event: Codable {
    let eventID: Int
    let eventName: String
    let eventLocation: String
    let eventTimestamp: String
    let eventParticipantNumber: Int
    let eventCost: Double?
    let eventCurrency: String?
    let eventCreator: Creator
    let eventCategory: String
    let eventDescription: String?
    
    enum CodingKeys: String, CodingKey {
            case eventID = "event_id"
            case eventName = "event_name"
            case eventLocation = "event_location"
            case eventTimestamp = "event_timestamp"
            case eventParticipantNumber = "participants_no"
            case eventCost = "cost"
            case eventCurrency = "currency"
            case eventCreator = "creator"
            case eventCategory = "category"
            case eventDescription = "description"
    }
  
}



/**struct Event: Codable {
    let eventID: String
    let eventName: String
    let eventImage: String
    let eventType: Bool
    let eventPreparation: String
    
}



extension Event {

    static let datasource: [Event] = [
        Event(
            eventID: "1106",
            eventName: "Margarita",
            eventImage: "https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg",
            eventType: true,
            eventPreparation: "Rub the rim of the glass with the lime slice to make the salt stick to it. Take care to moisten only the outer rim and sprinkle the salt on it. The salt should present to the lips of the imbiber and never mix into the cocktail. Shake the other ingredients with ice, then carefully pour into the glass."
        ),
        Event(
            eventID: "17196",
            eventName: "Cosmopolitan",
            eventImage: "https://www.thecocktaildb.com/images/media/drink/kpsajh1504368362.jpg",
            eventType: true,
            eventPreparation: "Add all ingredients into cocktail shaker filled with ice. Shake well and double strain into large cocktail glass. Garnish with lime wheel."
        ),
        Event(
            eventID: "12362",
            eventName: "Tequila Fizz",
            eventImage: "https://www.thecocktaildb.com/images/media/drink/2bcase1504889637.jpg",
            eventType: true,
            eventPreparation: "Shake all ingredients (except ginger ale) with ice and strain into a collins glass over ice cubes. Fill with ginger ale, stir, and serve."
        ),
        Event(
            eventID: "13621",
            eventName: "Tequila Sunrise",
            eventImage: "https://www.thecocktaildb.com/images/media/drink/5noda61589575158.jpg",
            eventType: true,
            eventPreparation: "Pour the tequila and orange juice into glass over ice. Add the grenadine, which will sink to the bottom. Stir gently to create the sunrise effect. Garnish and serve."
        ),
        Event(
            eventID: "11410",
            eventName: "Gin Fizz",
            eventImage: "https://www.thecocktaildb.com/images/media/drink/drtihp1606768397.jpg",
            eventType: true,
            eventPreparation: "Shake all ingredients with ice cubes, except soda water. Pour into glass. Top with soda water."
        ),
    ]
}**/
