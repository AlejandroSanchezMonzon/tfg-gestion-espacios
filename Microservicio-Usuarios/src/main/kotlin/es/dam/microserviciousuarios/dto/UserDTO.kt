package es.dam.microserviciousuarios.dto

import es.dam.microserviciousuarios.models.User
import es.dam.microserviciousuarios.serializers.LocalDateTimeSerializer
import kotlinx.serialization.Serializable
import java.time.LocalDateTime

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
    val userRole: Set<String>
)

@Serializable
data class UserUpdateDTO(
    val name: String,
    val username: String,
    val email: String,
    val password: String,
    val avatar: String? = null,
    val userRole: Set<String>
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
    val userRole: Set<String>
)

@Serializable
data class UserDataDTO(
    val data: List<UserResponseDTO>
)
