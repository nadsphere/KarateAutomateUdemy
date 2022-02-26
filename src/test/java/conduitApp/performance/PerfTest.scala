package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

class PerfTest extends Simulation {

  val protocol = karateProtocol(
    "/api/articles/{articleId}"-> Nil
  )

  val createArticle = scenario("Create and Delete Article").exec(karateFeature("classpath:conduitApp/performance/createArticle.feature"))

  setUp(
    createArticle.inject(
        atOnceUsers(1),
        // Add Open Model
        nothingFor(4.seconds),
        constantUsersPerSec(1).during(10.seconds),  // user ketika create article maupun delete
        constantUsersPerSec(2).during(10.seconds),
        rampUsersPerSec(2).to(10).during(20.seconds), // bikin load skenario
        nothingFor(5.seconds),
        constantUsersPerSec(1).during(5.seconds) // use ".seconds"
    ).protocols(protocol)
  )

}