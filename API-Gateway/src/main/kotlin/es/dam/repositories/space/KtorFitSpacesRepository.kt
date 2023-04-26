package es.dam.repositories.space

import es.dam.dto.SpaceDataDTO
import es.dam.dto.SpaceResponseDTO
import es.dam.dto.SpaceUpdateDTO
import es.dam.services.space.KtorFitClientSpaces
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.withContext

class KtorFitSpacesRepository: ISpacesRepository {

    private val client by lazy { KtorFitClientSpaces.instance }

    override suspend fun findAll(token: String): SpaceDataDTO = withContext(Dispatchers.IO) {
        val call = async { client.findAll() }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error getting spaces: ${e.message}")
        }
    }

    override suspend fun findById(token: String, id: Long): SpaceResponseDTO = withContext(Dispatchers.IO) {
        val call = async { client.findById(id) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error getting space with id $id ${e.message}")
        }
    }

    override suspend fun findAllReservables(token: String, isReservable: Boolean): SpaceDataDTO = withContext(Dispatchers.IO) {
        val call = async { client.findAllReservables(isReservable) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error getting reservable spaces:${e.message}")
        }
    }

    override suspend fun findByName(token: String, name: String): SpaceResponseDTO = withContext(Dispatchers.IO) {
        val call = async { client.findByName(name) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error getting space with name $name ${e.message}")
        }
    }

    override suspend fun create(token: String, id: Long, entity: SpaceUpdateDTO): SpaceResponseDTO = withContext(Dispatchers.IO) {
        val call = async { client.create(id, entity) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error creating space: ${e.message}")
        }
    }

    override suspend fun update(token: String, id: Long, entity: SpaceUpdateDTO): SpaceResponseDTO = withContext(Dispatchers.IO) {
        val call = async { client.update(id, entity) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error updating space with id $id: ${e.message}")
        }
    }

    override suspend fun delete(token: String, id: Long) = withContext(Dispatchers.IO) {
        val call = async { client.delete(id) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error deleting space with id $id: ${e.message}")
        }
    }
}