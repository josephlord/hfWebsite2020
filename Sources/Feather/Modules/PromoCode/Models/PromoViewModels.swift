//
//  File.swift
//  
//
//  Created by Joseph on 13/01/2021.
//

import Vapor
import ViewKit
import FluentSQL

struct PromoCode : Codable {
    var promoCode: String
    var offer: PromoOffer
    
    internal init(promoCode: String, offer: PromoOffer) {
        self.promoCode = promoCode
        self.offer = offer
    }
    
    init(model: PromoCodeModel) {
        self.promoCode = model.code
        self.offer = PromoOffer(model: model.offer)
    }
}

struct PromoOffer : Codable {
    

    var id: UUID?
    var name: String
    var description: String
    var expiry: Date
    var availableCodes: Int
    
    internal init(id: UUID? = nil,
                  name: String,
                  description: String,
                  expiry: Date,
                  availableCodes: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.expiry = expiry
        self.availableCodes = availableCodes
    }
    
    init(model: PromoOfferModel) {
        id = model.id
        name = model.name
        description = model.description
        expiry = model.expiry
        availableCodes = 0 // TODO count offer codes
    }
    
    
}
