package es.dam.microserviciousuarios.config

import com.mongodb.ConnectionString
import com.mongodb.MongoClientSettings
import com.mongodb.client.MongoClient
import com.mongodb.client.MongoClients
import org.bson.UuidRepresentation
import org.springframework.context.annotation.Configuration
import org.springframework.data.mongodb.config.AbstractMongoClientConfiguration

@Configuration
class MongoConfig : AbstractMongoClientConfiguration() {
    override fun getDatabaseName(): String {
        return "reservas-luisvives"
    }

    override fun mongoClient(): MongoClient {
        val connectionString =
            ConnectionString("mongodb://admin:admin@mongodb:27017/")
        val mongoClientSettings = MongoClientSettings.builder()
            .applyConnectionString(connectionString)
            .uuidRepresentation(UuidRepresentation.STANDARD)
            .build()
        return MongoClients.create(mongoClientSettings)
    }
}
