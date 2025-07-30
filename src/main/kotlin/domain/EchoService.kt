package com.example.domain
 fun interface EchoService {
    fun echo(message: UserMessage): UserMessage
}