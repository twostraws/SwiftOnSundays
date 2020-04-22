import Routing
import Vapor

/// Register your application's routes here.
///
/// [Learn More →](https://docs.vapor.codes/3.0/getting-started/structure/#routesswift)
public func routes(_ router: Router) throws {
    router.get { req -> Future<View> in
        struct PageData: Content {
            var cupcakes: [Cupcake]
            var orders: [Order]
        }

        let cakes = Cupcake.query(on: req).all()
        let orders = Order.query(on: req).all()

        return flatMap(to: View.self, cakes, orders) { cakes, orders in
            let context = PageData(cupcakes: cakes, orders: orders)
            return try req.view().render("home", context)
        }
    }

    router.post(Cupcake.self, at: "add") { req, cupcake -> Future<Response> in
        return cupcake.save(on: req).map(to: Response.self) { cupcake in
            return req.redirect(to: "/")
        }
    }

    router.get("cupcakes") { req -> Future<[Cupcake]> in
        return Cupcake.query(on: req).sort(\.name).all()
    }

    router.post(Order.self, at: "order") { req, order -> Future<Order> in
        var orderCopy = order
        orderCopy.date = Date()
        return orderCopy.save(on: req)
    }
}
