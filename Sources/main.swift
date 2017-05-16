import Kitura

import HeliumLogger
import LoggerAPI

import Glibc
srand(UInt32(time(nil)))

// Setup logger
HeliumLogger.use(.info)

// Create salutations
let salutations: [String] = [
    "Your most humble servant and most faithful friend,",
    "Adieu! take care of yourself; and, I entreat you, write!",
    "Your old friend and erstwhile companion,",
    "May your doom be other than mine, and your treasure remain with you to the end!",
    "A thousand greetings, etc.",
    "A tender adieu.",
    "Peace out."
]

// Create logging middleware
class RequestLogger: RouterMiddleware {
    public func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        Log.info("\(request.method) request made for \(request.originalURL)")
        next()
    }
}

// Create a new router
let router = Router()

// Setup middleware
router.all("/*", middleware: RequestLogger())

// Return a random salutation
router.get("/") { request, response, next in
    let idx = Int(random() % salutations.count)
    response.send(json: ["text": salutations[idx]])
    next()
}

// Resolve the port that we want the server to listen on
let port: Int
let defaultPort = 80
if let requestedPort = ProcessInfo.processInfo.environment["PORT"] {
    port = Int(requestedPort) ?? defaultPort
} else {
    port = defaultPort
}

// Add an HTTP server and connect it to the router
Kitura.addHTTPServer(onPort: port, with: router)

// Start the Kitura runloop (this call never returns)
Kitura.run()
