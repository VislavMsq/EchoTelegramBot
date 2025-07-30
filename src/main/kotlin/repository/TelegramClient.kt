package com.example.repository

import com.example.domain.UserMessage

interface TelegramClient {
    suspend fun getUpdates(): List<UserMessage>
    suspend fun sendMessage(message: UserMessage)
}