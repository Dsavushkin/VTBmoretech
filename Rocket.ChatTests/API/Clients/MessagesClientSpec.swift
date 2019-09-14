//
//  MessagesClientSpec.swift
//  Rocket.ChatTests
//
//  Created by Matheus Cardoso on 12/7/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import XCTest
import SwiftyJSON
import RealmSwift

@testable import Rocket_Chat

class MessagesClientSpec: XCTestCase {

    override func tearDown() {
        super.tearDown()
        Realm.clearDatabase()
    }

    func testSendMessage() {
        let api = MockAPI()
        let client = MessagesClient(api: api)

        api.nextResult = JSON([
            "success": true,
            "message": [
                "mentions": [],
                "_id": "a43SYFpMdjEAdM0mrH",
                "_updatedAt": "2017-12-07T12:30:38.384Z",
                "channels": [],
                "rid": "GENERAL",
                "u": [
                    "name": "Matheus Cardoso",
                    "username": "matheus.cardoso",
                    "_id": "ERoZg2xpgcDnXbCJu"
                ],
                "ts": "2017-12-07T12:30:38.382Z",
                "msg": "Test"
            ]
        ])

        let user = User.testInstance()
        let subscription = Subscription.testInstance()
        subscription.rid = "GENERAL"

        guard let subscriptionUnmanaged = subscription.unmanaged else {
            XCTFail("realm could not be instantiated")
            return
        }

        client.sendMessage(text: "test", subscription: subscriptionUnmanaged, id: "a43SYFpMdjEAdM0mrH", user: user)

        if let message = Realm.current?.objects(Message.self).first {
            XCTAssertNotNil(message)
            XCTAssertFalse(message.temporary)
        } else {
            XCTFail("message was not created")
        }
    }

    func testUpdateMessage() {
        let api = MockAPI()
        let realm = Realm.current
        let client = MessagesClient(api: api)

        let message = Message.testInstance()
        message.identifier = "message-identifier"

        Realm.execute({ realm in
            realm.add(message)
        })

        api.nextResult = JSON([
            "success": true,
            "message": [
                "_id": "message-identifier",
                "rid": "GENERAL",
                "msg": "edit-test",
                "ts": "2017-01-05T17:06:14.403Z",
                "u": [
                    "_id": "R4jgcQaQhvvK6K3iY",
                    "username": "graywolf336"
                ],
                "_updatedAt": "2017-01-05T19:42:20.433Z",
                "editedAt": "2017-01-05T19:42:20.431Z",
                "editedBy": [
                    "_id": "R4jgcQaQhvvK6K3iY",
                    "username": "graywolf336"
                ]
            ]
        ])

        client.updateMessage(message, text: "edit-test")
        XCTAssertEqual(realm?.objects(Message.self).first?.text, "edit-test")
    }

    func testReactMessage() {
        let api = MockAPI()
        let client = MessagesClient(api: api)

        let user = User.testInstance()
        user.name = "rocket.cat"
        let message = Message()
        let rawMessage = JSON([
            "_id": "9F4WZaNq28ZSr34R5",
            "_updatedAt": [
                "$date": 1522943762375
            ],
            "rid": "2B6NWL88MoijfZswt",
            "u": [
                "name": "John Appleseed",
                "username": "john.appleseed",
                "_id": "cBD6dHc7oBvGjkruM"
            ],
            "reactions": [
                ":grin:": [
                    "usernames": [
                        "john.appleseed"
                    ]
                ]
            ],
            "ts": [
                "$date": 1522868268925
            ],
            "msg": "The quick brown fox jumped over the lazy dog"
        ])
        message.map(rawMessage, realm: nil)

        message.identifier = "message-identifier"

        Realm.execute({ realm in
            realm.add(message)
        })

        let result = client.reactMessage(message, emoji: ":grin:", user: user)

        XCTAssert(result, "react method accepts parameters")
        XCTAssert(message.reactions.count == 1, "reaction count remains one after adding to existing reaction")
        XCTAssert(message.reactions[0].usernames.count == 2, "reaction username count increases by one after adding to existing reaction")

        client.reactMessage(message, emoji: ":party_parrot:", user: user)

        XCTAssert(message.reactions.count == 2, "reaction count remains one after adding new reaction")
        XCTAssert(message.reactions[1].usernames.count == 1, "reaction username count is one after adding new reaction")

        client.reactMessage(message, emoji: ":party_parrot:", user: user)

        XCTAssert(message.reactions.count == 1, "reaction count decreases by one after removing reaction")
    }
}
