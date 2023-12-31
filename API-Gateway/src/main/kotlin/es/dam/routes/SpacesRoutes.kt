package es.dam.routes

import es.dam.dto.BookingUpdateDTO
import es.dam.dto.SpaceCreateDTO
import es.dam.dto.SpacePhotoDTO
import es.dam.dto.SpaceUpdateDTO
import es.dam.exceptions.BookingMediaNotSupportedException
import es.dam.exceptions.SpaceBadRequestException
import es.dam.exceptions.SpaceInternalErrorException
import es.dam.exceptions.SpaceNotFoundException
import es.dam.repositories.booking.KtorFitBookingsRepository
import es.dam.repositories.space.KtorFitSpacesRepository
import es.dam.services.token.TokensService
import io.ktor.http.*
import io.ktor.http.content.*
import io.ktor.server.application.*
import io.ktor.server.auth.*
import io.ktor.server.request.*
import io.ktor.server.response.*
import io.ktor.server.routing.*
import io.ktor.utils.io.core.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.RequestBody.Companion.toRequestBody
import org.koin.ktor.ext.inject
import retrofit2.await
import java.time.LocalDateTime
import java.util.*

private const val ENDPOINT = "spaces"

/**
 * Clase que contiene las rutas de la entidad Space
 *
 * @author Mireya Sánchez Pinzón
 * @author Alejandro Sánchez Monzón
 * @author Rubén García-Redondo Marín
 */
fun Application.spacesRoutes() {
    val bookingsRepository : KtorFitBookingsRepository by inject()
    val spacesRepository : KtorFitSpacesRepository by inject()
    val tokenService : TokensService by inject()

    routing {
        route("/$ENDPOINT") {
            authenticate {
                get {
                    try {
                        val token = tokenService.generateToken(call.principal()!!)

                        val res = runCatching {
                            spacesRepository.findAll("Bearer $token")
                        }

                        if (res.isSuccess) {
                            call.respond(HttpStatusCode.OK, res.getOrNull()!!)
                        } else {
                            call.respond(HttpStatusCode.NotFound, "${res.exceptionOrNull()?.message}")
                        }

                    } catch (e: SpaceNotFoundException) {
                        call.respond(HttpStatusCode.NotFound, "${e.message}")
                    }  catch (e: SpaceInternalErrorException) {
                        call.respond(HttpStatusCode.InternalServerError, "${e.message}")
                    }
                }

                get("/{id}") {

                    try {
                        val token = tokenService.generateToken(call.principal()!!)
                        val id = call.parameters["id"]
                        UUID.fromString(id)

                        val space = runCatching {
                            spacesRepository.findById("Bearer $token", id!!)
                        }

                        if (space.isSuccess) {
                            call.respond(HttpStatusCode.OK, space.getOrNull()!!)
                        } else {
                            call.respond(HttpStatusCode.NotFound, "${space.exceptionOrNull()?.message}")
                        }
                    } catch (e: SpaceNotFoundException) {
                        call.respond(HttpStatusCode.NotFound, "${e.message}")
                    } catch (e: SpaceBadRequestException) {
                        call.respond(HttpStatusCode.BadRequest, "${e.message}")
                    } catch (e: SpaceInternalErrorException) {
                        call.respond(HttpStatusCode.InternalServerError, "${e.message}")
                    } catch (e: IllegalArgumentException) {
                        call.respond(HttpStatusCode.BadRequest, "El id debe ser un UUID válido")
                    }
                }

                get("/reservables/{isReservable}") {
                    try {
                        val token = tokenService.generateToken(call.principal()!!)
                        try {
                            call.parameters["isReservable"]!!.toBooleanStrict()
                        } catch (e: IllegalArgumentException) {
                            call.respond(HttpStatusCode.BadRequest, "El parámetro isReservable debe ser un booleano")
                            return@get
                        }
                        val isReservable = call.parameters["isReservable"]!!.toBooleanStrict()

                        val res = runCatching {
                            spacesRepository.findAllReservables("Bearer $token", isReservable)
                        }

                        if (res.isSuccess) {
                            call.respond(HttpStatusCode.OK, res.getOrNull()!!)
                        } else {
                            call.respond(HttpStatusCode.NotFound, "${res.exceptionOrNull()?.message}")
                        }


                    } catch (e: SpaceNotFoundException) {
                        call.respond(HttpStatusCode.NotFound, "${e.message}")
                    } catch (e: SpaceBadRequestException) {
                        call.respond(HttpStatusCode.BadRequest, "${e.message}")
                    } catch (e: SpaceInternalErrorException) {
                        call.respond(HttpStatusCode.InternalServerError, "${e.message}")
                    }
                }

                get("/nombre/{name}") {
                    try {
                        val token = tokenService.generateToken(call.principal()!!)
                        val name = call.parameters["name"]

                        val space = runCatching {
                            spacesRepository.findByName("Bearer $token", name!!)
                        }

                        if (space.isSuccess) {
                            call.respond(HttpStatusCode.OK, space.getOrNull()!!)
                        } else {
                            call.respond(HttpStatusCode.NotFound, "${space.exceptionOrNull()?.message}")
                        }

                    } catch (e: SpaceNotFoundException) {
                        call.respond(HttpStatusCode.NotFound, "${e.message}")
                    } catch (e: SpaceBadRequestException) {
                        call.respond(HttpStatusCode.BadRequest, "${e.message}")
                    } catch (e: SpaceInternalErrorException) {
                        call.respond(HttpStatusCode.InternalServerError, "${e.message}")
                    }
                }

                post {
                    try {
                        val token = tokenService.generateToken(call.principal()!!)
                        val entity = call.receive<SpaceCreateDTO>()
                        val space = runCatching { spacesRepository.create(token,  entity) }

                        if (space.isSuccess) {
                            call.respond(HttpStatusCode.Created, space.getOrNull()!!)
                        } else {
                            call.respond(HttpStatusCode.NotFound, "${space.exceptionOrNull()?.message}")
                        }
                    } catch (e: SpaceNotFoundException) {
                        call.respond(HttpStatusCode.NotFound, "${e.message}")
                    } catch (e: SpaceBadRequestException) {
                        call.respond(HttpStatusCode.BadRequest, "${e.message}")
                    } catch (e: SpaceInternalErrorException) {
                        call.respond(HttpStatusCode.InternalServerError, "${e.message}")
                    }
                }

                post("/storage"){
                    try {
                        val token = tokenService.generateToken(call.principal()!!)
                        val multipart = call.receiveMultipart()
                        var spacePhotoDto: SpacePhotoDTO? = null

                        multipart.forEachPart { part ->
                            println(part.contentType)
                            println(part.contentDisposition)
                            println(part.headers)
                            when (part) {
                                is PartData.FileItem  -> {
                                    val inputStream = part.streamProvider()
                                    val fileBytes = inputStream.readBytes()
                                    val requestBody = fileBytes.toRequestBody("image/png".toMediaTypeOrNull())
                                    val multipartBody = MultipartBody.Part.createFormData("file", "${UUID.randomUUID()}.png", requestBody)
                                    spacePhotoDto = spacesRepository.uploadFile(token, multipartBody).await()
                                }
                                is PartData.BinaryItem -> {
                                    val inputStream = part.provider()
                                    val fileBytes = inputStream.readBytes()
                                    val requestBody = fileBytes.toRequestBody("image/png".toMediaTypeOrNull())
                                    val multipartBody = MultipartBody.Part.createFormData("file", "${UUID.randomUUID()}.png", requestBody)
                                    spacePhotoDto = spacesRepository.uploadFile(token, multipartBody).await()
                                }
                                is PartData.BinaryChannelItem -> {
                                    val inputStream = part.provider()
                                    val fileBytes = inputStream.readRemaining().readBytes()
                                    val requestBody = fileBytes.toRequestBody("image/png".toMediaTypeOrNull())
                                    val multipartBody = MultipartBody.Part.createFormData("file", "${UUID.randomUUID()}.png", requestBody)
                                    spacePhotoDto = spacesRepository.uploadFile(token, multipartBody).await()
                                }
                                 is PartData.FormItem -> {
                                     println()
                                     throw BookingMediaNotSupportedException("Este tipo de archivo no está soportado (FileItem)")
                                }
                                else -> {
                                    println("He entrado a else")
                                    throw BookingMediaNotSupportedException("Este tipo de archivo no está soportado")
                                }
                            }
                            part.dispose()
                        }
                        call.respond(HttpStatusCode.Created, spacePhotoDto!!)
                    } catch (e: SpaceNotFoundException) {
                        println("Error: ${e.message}")
                        call.respond(HttpStatusCode.NotFound, "${e.message}")
                    } catch (e: SpaceBadRequestException) {
                        println("Error: ${e.message}")
                        call.respond(HttpStatusCode.BadRequest, "${e.message}")
                    } catch (e: SpaceInternalErrorException) {
                        println("Error: ${e.message}")
                        call.respond(HttpStatusCode.InternalServerError, "${e.message}")
                    } catch (e: BookingMediaNotSupportedException) {
                        println("Error: ${e.message}")
                        call.respond(HttpStatusCode.UnsupportedMediaType, "${e.message}")
                    } catch (e: Exception) {
                        println("Error: ${e.message}")
                        call.respond(HttpStatusCode.InternalServerError, "${e.message}")
                    } catch (e: ContentTransformationException){
                        println("Error: ${e.message}")
                        call.respond(HttpStatusCode.UnsupportedMediaType, "${e.message}")
                    }
                }



                put("/{id}") {
                    try {
                        val token = tokenService.generateToken(call.principal()!!)
                        val id = call.parameters["id"]
                        val space = call.receive<SpaceUpdateDTO>()
                        UUID.fromString(id)

                        val res = runCatching {
                            spacesRepository.update("Bearer $token", id!!, space)
                        }

                        bookingsRepository.findBySpace("Bearer $token", id!!).data.forEach{
                            val bookingUpdate = BookingUpdateDTO(
                                it.userId,
                                it.userName,
                                it.spaceId,
                                space.name,
                                space.image!!,
                                it.startTime,
                                it.endTime,
                                it.observations,
                                it.status,
                            )
                            bookingsRepository.update("Bearer $token", it.uuid, bookingUpdate)
                        }
                        if (res.isSuccess) {
                            call.respond(HttpStatusCode.OK, res.getOrNull()!!)
                        } else {
                            throw res.exceptionOrNull()!!
                        }
                    } catch (e: SpaceNotFoundException) {
                        println("Error: ${e.message}")
                        call.respond(HttpStatusCode.NotFound, "${e.message}")
                    } catch (e: SpaceBadRequestException) {
                        println("Error: ${e.message}")
                        call.respond(HttpStatusCode.BadRequest, "${e.message}")
                    } catch (e: SpaceInternalErrorException) {
                        println("Error: ${e.message}")
                        call.respond(HttpStatusCode.InternalServerError, "${e.message}")
                    } catch (e: IllegalArgumentException) {
                        println("Error: ${e.message}")
                        call.respond(HttpStatusCode.BadRequest, "El id debe ser un UUID válido")
                    }
                }

                delete("/{id}") {
                    try {
                        val token = tokenService.generateToken(call.principal()!!)
                        val id = call.parameters["id"]
                        try {
                            UUID.fromString(id)
                        } catch (e: IllegalArgumentException) {
                            throw SpaceBadRequestException("El id debe ser un UUID válido")
                        }
                        val sala = spacesRepository.findById("Bearer $token", id!!)

                        require(bookingsRepository.findBySpace("Bearer $token", id).data.none { LocalDateTime.parse(it.startTime).isAfter(LocalDateTime.now()) })
                        {"Se deben actualizar o eliminar las reservas futuras asociadas a esta sala antes de continuar con la operación."}

                        spacesRepository.delete("Bearer $token", id)
                        spacesRepository.deleteFile("Bearer $token", sala.image!! + ".png")

                        call.respond(HttpStatusCode.NoContent)

                    } catch (e: SpaceNotFoundException) {
                        call.respond(HttpStatusCode.NotFound, "${e.message}")
                    } catch (e: SpaceBadRequestException) {
                        call.respond(HttpStatusCode.BadRequest, "${e.message}")
                    } catch (e: SpaceInternalErrorException) {
                        call.respond(HttpStatusCode.InternalServerError, "${e.message}")
                    } catch (e: IllegalArgumentException) {
                        call.respond(HttpStatusCode.BadRequest, "${e.message}")
                    }
                }
            }
            get("/storage/{uuid}") {
                try {
                    val uuid = call.parameters["uuid"]

                    val spacePhotoDto = runCatching {
                        spacesRepository.downloadFile(uuid!!)
                    }

                    if (spacePhotoDto.isSuccess) {
                        call.respondFile(spacePhotoDto.getOrNull()!!)
                    } else {
                        call.respond(HttpStatusCode.NotFound, "${spacePhotoDto.exceptionOrNull()?.message}")
                    }
                } catch (e: SpaceNotFoundException) {
                    call.respond(HttpStatusCode.NotFound, "${e.message}")
                } catch (e: SpaceBadRequestException) {
                    call.respond(HttpStatusCode.BadRequest, "${e.message}")
                } catch (e: SpaceInternalErrorException) {
                    call.respond(HttpStatusCode.InternalServerError, "${e.message}")
                }
            }

        }
    }
}