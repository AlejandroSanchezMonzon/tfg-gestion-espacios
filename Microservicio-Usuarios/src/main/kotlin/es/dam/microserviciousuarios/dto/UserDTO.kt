package es.dam.microserviciousuarios.dto

import kotlinx.serialization.Serializable
import java.time.LocalDateTime

/**
 * DTOs de la clase User.
 * Contiene los DTOs de User, UserRegister, UserUpdate, UserLogin, UserToken, UserResponse y UserData
 *
 * @author Mireya Sánchez Pinzón
 * @author Alejandro Sánchez Monzón
 * @author Rubén García-Redondo Marín
 */
@Serializable
data class UserDTO(
    val id: String? = null,
    val uuid: String,
    val name: String,
    val username: String,
    val email: String,
    val password: String,
    val avatar: String? = null,
    val userRole: Set<String>,
    val credits: Int,
    val isActive: Boolean,
    val metadata: Metadata
) {
    @Serializable
    data class Metadata(
        val createdAt: String? = LocalDateTime.now().toString(),
        val updatedAt: String? = LocalDateTime.now().toString()
    )
}

@Serializable
data class UserRegisterDTO(
    val name: String,
    val username: String,
    val email: String,
    val password: String,
    val avatar: String? = null,
    val isActive: Boolean,
    val userRole: Set<String>
)

@Serializable
data class UserUpdateDTO(
    val name: String,
    val username: String,
    val avatar: String? = null,
    val userRole: Set<String>,
    val credits: Int,
    val isActive: Boolean,

    )

@Serializable
data class UserLoginDTO(
    val username: String,
    val password: String
)

@Serializable
data class UserTokenDTO(
    val user: UserResponseDTO,
    val token: String
)

@Serializable
data class UserResponseDTO(
    val id: String? = null,
    val uuid: String,
    val name: String,
    val username: String,
    val email: String,
    val password: String,
    val avatar: String? = null,
    val userRole: Set<String>,
    val credits: Int,
    val isActive: Boolean
    )

@Serializable
data class UserDataDTO(
    val data: List<UserResponseDTO>
)

@Serializable
data class SpacePhotoDTO(
    val data: Map<String, String>
)
