package com.example.domain

import java.time.LocalDateTime

data class UserMessage(
    val username: TelegramUser,
    val message: String,
    val time: LocalDateTime
)
