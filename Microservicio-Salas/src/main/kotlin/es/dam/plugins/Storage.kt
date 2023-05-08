package es.dam.plugins

import io.ktor.server.application.*
import es.dam.config.StorageConfig
import es.dam.services.storage.StorageService
import es.dam.services.storage.StorageServiceImpl
import org.koin.core.parameter.parametersOf
import org.koin.core.qualifier.named
import org.koin.java.KoinJavaComponent
import org.koin.ktor.ext.get
import org.koin.ktor.ext.inject

fun Application.configureStorage() {
    val storageConfigParams = mapOf(
        "baseUrl" to environment.config.property("server.baseUrl").getString(),
        "uploadDir" to environment.config.property("storage.uploadDir").getString(),
        "endpoint" to environment.config.property("storage.endpoint").getString()
    )

    val storageConfig: StorageConfig = get { parametersOf(storageConfigParams) }
    val storageService: StorageServiceImpl by inject(named("StorageServiceImpl"))
    storageService.initStorageDirectory()
}