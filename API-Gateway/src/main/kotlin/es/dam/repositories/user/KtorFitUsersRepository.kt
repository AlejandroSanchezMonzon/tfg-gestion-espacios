package es.dam.repositories.user

import es.dam.dto.*
import es.dam.services.user.KtorFitClientUsers
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.withContext


class KtorFitUsersRepository: IUsersRepository {

    private val client by lazy { KtorFitClientUsers.instance }

    override suspend fun login(entity: UserLoginDTO): UserTokenDTO = withContext(Dispatchers.IO) {
        val call = async { client.login(entity) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error logging user: ${e.message}")
        }
    }

    override suspend fun register(entity: UserRegisterDTO): UserTokenDTO = withContext(Dispatchers.IO) {
        val call = async { client.register(entity) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error registering user: ${e.message}")
        }
    }

    override suspend fun findAll(token: String): UserDataDTO = withContext(Dispatchers.IO)  {
        val call = async { client.findAll() }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error getting users: ${e.message}")
        }
    }

    override suspend fun findById(token: String, id: Long): UserResponseDTO = withContext(Dispatchers.IO)  {
        val call = async { client.findById(id) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error getting user with id $id ${e.message}")
        }
    }

    override suspend fun update(token: String, id: Long, entity: UserUpdateDTO): UserResponseDTO = withContext(Dispatchers.IO)  {
        val call = async { client.update(id, entity) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error updating user with id $id: ${e.message}")
        }
    }

    override suspend fun delete(token: String, id: Long) = withContext(Dispatchers.IO)  {
        val call = async { client.delete(id) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error deleting user with id $id: ${e.message}")
        }
    }
}