# Environment Setup for Tales App

This document explains how to set up environment variables for the Tales app.

## Environment Variables

The Tales app uses environment variables to store sensitive information like API keys. These variables are stored in a `.env` file in the root of the project.

## Setting Up Your Environment

1. Copy the `.env.example` file to a new file named `.env`:
   ```
   cp .env.example .env
   ```

2. Edit the `.env` file and replace the placeholder values with your actual API keys:
   ```
   # Tales App Environment Variables
   
   # Unsplash API
   # Get your key at https://unsplash.com/developers
   UNSPLASH_ACCESS_KEY=your_unsplash_access_key_here
   
   # Add other API keys and environment variables below
   # FIREBASE_API_KEY=your_firebase_api_key_here
   # SENTRY_DSN=your_sentry_dsn_here
   ```

3. Save the file and restart the app.

## Security Notes

- The `.env` file is included in `.gitignore` to prevent it from being committed to version control.
- Never commit your actual API keys to version control.
- The app includes fallback values for development, but you should replace them with your own keys for production.

## Getting API Keys

### Unsplash API

1. Create an account at [Unsplash Developers](https://unsplash.com/developers)
2. Create a new application
3. Copy the Access Key to your `.env` file

## Troubleshooting

If you encounter issues with environment variables:

1. Make sure the `.env` file exists in the root of the project
2. Check that the variable names match exactly (e.g., `UNSPLASH_ACCESS_KEY`)
3. Restart the app after making changes to the `.env` file
4. Check the logs for any environment loading errors
