package es.dam.microserviciousuarios.controllers

import es.dam.microserviciousuarios.dto.*
import es.dam.microserviciousuarios.exceptions.UserBadRequestException
import es.dam.microserviciousuarios.exceptions.UserNotFoundException
import es.dam.microserviciousuarios.mappers.toDTO
import es.dam.microserviciousuarios.mappers.toModel
import es.dam.microserviciousuarios.models.User
import es.dam.microserviciousuarios.service.UserService
import es.dam.microserviciousuarios.utils.JWTUtils
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.web.bind.annotation.*
import org.springframework.web.server.ResponseStatusException

@RestController
@RequestMapping("/users")
class UsersController @Autowired constructor(
    private val userService: UserService,
    private val authenticationManager: AuthenticationManager,
    private val jwtUtils: JWTUtils
) {
    @PostMapping("/login")
    fun login(@RequestBody logingDto: UserLoginDTO): ResponseEntity<UserTokenDTO> {
        try {

            val authentication: Authentication = authenticationManager.authenticate(
                UsernamePasswordAuthenticationToken(
                    logingDto.username,
                    logingDto.password
                )
            )

            SecurityContextHolder.getContext().authentication = authentication

            val user = authentication.principal as User

            val jwtToken: String = jwtUtils.generateToken(user)

            return ResponseEntity.ok(UserTokenDTO(user.toDTO(), jwtToken))
        } catch (e: Exception) {
            throw ResponseStatusException(HttpStatus.UNAUTHORIZED)
        }
    }

    @PostMapping("/register")
    suspend fun register(@RequestBody usuarioDto: UserRegisterDTO): ResponseEntity<UserTokenDTO> {
        try {
            val user = usuarioDto.toModel()
            val userInsert = userService.save(user)
            val jwtToken: String = jwtUtils.generateToken(userInsert)

            return ResponseEntity.ok(UserTokenDTO(userInsert.toDTO(), jwtToken))
        } catch (e: UserBadRequestException) {
            println(e.stackTraceToString())
            throw ResponseStatusException(HttpStatus.BAD_REQUEST, e.stackTraceToString())
        }
    }

    @PreAuthorize("hasAnyRole('ADMINISTRATOR')")
    @GetMapping("")
    suspend fun findAll(@AuthenticationPrincipal user: User): ResponseEntity<UserDataDTO> {
        try {
            val res = userService.findAll().toList().map { it.toDTO() }
            val res2 = UserDataDTO(res)
            return ResponseEntity.ok(res2)
        } catch (e: UserNotFoundException) {
            throw ResponseStatusException(HttpStatus.NOT_FOUND, e.stackTraceToString())
        }
    }

    @PreAuthorize("hasAnyRole('ADMINISTRATOR')")
    @GetMapping("/{id}")
    suspend fun findById(@PathVariable id: String): ResponseEntity<UserResponseDTO> {
        try {
            val res = userService.findUserById(id).toDTO()
            return ResponseEntity.ok(res)
        } catch (e: UserNotFoundException) {
            throw ResponseStatusException(HttpStatus.NOT_FOUND, e.stackTraceToString())
        }
    }

    @PutMapping("/me")
    suspend fun update(
        @AuthenticationPrincipal user: User,
        @RequestBody userDTO: UserUpdateDTO
    ): ResponseEntity<UserResponseDTO> {
        try {
            val updated = user.copy(
                avatar = userDTO.avatar
            )
            val res = userService.update(updated)

            return ResponseEntity.status(HttpStatus.OK).body(res?.toDTO())
        } catch (e: UserNotFoundException) {
            throw ResponseStatusException(HttpStatus.NOT_FOUND, e.stackTraceToString())
        } catch (e: UserBadRequestException) {
            throw ResponseStatusException(HttpStatus.BAD_REQUEST, e.stackTraceToString())
        }
    }

    @PreAuthorize("hasAnyRole('ADMINISTRATOR')")
    @PutMapping("/{id}")
    suspend fun update(
        @PathVariable id: String,
        @RequestBody userDTO: UserUpdateDTO
    ): ResponseEntity<UserResponseDTO> {
        try {
            val updated = userService.findUserById(id).copy(
                avatar = userDTO.avatar
            )
            val res = userService.update(updated)

            return ResponseEntity.status(HttpStatus.OK).body(res?.toDTO())
        } catch (e: UserNotFoundException) {
            throw ResponseStatusException(HttpStatus.NOT_FOUND, e.stackTraceToString())
        } catch (e: UserBadRequestException) {
            throw ResponseStatusException(HttpStatus.BAD_REQUEST, e.stackTraceToString())
        }
    }

    @PreAuthorize("hasAnyRole('ADMINISTRATOR')")
    @DeleteMapping("/{id}")
    suspend fun delete(@PathVariable id: String): ResponseEntity<UserDTO> {
        try {
            userService.deleteById(id)
            return ResponseEntity.noContent().build()
        } catch (e: UserNotFoundException) {
            throw ResponseStatusException(HttpStatus.NOT_FOUND, e.stackTraceToString())
        } catch (e: UserBadRequestException) {
            throw ResponseStatusException(HttpStatus.BAD_REQUEST, e.stackTraceToString())
        }
    }
}