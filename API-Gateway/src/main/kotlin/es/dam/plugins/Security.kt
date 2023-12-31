package es.dam.plugins

import es.dam.config.TokenConfig
import es.dam.services.token.TokensService
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.auth.jwt.*
import io.ktor.server.response.*
import org.koin.core.parameter.parametersOf
import org.koin.ktor.ext.get
import org.koin.ktor.ext.inject

/**
 * Función que configura la seguridad de la aplicación. Permite que se pueda acceder a la API con un token.
 *
 * @author Mireya Sánchez Pinzón
 * @author Alejandro Sánchez Monzón
 * @author Rubén García-Redondo Marín
 */
fun Application.configureSecurity() {
    val tokenConfigParams = mapOf(
        "audience" to environment.config.property("jwt.audience").getString(),
        "secret" to environment.config.property("jwt.secret").getString(),
        "issuer" to environment.config.property("jwt.issuer").getString(),
        "realm" to environment.config.property("jwt.realm").getString()
    )

    val tokenConfig: TokenConfig = get { parametersOf(tokenConfigParams) }

    val jwtService: TokensService by inject()

    authentication {
        jwt {
            verifier(jwtService.verifyJWT())
            realm = tokenConfig.realm
            validate { credential ->
                JWTPrincipal(credential.payload)
            }

            challenge { defaultScheme, realm ->
                call.respond(HttpStatusCode.Unauthorized, "Invalid token")
            }
        }
    }
}