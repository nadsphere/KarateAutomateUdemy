package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._
import conduitApp.performance.createTokens.CreateTokens

class PerfTest extends Simulation {

  CreateTokens.createAccessTokens()

  val protocol = karateProtocol(
    "/api/articles/{articleId}"-> Nil
  )

  protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")

  // val csvFeeder = csv("articles.csv").shuffle
  val tokenFeeder = Iterator.continually {
    Map("token" -> CreateTokens.getNextToken)
  }
  val createArticle = scenario("Create and Delete Article")
      // .feed(csvFeeder)
      .feed(tokenFeeder)
      .exec(karateFeature("classpath:conduitApp/performance/createArticle.feature"))

  setUp(
    createArticle.inject(
        atOnceUsers(1),
        // Add Open Model
        nothingFor(4),
        constantUsersPerSec(1).during(3),  // user ketika create article maupun delete
        constantUsersPerSec(2).during(10),
        rampUsersPerSec(2).to(10).during(20), // bikin load skenario
        nothingFor(5),
        constantUsersPerSec(1).during(5) // also use ".seconds"
    ).protocols(protocol)
  )

}