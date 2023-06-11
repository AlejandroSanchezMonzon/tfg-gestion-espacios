package es.dam.mappers

import es.dam.dto.BookingDto
import es.dam.dto.BookingDtoCreate
import es.dam.dto.BookingDtoUpdate
import es.dam.models.Booking
import java.time.LocalDateTime

/**
 * Mappers de la clase de Bookings contiene los mappers de BookingDtoCreate, BookingDtoUpdate y BookingDto.
 * BookingDtoCreate.toModel(): Mapper de BookingDtoCreate a Booking.
 * BookingDtoUpdate.toModel(): Mapper de BookingDtoUpdate a Booking.
 * BookingDto.toDTO(): Mapper de Booking a BookingDto.
 *
 * @author Mireya Sánchez Pinzón
 * @author Alejandro Sánchez Monzón
 * @author Rubén García-Redondo Marín
 */
fun BookingDtoCreate.toModel() = Booking(
    spaceId = this.spaceId,
    spaceName = this.spaceName,
    userId = this.userId,
    userName = this.userName,
    image = this.image,
    startTime = LocalDateTime.parse(this.startTime),
    endTime = LocalDateTime.parse(this.endTime),
    observations = this.observations,
    status = Booking.Status.valueOf(this.status)
)

fun BookingDtoUpdate.toModel() = Booking(
    spaceId = this.spaceId,
    spaceName = this.spaceName,
    userId = this.userId,
    userName = this.userName,
    image = this.image,
    startTime = LocalDateTime.parse(this.startTime),
    endTime = LocalDateTime.parse(this.endTime),
    observations = this.observations,
    status = Booking.Status.valueOf(this.status)
)

fun Booking.toDTO() = BookingDto(
    uuid = this.uuid,
    spaceId = this.spaceId,
    spaceName = this.spaceName,
    image = this.image,
    userId = this.userId,
    userName = this.userName,
    startTime = this.startTime.toString(),
    endTime = this.endTime.toString(),
    observations = this.observations,
    status = this.status.toString()
)

