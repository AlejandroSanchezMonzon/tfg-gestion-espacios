package es.dam.repositories.user

import es.dam.dto.*
import es.dam.services.user.KtorFitClientUsers
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.withContext
import org.koin.core.annotation.Single

//TODO Quitar mensajes excepciones kotlin
@Single
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
        val call = async { client.findAll(token) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error getting users: ${e.message}")
        }
    }

    override suspend fun findById(token: String, id: String): UserResponseDTO = withContext(Dispatchers.IO)  {
        val call = async { client.findById(token, id) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error getting user with id $id ${e.message}")
        }
    }

    override suspend fun findMe(token: String, id: String): UserResponseDTO = withContext(Dispatchers.IO)  {
        val call = async { client.findMe(token, id) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error getting user data ${e.message}")
        }
    }

    override suspend fun isActive(username: String): Boolean = withContext(Dispatchers.IO)  {
        val call = async { client.isActive(username) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error getting user's state with username $username ${e.message}")
        }
    }

    override suspend fun update(token: String, id: String, entity: UserUpdateDTO): UserResponseDTO = withContext(Dispatchers.IO)  {
        val call = async { client.update(token, id, entity) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error updating user with id $id: ${e.message}")
        }
    }

    override suspend fun updateCredits(token: String, id: String, creditsAmount: Int): UserResponseDTO = withContext(Dispatchers.IO)  {
        val call = async { client.updateCredits(token, id, creditsAmount) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error updating user with id $id: ${e.message}")
        }
    }

    override suspend fun updateCreditsMe(token: String, id: String, creditsAmount: Int): UserResponseDTO = withContext(Dispatchers.IO)  {
        val call = async { client.updateCreditsMe(token, id, creditsAmount) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error updating me: ${e.message}")
        }
    }

    override suspend fun updateActive(token: String, id: String, active: Boolean): UserResponseDTO = withContext(Dispatchers.IO)  {
        val call = async { client.updateActive(token, id, active) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error updating user with id $id: ${e.message}")
        }
    }

    override suspend fun delete(token: String, id: String) = withContext(Dispatchers.IO)  {
        val call = async { client.delete(token, id) }
        try {
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error deleting user with id $id: ${e.message}")
        }
    }

    override suspend fun me(token: String, entity: UserUpdateDTO): UserResponseDTO = withContext(Dispatchers.IO) {
        val call = async { client.me(token, entity) }
        try{
            return@withContext call.await()
        } catch (e: Exception) {
            throw Exception("Error updating user: ${e.message}")
        }
    }
}