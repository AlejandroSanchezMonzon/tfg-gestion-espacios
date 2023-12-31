package es.dam.services.space

import de.jensklingenberg.ktorfit.http.*
import es.dam.dto.*
import io.ktor.client.request.forms.*

/**
 * Interfaz que contiene las funciones que se comunican con el microservicio de espacios.
 *
 * @author Mireya Sánchez Pinzón
 * @author Alejandro Sánchez Monzón
 * @author Rubén García-Redondo Marín
 */
interface KtorFitRestSpaces {
    @GET("spaces")
    suspend fun findAll(
        @Header("Authorization") token: String
    ): SpaceDataDTO

    @GET("spaces/{id}")
    suspend fun findById(
        @Header("Authorization") token: String,
        @Path("id") id: String
    ): SpaceResponseDTO

    @GET("spaces/reservables/{isReservable}")
    suspend fun findAllReservables(
        @Header("Authorization") token: String,
        @Path("isReservable") isReservable: Boolean
    ): SpaceDataDTO

    @GET("spaces/nombre/{name}")
    suspend fun findByName(
        @Header("Authorization") token: String,
        @Path("name") name: String
    ): SpaceResponseDTO

    @POST("spaces")
    suspend fun create(
        @Header("Authorization") token: String,
        @Body space: SpaceCreateDTO
    ): SpaceResponseDTO


    @POST("spaces/storage")
    suspend fun uploadFile(
        @Header("Authorization") token: String,
        @Body image: MultiPartFormDataContent
    ): SpacePhotoDTO


    @PUT("spaces/{id}")
    suspend fun update(
        @Header("Authorization") token: String,
        @Path("id") id: String, @Body space: SpaceUpdateDTO
    ): SpaceResponseDTO

    @DELETE("spaces/{id}")
    suspend fun delete(
        @Header("Authorization") token: String,
        @Path("id") id: String
    )

    @DELETE("spaces/storage/{uuid}")
    suspend fun deleteFile(
        @Header("Authorization") token: String,
        @Path("uuid") uuid: String
    )

    @GET("spaces/storage/{uuid}")
    suspend fun downloadFile(
        @Path("uuid") uuid: String
    ): ByteArray
}