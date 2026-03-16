# SMS Forwarder Android

Android app that forwards incoming SMS messages to a user-defined webhook URL in real time. Built with Flutter.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-v3.11+-blue.svg)](https://flutter.dev)

## 🚀 Features

- **Real-time Forwarding**: Instantly sends incoming SMS to your specified API endpoint.
- **Background Support**: Works even when the app is closed or the phone is locked.
- **Bilingual Interface**: Supporting English and Turkish languages.
- **Activity Logs**: Track forwarded messages and delivery status directly in the app.
- **Modern UI**: Clean, dark-themed, and responsive design.

## 🛠️ Installation

1.  **Prerequisites**: Ensure you have [Flutter](https://docs.flutter.dev/get-started/install) installed on your machine.
2.  **Clone the repo**:
    ```bash
    git clone https://github.com/muhammetdag/sms_forwarder_android.git
    cd sms_forwarder_android
    ```
3.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Run the app**:
    ```bash
    flutter run
    ```

## ⚙️ How it Works

1.  **Language Selection**: On the first launch, choose your preferred language.
2.  **Permissions**: Grant SMS (Receive/Read) and Internet permissions when prompted.
3.  **Webhook Setup**: Enter your server's endpoint URL (e.g., `https://your-api.com/sms-receive`).
4.  **Background Listening**: The app uses a background service to listen for incoming messages and POST them to your URL as JSON.

### JSON Payload Example

```json
{
  "timestamp": "2024-03-16T10:45:00.000Z",
  "sender": "+1234567890",
  "message": "Hello, this is a test message.",
  "background": true
}
```

## 🛡️ Permissions

This app requires the following Android permissions:
- `RECEIVE_SMS`: To detect incoming messages.
- `READ_SMS`: To read the message content.
- `INTERNET`: To send data to your webhook.
- `RECEIVE_BOOT_COMPLETED`: To restart the service after a phone reboot.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
**Disclaimer**: This tool is for personal use and developer testing. Please ensure you comply with your local privacy laws and regulations regarding SMS data.
