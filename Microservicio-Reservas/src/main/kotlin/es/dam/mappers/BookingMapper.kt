package es.dam.mappers

import es.dam.dto.BookingDtoCreate
import es.dam.dto.BookingDtoUpdate
import es.dam.models.Booking
import java.time.LocalDateTime


fun BookingDtoCreate.toModel() = Booking(
    spaceId = this.spaceId,
    userId = this.userId,
    startTime = LocalDateTime.parse(this.startTime),
    endTime = LocalDateTime.parse(this.endTime),
    phone = this.phone,
    status = Booking.Status.valueOf(this.status)
)

fun BookingDtoUpdate.toModel() = Booking(
    spaceId = this.spaceId,
    userId = this.userId,
    startTime = LocalDateTime.parse(this.startTime),
    endTime = LocalDateTime.parse(this.endTime),
    phone = this.phone,
    status = Booking.Status.valueOf(this.status)
)

