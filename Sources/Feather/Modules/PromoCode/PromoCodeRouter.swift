//
//  PromoCodeRouter.swift
//  PromoCode
//
//  Created by Joseph Lord on 10/01/2021.
//

import FeatherCore

final class PromoCodeRouter: ViperRouter {

//    let controller = PromoCodeFrontendController()

    let offerAdmin = PromoOfferAdminController()
    //let offerApi = PromoOfferApiController()
    
    func adminRoutesHook(args: HookArguments) {
        let routes = args["routes"] as! RoutesBuilder

        let modulePath = routes.grouped(PromoCodeModule.pathComponent)

        offerAdmin.setupRoutes(on: modulePath, as: PromoOfferModel.pathComponent)
        
    }

    
//    func publicApiRoutesHook(args: HookArguments) {
//        let routes = args["routes"] as! RoutesBuilder
//        
//        let modulePath = routes.grouped(PromoCodeModule.pathComponent)
//
//        let offerPath = modulePath.grouped(PromoOfferModel.pathComponent)
//        offerApi.setupGetRoute(on: offerPath)
//    }
}
