//
//  File.swift
//  
//
//  Created by Joseph on 24/01/2021.
//

import Vapor
import Fluent

final class PromoCodeTakeCodeController {

    func setupGetRoute(on builder: RoutesBuilder) {
        let fullBuilder = builder.grouped("code").grouped(":offerName")
        
        fullBuilder.get("take", use: get)
    }
    
    func get(to request: Request) -> EventLoopFuture<PromoCodeOffer> {
        let name = request.parameters.get("offerName") ?? ""
        return request.db.transaction { db in
            PromoOfferModel.query(on: db)
                .filter(\.$name == name)
                .first()
                .unwrap(or: Vapor.Abort(.notFound))
                .map { _ in PromoCodeOffer(code: "abc", offerName: "Dummy offer", offerDescription: "Offer description", offerExpiry: Date()) }
//                .map { Response(headers: ["content-type":"application/json"], body: Response.Body())}
        }
    }
}
