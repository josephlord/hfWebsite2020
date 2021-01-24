//
//  PromoCodeFrontendController.swift
//  PromoCode
//
//  Created by Joseph Lord on 10/01/2021.
//

import FeatherCore
import Fluent
import Vapor

final class PromoOfferAdminController : ViperAdminViewController {
    typealias Module = PromoCodeModule
    typealias Model = PromoOfferModel
    typealias CreateForm = PromoOfferEditForm
    typealias UpdateForm = PromoOfferEditForm
    
    var listAllowedOrders: [FieldKey] = [
        Model.FieldKeys.name,
        Model.FieldKeys.expiry,
        "date",
    ]
    
    func listQuery(search: String, queryBuilder: QueryBuilder<PromoOfferModel>, req: Request) {
        queryBuilder.filter(\.$name ~~ search)
    }
    
    func beforeListQuery(req: Request, queryBuilder: QueryBuilder<PromoOfferModel>) -> QueryBuilder<PromoOfferModel> {
        return Model.query(on: req.db)
            .joinMetadata()
            .with(\.$codes)
    }

    func listQuery(order: FieldKey, sort: ListSort, queryBuilder: QueryBuilder<PromoOfferModel>, req: Request) -> QueryBuilder<PromoOfferModel> {
        if order == "expiry" {
            return queryBuilder.sortMetadataByDate(sort.direction)
        }
        return queryBuilder.sort(order, sort.direction)
    }
    
    func beforeListPageRender(page: ListPage<PromoOfferModel>) -> LeafData {
        .dictionary([
            "items": .array(page.items.map(\.leafDataWithJoinedMetadata)),
            "info": page.info.leafData
        ])
    }

    // MARK: - edit
    
//    func findBy(_ id: UUID, on db: Database) -> EventLoopFuture<Model> {
//        Model.findWithCategoriesAndAuthorsBy(id: id, on: db).unwrap(or: Abort(.notFound, reason: "Post not found"))
//    }
    
    internal func findBy(_ id: UUID, on: Database) -> EventLoopFuture<PromoOfferModel> {
        PromoOfferModel.query(on: on)
            .filter(\.$id == id)
            .with(\PromoOfferModel.$codes)
            .first()
            .unwrap(or: Vapor.Abort(.notFound))
    }

    func afterCreate(req: Request, form: CreateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }

    func afterUpdate(req: Request, form: UpdateForm, model: Model) -> EventLoopFuture<Model> {
        findBy(model.id!, on: req.db)
    }
    
    func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
        return model.$codes.query(on: req.db).delete(force: true).map { model }
    }
    
    func exampleView(req: Request) throws -> EventLoopFuture<View> {
        struct Context: Encodable {
            let foo: String
        }
        let context = Context(foo: "This is just an example")
        return req.view.render("PromoCode/Frontend/Example", context)
    }

}
