# Real-time Chat Setup Guide

## Overview
The chat system has been upgraded from polling (checking every 3 seconds) to real-time WebSocket communication using Soketi (a free, open-source Pusher-compatible WebSocket server).

## Architecture
- **Backend**: Laravel with Pusher broadcasting
- **WebSocket Server**: Soketi (Pusher-compatible)
- **Frontend**: Flutter with Pusher Channels

## Setup Instructions

### 1. Backend Setup (Laravel)

#### Prerequisites
- Laravel backend is already configured with:
  - Pusher PHP SDK installed
  - Broadcasting configured
  - Event classes created
  - Chat controller updated to broadcast events

#### Configuration
The `.env` file has been configured with:
```env
BROADCAST_CONNECTION=pusher
PUSHER_APP_ID=local-app
PUSHER_APP_KEY=local-key
PUSHER_APP_SECRET=local-secret
PUSHER_HOST=127.0.0.1
PUSHER_PORT=6001
PUSHER_SCHEME=http
PUSHER_APP_CLUSTER=mt1
```

### 2. WebSocket Server (Soketi)

#### Installation
Soketi has been installed globally:
```bash
npm install -g @soketi/soketi
```

#### Starting the WebSocket Server

**Method 1: Using the batch file (Windows)**
```bash
cd Backend
start_websocket.bat
```

**Method 2: Manual command**
```bash
cd Backend
soketi start --config=soketi.json
```

The server will run on `http://localhost:6001`

### 3. Frontend Setup (Flutter)

The Flutter app has been configured with:
- `pusher_channels_flutter` package for WebSocket connection
- `web_socket_channel` package as fallback
- ChatViewModel updated to use real-time updates

### 4. Running the Complete System

1. **Start Laravel Backend:**
   ```bash
   cd Backend
   php artisan serve
   ```

2. **Start WebSocket Server:**
   ```bash
   cd Backend
   start_websocket.bat
   ```
   Or:
   ```bash
   soketi start --config=soketi.json
   ```

3. **Run Flutter App:**
   ```bash
   cd Frontend
   flutter run
   ```

## How It Works

1. **Message Sending:**
   - User sends a message through Flutter app
   - Message is sent to Laravel API
   - Laravel saves the message to database
   - Laravel broadcasts a `MessageSent` event via Pusher/Soketi
   
2. **Message Receiving:**
   - Other users connected to the same chat channel receive the event instantly
   - The message appears in their chat UI without any delay
   - No more 3-second polling needed!

## Benefits Over Polling

### Previous System (Polling)
- ❌ Checked database every 3 seconds
- ❌ High server load with many users
- ❌ 3-second delay for messages
- ❌ Unnecessary database queries
- ❌ Higher bandwidth usage

### New System (WebSockets)
- ✅ Instant message delivery (< 100ms)
- ✅ Low server load
- ✅ Real-time updates
- ✅ Efficient resource usage
- ✅ Better user experience
- ✅ Scalable architecture

## Troubleshooting

### WebSocket Connection Issues
1. **Check Soketi is running:**
   - Look for "Soketi WebSocket Server started" message
   - Default port is 6001

2. **Firewall/Antivirus:**
   - Allow connections to port 6001
   - Add exception for soketi.exe if needed

3. **Laravel Broadcasting:**
   - Clear config cache: `php artisan config:clear`
   - Clear event cache: `php artisan event:clear`

### Flutter Connection Issues
1. **Check console logs:**
   - Look for "🔌 Connection state: CONNECTED"
   - Check for any Pusher error messages

2. **Network issues:**
   - Ensure device can reach localhost:6001
   - For physical devices, use computer's IP instead of localhost

## Testing the Real-time Chat

1. Open the app on two different devices/emulators
2. Login as Mitra on one device
3. Login as Bumdes on another device
4. Navigate to chat on both devices
5. Send a message from one device
6. The message should appear instantly on the other device

## Future Enhancements

1. **Production Deployment:**
   - Use managed Pusher service or
   - Deploy Soketi on a cloud server
   - Use SSL/TLS for secure WebSocket connections

2. **Additional Features:**
   - Typing indicators
   - Read receipts
   - Online/offline status
   - Push notifications for new messages
   - File/image sharing in chat

3. **Performance Optimizations:**
   - Message pagination
   - Lazy loading for old messages
   - Local message caching

## Technical Details

### Channel Structure
- Channel name format: `private-chat.{participant1}.{participant2}`
- Participants are sorted alphabetically to ensure consistent channel names
- Private channels require authentication (currently simplified for development)

### Event Structure
- Event name: `message.sent`
- Event data includes full message object with sender info
- Broadcasts to all channel subscribers except sender

### Security Considerations
For production:
- Implement proper authentication for private channels
- Use SSL/TLS for WebSocket connections
- Validate user permissions before allowing channel subscription
- Rate limit message sending
- Implement message encryption if needed

## Summary
The chat system has been successfully upgraded from polling-based to real-time WebSocket communication. This provides instant messaging capabilities with better performance and user experience. The system uses industry-standard tools (Pusher protocol) making it easy to scale and deploy to production.
