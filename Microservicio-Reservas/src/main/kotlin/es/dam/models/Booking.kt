package es.dam.models

import es.dam.serializers.IdSerializer
import es.dam.serializers.LocalDateTimeSerializer
import kotlinx.serialization.Serializable
import org.bson.codecs.pojo.annotations.BsonId
import org.litote.kmongo.Id
import org.litote.kmongo.newId
import java.time.LocalDateTime
import java.util.*


@Serializable
data class Booking(
    @BsonId
    @Serializable(with = IdSerializer::class)
    val id: Id<Booking> = newId(),
    val uuid: String = UUID.randomUUID().toString(),
    val userId: String,
    val userName: String,
    val spaceId: String,
    val spaceName: String,
    val image: String?,
    @Serializable(with = LocalDateTimeSerializer::class)
    val startTime: LocalDateTime,
    @Serializable(with = LocalDateTimeSerializer::class)
    val endTime: LocalDateTime,
    val observations: String?,
    val status: Status = Status.PENDING,

) {
    enum class Status {
        PENDING, APPROVED, REJECTED
    }
}
