//
//  PromoCodeModel.swift
//  PromoCode
//
//  Created by Joseph Lord on 10/01/2021.
//

import Vapor
import Fluent
import ViperKit

final class PromoOfferModel: ViperModel {
    typealias Module = PromoCodeModule

    static let name = "promo_offers"

    struct FieldKeys {
        static var name: FieldKey { "name" }
        static var description: FieldKey { "description" }
        static var expiry: FieldKey { "expiry" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.name) var name: String
    @Field(key: FieldKeys.description) var description: String
    @Field(key: FieldKeys.expiry) var expiry: Date

    init() { }

    init(id: PromoCodeModel.IDValue? = nil,
         name: String,
         description: String,
         expiry: Date)
    {
        self.id = id
        self.name = name
        self.description = description
        self.expiry = expiry
    }
}
