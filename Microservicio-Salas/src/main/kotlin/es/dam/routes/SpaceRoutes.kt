package es.dam.routes

import es.dam.dto.SpaceCreateDTO
import es.dam.dto.SpaceDataDTO
import es.dam.dto.SpaceUpdateDTO
import es.dam.exceptions.SpaceException
import es.dam.mappers.toModel
import es.dam.mappers.toSpaceDto
import es.dam.models.Space
import es.dam.services.SpaceServiceImpl
import io.ktor.http.*
import io.ktor.server.application.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import org.koin.core.qualifier.named
import org.koin.ktor.ext.inject
import org.litote.kmongo.toId


fun Application.spaceRoutes() {
    val spaceService: SpaceServiceImpl by inject(named("SpaceServiceImpl"))

    routing {
        get("/") {
            call.respondText("Hello World!")
        }

        get("/spaces") {
            val response = SpaceDataDTO(
                data = spaceService.getAllSpaces().map { it.toSpaceDto() },
            )
            call.respond(response)
        }

        get("/spaces/{id}") {
            try{
                val id = call.parameters["id"]
                id?.let { spaceService.getSpaceById(it).let { it1 -> call.respond(it1) } }
            }catch(e: SpaceException){
                call.respond(HttpStatusCode.NotFound, "No se ha encontrado el espacio con ese id")
            } catch(e: Exception){
                call.respond(HttpStatusCode.BadRequest, "El id debe ser un id válido")
            }
        }

        get("/spaces/reservables/{isReservable}") {
            val isReservable = call.parameters["isReservable"]
            try{
                isReservable?.let { spaceService.getAllSpacesReservables(it.toBoolean()).let { it1 -> call.respond(it1) } }
            }catch (e: SpaceException){
                call.respond(HttpStatusCode.NotFound, "No se ha encontrado ningun espacio reservable = $isReservable")
            }catch (e: Exception){
                call.respond(HttpStatusCode.BadRequest, "El parametro reservable debe ser true o false")
            }
        }

        get("/spaces/nombre/{name}") {
            val name = call.parameters["name"]
            try{
                name?.let { spaceService.getSpaceByName(it).let { it1 -> call.respond(it1) } }
            } catch (e: SpaceException){
                call.respond(HttpStatusCode.NotFound, "No se ha encontrado el espacio con el nombre: $name")
            } catch (e: Exception){
                call.respond(HttpStatusCode.BadRequest, "El parametro name debe ser una cadena de caracteres")
            }
        }

        post("/spaces") {
            val space = call.receive<SpaceCreateDTO>()
            try {
                spaceService.createSpace(space.toModel()).let { call.respond(it) }
            } catch (e: Exception) {
                call.respond(HttpStatusCode.BadRequest, "No se ha podido crear el espacio")
            }
        }

        put("/spaces/{id}") {
            val id = call.parameters["id"]
            val space = call.receive<SpaceUpdateDTO>()
            try {
                spaceService.updateSpace(space.toModel(), id!!).let { call.respond(it) }
            } catch (e: SpaceException) {
                call.respond(HttpStatusCode.NotFound, "No se ha encontrado el espacio con el id: $id")
            } catch (e: Exception){
                call.respond(HttpStatusCode.BadRequest, "El parametro id debe ser un id valido")
            }
        }

        delete("/spaces/{id}") {
            val spaceId = call.parameters["id"]
            try{
                spaceId!!.let { spaceService.deleteSpace(it).let { call.respond(HttpStatusCode.NoContent) } }
            }catch (e: SpaceException){
                call.respond(HttpStatusCode.NotFound, "No se ha borrar el espacio con el id: $spaceId")
            } catch (e: Exception){
                call.respond(HttpStatusCode.NotFound, "El parametro id debe ser un id valido")
            }
        }
    }
}