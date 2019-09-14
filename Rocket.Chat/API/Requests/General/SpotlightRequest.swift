//
//  SpotlightRequest.swift
//  Rocket.Chat
//
//  Created by Matheus Cardoso on 9/18/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//
//  DOCS: https://rocket.chat/docs/developer-guides/rest-api/spotlight/

import SwiftyJSON

final class SpotlightRequest: APIRequest {
    typealias APIResourceType = SpotlightResource

    let version = Version(0, 61, 0)
    let path = "/api/v1/spotlight"

    let query: String?

    init(query: String) {
        if let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            self.query = "query=\(encodedQuery)"
        } else {
            self.query = ""
        }
    }
}

final class SpotlightResource: APIResource {
    var users: [JSON] {
        return raw?["users"].arrayValue ?? []
    }

    var rooms: [JSON] {
        return raw?["rooms"].arrayValue ?? []
    }

    var success: Bool {
        return raw?["success"].boolValue ?? false
    }

    var error: String {
        return raw?["error"].stringValue ?? ""
    }
}
