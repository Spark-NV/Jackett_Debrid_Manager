# Jackett to Premiumize

A Flutter application that bridges Jackett and Premiumize services, allowing you to search for media content and easily cache it to your Premiumize cloud storage. This app supports searching for both Movies and TV shows, with customizable filters and sorting options.

## Features

- Search movies and TV shows using Jackett's indexers
- Filter results by:
  - Minimum seeders
  - File size (GB)
  - Content type (Movies/TV Shows)
- Check if content is already cached on Premiumize
- Send magnet links directly to Premiumize
- Manage Premiumize transfers:
  - View active and completed transfers
  - Monitor transfer progress
  - Clear finished transfers
  - Delete individual transfers
- Customizable settings for both Movies and TV Shows

## Prerequisites

### Jackett Setup
1. Install Jackett on your system ([Jackett Installation Guide](https://github.com/Jackett/Jackett#installation))
2. Configure your desired indexers in Jackett
3. Note down your:
   - Jackett API Key (found in Jackett's web interface)
   - Jackett URL (e.g., `http://your-ip:9117`) :: Recomended to setup a reverse proxy to allow app to work outside of your network

### Premiumize Account
1. Active Premiumize.me subscription
2. Premiumize API Key ([Get it here](https://www.premiumize.me/account))

## Building the App

### Requirements
- Flutter SDK 3.6.0 or higher
- Dart SDK 3.6.0 or higher

### Build Steps
1. Clone the repository:
   ```
   git clone https://github.com/Spark-NV/Jackett_Debrid_Manager.git
   ```

2. Install dependencies:
   ```
   flutter pub get
   ```

3. Run the code generator:
   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Build the app:
   ```
   flutter build apk  # For Android
   flutter build ios  # For iOS
   flutter build windows  # For Windows
   flutter build linux  # For Linux
   flutter build macos  # For macOS
   ```

## Configuration

1. Launch the app
2. Go to Settings and configure:
   - Jackett URL
   - Jackett API Key
3. Go to Premiumize Settings and set:
   - Premiumize API Key

## Usage

1. Use the search bar to find movies or TV shows
2. Apply filters as needed:
   - Set minimum seeders
   - Set size limits (in GB)
3. Results will show:
   - Title
   - File size
   - Seeder count
   - Cache status (if already on Premiumize)
4. Click the cloud icon to send to Premiumize
5. Monitor transfers in the Transfers screen
6. Clear completed transfers to manage cloud storage

## Storage Management

Premiumize provides 1TB of cloud storage. To manage your storage:
1. Access the Transfers screen
2. Use the clean button to remove finished transfers
3. Delete individual transfers as needed
4. Monitor your storage usage in the Premiumize web interface

## Privacy & Security

- API keys are stored locally on your device
- No data is collected or transmitted except to Jackett and Premiumize services
- Use HTTPS URLs when possible for secure connections
- Completely free and open source


## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.


## Disclaimer

This application is not affiliated with Jackett or Premiumize. Use at your own discretion and in accordance with your local laws and regulations.
