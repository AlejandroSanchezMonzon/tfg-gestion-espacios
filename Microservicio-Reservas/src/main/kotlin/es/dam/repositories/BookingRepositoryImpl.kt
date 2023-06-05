package es.dam.repositories

import es.dam.db.MongoDbManager
import es.dam.models.Booking
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.koin.core.annotation.Named
import org.koin.core.annotation.Single
import org.litote.kmongo.eq
import java.time.LocalDate
import java.util.*

@Single
@Named("BookingRepositoryImpl")
class BookingRepositoryImpl : BookingRepository {
    private val manager = MongoDbManager
    override suspend fun findByUserId(uuid: UUID): List<Booking> = withContext(Dispatchers.IO) {
        return@withContext manager.database.getCollection<Booking>().find(Booking::userId eq uuid.toString()).toList().ifEmpty { emptyList() }
    }

    override suspend fun findBySpaceId(uuid: UUID): List<Booking> = withContext(Dispatchers.IO) {
        return@withContext manager.database.getCollection<Booking>().find(Booking::spaceId eq uuid.toString()).toList().ifEmpty { emptyList() }
    }

    override suspend fun findAllStatus(status: Booking.Status): List<Booking> = withContext(Dispatchers.IO) {
        return@withContext manager.database.getCollection<Booking>().find(Booking::status eq status).toList().ifEmpty { emptyList() }
    }

    override suspend fun findByDate(uuid: UUID, date: LocalDate): List<Booking> = withContext(Dispatchers.IO) {
        return@withContext manager.database.getCollection<Booking>().find(Booking::spaceId eq uuid.toString()).toList().filter { it.startTime.toString().split("T")[0] == date.toString() }
    }

    override suspend fun findAll(): List<Booking> = withContext(Dispatchers.IO) {
        return@withContext manager.database.getCollection<Booking>().find().toList()
    }

    override suspend fun findById(uuid: UUID): Booking? = withContext(Dispatchers.IO) {
        return@withContext manager.database.getCollection<Booking>().find(Booking::uuid eq uuid.toString()).first()
    }

    override suspend fun save(entity: Booking): Booking? = withContext(Dispatchers.IO) {
        manager.database.getCollection<Booking>().save(entity)?.let {
            return@withContext entity
        }
        return@withContext null
    }

    override suspend fun update(entity: Booking): Booking? = withContext(Dispatchers.IO) {
        manager.database.getCollection<Booking>().save(entity)?.let {
            return@withContext entity
        }
        return@withContext null
    }

    override suspend fun delete(uuid: UUID): Boolean = withContext(Dispatchers.IO) {
        return@withContext manager.database.getCollection<Booking>().deleteOne(Booking::uuid eq uuid.toString()).let {
            return@let it.wasAcknowledged()
        }
    }

    override suspend fun deleteAll(): Boolean = withContext(Dispatchers.IO) {
        return@withContext manager.database.getCollection<Booking>().deleteMany().wasAcknowledged()
    }
}