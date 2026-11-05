# Citrus AI - Backend Architecture & Deployment Guide

This backend provides two core services:
1. **Verified Knowledge Database**: Houses verified USDA & botanical JSON for nutrition, allergies, and health storage.
2. **Secure Gemini Proxy**: Executes generative culinary suggestions without exposing the API key on mobile devices.

## Firebase Setup Instructions

### 1. Initialize Firebase
```bash
npm install -g firebase-tools
firebase login
firebase init functions
```

### 2. Set Secure Secret for Gemini API
Never put your API key in source code. Run:
```bash
firebase functions:secrets:set GEMINI_API_KEY
```

### 3. Deploy Functions
```bash
firebase deploy --only functions
```

Once deployed, copy the function URL (e.g. `https://us-central1-<project-id>.cloudfunctions.net/getCulinarySuggestions`) into Flutter `lib/core/constants/api_endpoints.dart`.

If the endpoint is not yet deployed, the Citrus AI Flutter app automatically defaults to the verified local curated catalog in `assets/data/citrus_culinary.json`.

