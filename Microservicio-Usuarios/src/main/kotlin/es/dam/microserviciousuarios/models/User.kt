package es.dam.microserviciousuarios.models

import es.dam.microserviciousuarios.serializers.LocalDateTimeSerializer
import es.dam.microserviciousuarios.serializers.UUIDSerializer
import jakarta.validation.constraints.*
import kotlinx.serialization.Contextual
import kotlinx.serialization.Serializable
import org.bson.types.ObjectId
import org.springframework.data.annotation.Id
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.userdetails.UserDetails
import java.time.LocalDateTime
import java.util.*

/**
 * Clase User.
 *
 * @property id Identificador del usuario en la base de datos.
 * @property uuid Identificador único del usuario en la aplicación.
 * @property name Nombre del usuario.
 * @property username Nombre de usuario del usuario (único).
 * @property email Email del usuario (único).
 * @property password Contraseña del usuario.
 * @property avatar Imagen de perfil del usuario.
 * @property userRole Rol del usuario (USER, TEACHER, ADMINISTRATOR).
 * @property credits Créditos del usuario.
 * @property isActive Indica si el usuario está activo o no.
 * @property createdAt Fecha de creación del usuario.
 * @property updatedAt Fecha de actualización del usuario.
 * @property lastPasswordChangeAt Fecha de la última actualización de la contraseña del usuario.
 *
 * @author Mireya Sánchez Pinzón
 * @author Alejandro Sánchez Monzón
 * @author Rubén García-Redondo Marín
 */
@Serializable
data class User(
    @Id @Contextual
    val id: ObjectId? = ObjectId.get(),
    @Serializable(with = UUIDSerializer::class)
    val uuid: UUID = UUID.randomUUID(),

    @NotNull @NotBlank(message = "El nombre no puede estar vacío.") @NotEmpty(message = "El nombre no puede estar vacío.")
    val name: String,

    @NotNull @NotBlank(message = "El nombre de usuario no puede estar vacío.") @NotEmpty(message = "El nombre de usuario no puede estar vacío.")
    @get:JvmName("userName")
    val username: String,

    @NotNull @NotBlank(message = "El email no puede estar vacío.") @NotEmpty(message = "El email no puede estar vacío.") @Email(
        regexp = "^[A-Za-z0-9+_.-]+@(.+)\$",
        message = "Email no válido."
    )
    val email: String,

    @NotNull @NotBlank(message = "La contraseña no puede estar vacía.") @NotEmpty(message = "La contraseña no puede estar vacía.") @Min(
        8,
        message = "La contraseña debe tener al menos 8 caracteres."
    )
    @get:JvmName("userPassword")
    val password: String,
    val avatar: String? = null,
    val userRole: String = UserRole.USER.name,
    val credits: Int = 20,
    val isActive: Boolean = true,
    // Históricos.
    @Serializable(with = LocalDateTimeSerializer::class)
    val createdAt: LocalDateTime = LocalDateTime.now(),
    @Serializable(with = LocalDateTimeSerializer::class)
    val updatedAt: LocalDateTime = LocalDateTime.now(),
    @Serializable(with = LocalDateTimeSerializer::class)
    val lastPasswordChangeAt: LocalDateTime = LocalDateTime.now()
) : UserDetails {
    enum class UserRole {
        USER, TEACHER, ADMINISTRATOR
    }

    override fun getAuthorities(): MutableCollection<out GrantedAuthority> {
        return userRole.split(",").map { SimpleGrantedAuthority("ROLE_${it.trim()}") }.toMutableList()
    }

    override fun getPassword(): String {
        return password
    }

    override fun getUsername(): String {
        return username
    }

    override fun isAccountNonExpired(): Boolean {
        return true
    }

    override fun isAccountNonLocked(): Boolean {
        return true
    }

    override fun isCredentialsNonExpired(): Boolean {
        return true
    }

    override fun isEnabled(): Boolean {
        return true
    }
}
