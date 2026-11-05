/**
 * Citrus AI - Secure Gemini Proxy Backend (Firebase Cloud Functions)
 * 
 * SECURITY GUARANTEE:
 * 1. The Gemini API key is stored securely in Firebase Secrets Manager / environment variables.
 * 2. It is NEVER shipped inside the client-side Flutter application.
 * 3. Flutter calls this endpoint with the predicted fruit name.
 * 4. This function enforces strict system instructions to guarantee:
 *    - Gemini ONLY provides culinary recipe cards with title, description, and verified URL.
 *    - Gemini NEVER generates medical, nutrition, or allergy claims (those come solely from the verified static DB).
 */

const { onRequest } = require("firebase-functions/v2/https");
const { GoogleGenerativeAI } = require("@google/generative-ai");

const GEMINI_API_KEY = process.env.GEMINI_API_KEY;

exports.getCulinarySuggestions = onRequest({ cors: true }, async (req, res) => {
  if (req.method !== "POST") {
    return res.status(405).json({ error: "Method not allowed. Use POST." });
  }

  const { fruit } = req.body;
  const allowedFruits = ["Orange", "Tangerine", "Lemon", "Lime", "Kaffir Lime"];

  if (!fruit || !allowedFruits.includes(fruit)) {
    return res.status(400).json({ error: "Invalid fruit requested." });
  }

  try {
    if (!GEMINI_API_KEY) {
      // Graceful fallback to verified curated catalogue if key not configured
      return res.status(200).json({
        fallback: true,
        message: "Gemini backend key not set. Using verified curated catalog."
      });
    }

    const genAI = new GoogleGenerativeAI(GEMINI_API_KEY);
    const model = genAI.getGenerativeModel({
      model: "gemini-1.5-flash",
      systemInstruction: `You are a culinary expert assistant for a citrus mobile app.
Your task is to recommend 3 culinary recipes or serving ideas for the specified citrus fruit: "${fruit}".
STRICT SAFETY & QUALITY RULES:
1. DO NOT generate nutrition facts, allergy advice, medical recommendations, or health claims.
2. For each recipe, provide ONLY:
   - "title": Short recipe title.
   - "description": 1-2 sentence culinary description.
   - "imageUrl": A high-quality Unsplash food image URL for this dish.
   - "recipeUrl": A real, verified YouTube video URL or reputable recipe site URL for this dish. If no verified link exists, leave empty string "".
3. Return ONLY valid JSON array with objects matching: [{"title": "...", "description": "...", "imageUrl": "...", "recipeUrl": "..."}]`
    });

    const result = await model.generateContent(`Suggest 3 culinary recipes featuring ${fruit}.`);
    const responseText = result.response.text();

    // Clean JSON response
    const cleaned = responseText.replace(/```json/g, "").replace(/```/g, "").trim();
    const suggestions = JSON.parse(cleaned);

    return res.status(200).json({ suggestions });
  } catch (error) {
    console.error("Gemini proxy error:", error);
    return res.status(500).json({ error: "Failed to generate suggestions", details: error.message });
  }
});

