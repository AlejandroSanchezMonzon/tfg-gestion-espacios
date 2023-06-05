package es.dam.models

import es.dam.serializers.IdSerializer
import kotlinx.serialization.Serializable
import org.bson.codecs.pojo.annotations.BsonId
import org.litote.kmongo.Id
import org.litote.kmongo.newId
import java.util.*

@Serializable
data class Space(
    @BsonId
    @Serializable(with = IdSerializer::class)
    val id: Id<Space> = newId(),
    val uuid: String = UUID.randomUUID().toString(),
    val name: String,
    val description: String? = "",
    val image: String? = null,
    val price: Int,
    val isReservable: Boolean,
    val requiresAuthorization: Boolean,
    val authorizedRoles: Set<UserRole>,
    val bookingWindow: Int
) {
    enum class UserRole {
        ADMINISTRATOR, TEACHER, USER
    }
}