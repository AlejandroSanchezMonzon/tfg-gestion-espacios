package es.dam.microserviciousuarios.service

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import java.time.LocalDateTime

@Component
class ScheduleService constructor(
    @Autowired
    val userService: UserService){


    @Scheduled(cron = "0 0 1 1 * ?")
     fun poner20creditosAllUsers() {
         println("${LocalDateTime.now()} INFO --- [Schedule credits function] ScheduleService : Poniendo 20 creditos a todos los usuarios...")
         userService.poner20creditosAllUsers();
         println("${LocalDateTime.now()} INFO --- [Schedule credits function] ScheduleService : Operacion completada")
    }
}