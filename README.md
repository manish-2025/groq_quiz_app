# GROQ Quiz App

A Flutter quiz application that generates quiz questions dynamically using GROQ.com's LLM APIs.

## Features

- **Dynamic Question Generation**: Uses GROQ.com APIs with the llama3-8b-8192 model to generate unique quiz questions on demand
- **Multiple Categories**: Choose from General Knowledge, Science & Technology, History, Geography, and Movies & Entertainment
- **Difficulty Levels**: Select from Easy, Medium, and Hard difficulty settings
- **Timed Questions**: Questions are timed based on difficulty (Easy: 45s, Medium: 30s, Hard: 20s)
- **Score Tracking**: Immediate feedback on answers and score calculation
- **Score History**: View past quiz results, stored locally
- **Responsive Design**: Works on both iOS and Android devices

## Screenshots

[Screenshots would be included here in a real README]

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- GROQ.com API key

### Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-username/groq-quiz-app.git
   ```

2. Navigate to the project directory:
   ```
   cd groq-quiz-app
   ```

3. Install dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```

### Setting up your GROQ API key

On first launch, the app will prompt you to enter your GROQ API key. You can also update this at any time by tapping the key icon in the app bar.

To get a GROQ API key:
1. Sign up at [GROQ.com](https://groq.com)
2. Navigate to your account settings
3. Generate an API key
4. Copy and paste this key into the app when prompted

## Project Structure

- `main.dart`: Entry point of the application
- `models/`: Contains data models for Questions and Score
- `screens/`: UI screens (Home, Quiz, Results, Score History)
- `services/`: API and storage services

## APIs and Libraries Used

- **GROQ API**: Used for generating quiz questions with LLMs
- **http**: For making API requests
- **shared_preferences**: For storing API key and quiz history
- **intl**: For date formatting

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [GROQ.com](https://groq.com) for providing the LLM API
- Flutter team for the amazing framework