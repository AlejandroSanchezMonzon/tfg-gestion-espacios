package es.dam.dto

import es.dam.models.Space
import kotlinx.serialization.Serializable
import kotlin.time.Duration

@Serializable
data class SpaceDTO(
    val id: String,
    val uuid: String,
    val name: String,
    val isReservable: Boolean,
    val requiresAuthorization: Boolean,
    val maxBookings: Int?,
    val authorizedRoles: Set<Space.UserRole>,
    val bookingWindow: Duration
)

@Serializable
data class SpaceCreateDTO(
    val name: String,
    val isReservable: Boolean = false,
    val requiresAuthorization: Boolean,
    val maxBookings: Int?,
    val authorizedRoles: Set<String>,
    val bookingWindow: String
)

@Serializable
data class SpaceUpdateDTO(
    val id: String,
    val uuid: String,
    val name: String,
    val isReservable: Boolean,
    val requiresAuthorization: Boolean,
    val maxBookings: Int?,
    val authorizedRoles: Set<String> = setOf(Space.UserRole.USER.toString()),
    val bookingWindow: String
)

@Serializable
data class SpaceDataDTO(
    val data: List<SpaceDTO>
)

@Serializable
data class SpaceResponseDTO(
    val id: String,
    val uuid: String,
    val name: String,
    val isReservable: Boolean,
    val requiresAuthorization: Boolean,
    val maxBookings: Int?,
    val authorizedRoles: Set<Space.UserRole>,
    val bookingWindow: Duration
)