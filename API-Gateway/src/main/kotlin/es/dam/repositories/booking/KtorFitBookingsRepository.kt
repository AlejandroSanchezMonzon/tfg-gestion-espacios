package es.dam.repositories.booking

import es.dam.dto.BookingCreateDTO
import es.dam.dto.BookingDataDTO
import es.dam.dto.BookingResponseDTO
import es.dam.dto.BookingUpdateDTO
import es.dam.exceptions.BookingBadRequestException
import es.dam.exceptions.BookingNotFoundException
import es.dam.services.booking.KtorFitClientBookings
import kotlinx.coroutines.CoroutineStart
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.withContext
import org.koin.core.annotation.Single

/**
 * Clase que implementa las operaciones que se pueden realizar sobre reservas. Se comunica con el servicio de reservas mediante Ktorfit.
 *
 * @author Mireya Sánchez Pinzón
 * @author Alejandro Sánchez Monzón
 * @author Rubén García-Redondo Marín
 */
@Single
class KtorFitBookingsRepository: IBookingsRepository {
    private val client by lazy { KtorFitClientBookings.instance }

    /**
     * Función que devuelve todas las reservas.
     *
     * @param token Token de autenticación.
     * @return BookingDataDTO
     */
    override suspend fun findAll(token: String): BookingDataDTO = withContext(Dispatchers.IO) {
        val call = async { client.findAll(token) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error getting bookings: ${e.message}")
        }
    }

    /**
     * Función que devuelve una reserva por su id.
     *
     * @param token Token de autenticación.
     * @param id Id de la reserva.
     * @return BookingResponseDTO
     */
    override suspend fun findById(token: String, id: String): BookingResponseDTO = withContext(Dispatchers.IO) {
        val call = runCatching { client.findById(token, id) }
        return@withContext if (call.isSuccess) call.getOrThrow() else throw BookingNotFoundException("Error getting booking with id $id ${call.exceptionOrNull()?.message}")

    }

    /**
     * Función que devuelve todas las reservas de un espacio por su id.
     *
     * @param token Token de autenticación.
     * @param id Id del espacio.
     * @return BookingDataDTO
     */
    override suspend fun findBySpace(token: String, id: String): BookingDataDTO = withContext(Dispatchers.IO) {
        val call = async (start = CoroutineStart.LAZY){ client.findBySpace(token, id) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            return@withContext BookingDataDTO(emptyList())
        }
    }

    /**
     * Función que devuelve todas las reservas de un usuario por su id.
     *
     * @param token Token de autenticación.
     * @param id Id del usuario.
     * @return BookingDataDTO
     */
    override suspend fun findByUser(token: String, id: String): BookingDataDTO = withContext(Dispatchers.IO) {
        val call = async { client.findByUser(token, id) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error getting booking with users's id $id ${e.message}")
        }
    }

    /**
     * Función que devuelve todas las reservas de un estado.
     *
     * @param token Token de autenticación.
     * @param status Estado de la reserva.
     * @return BookingDataDTO
     */
    override suspend fun findByStatus(token: String, status: String): BookingDataDTO = withContext(Dispatchers.IO) {
        val call = async { client.findByStatus(token, status) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw BookingBadRequestException("Error getting booking with status $status ${e.message}")
        }
    }

    /**
     * Función que devuelve todas las reservas de un espacio en una fecha.
     *
     * @param token Token de autenticación.
     * @param id Id del espacio.
     * @param date Fecha de la reserva.
     * @return BookingDataDTO
     */
    override suspend fun findByTime(token: String, id: String, date: String): BookingDataDTO = withContext(Dispatchers.IO){
        val call = async { client.findByTime(token, id, date) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw BookingBadRequestException("Error getting booking with space's id $id and date $date ${e.message}")
        }
    }

    /**
     * Función que crea una reserva.
     *
     * @param token Token de autenticación.
     * @param entity BookingCreateDTO
     * @return BookingResponseDTO
     */
    override suspend fun create(token: String, entity: BookingCreateDTO): BookingResponseDTO = withContext(Dispatchers.IO) {
        val call = async { client.create(token, entity) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error creating booking: ${e.message}")
        }
    }

    /**
     * Función que actualiza una reserva.
     *
     * @param token Token de autenticación.
     * @param id Id de la reserva.
     * @param entity BookingUpdateDTO
     * @return BookingResponseDTO
     */
    override suspend fun update(token: String, id: String, entity: BookingUpdateDTO): BookingResponseDTO = withContext(Dispatchers.IO) {
        val call = async { client.update(token, id, entity) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error updating booking with id $id: ${e.message}")
        }
    }

    /**
     * Función que elimina una reserva.
     *
     * @param token Token de autenticación.
     * @param id Id de la reserva.
     * @return BookingResponseDTO
     */
    override suspend fun delete(token: String, id: String) = withContext(Dispatchers.IO) {
        val call = async { client.delete(token, id) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error deleting booking with id $id: ${e.message}")
        }
    }
}