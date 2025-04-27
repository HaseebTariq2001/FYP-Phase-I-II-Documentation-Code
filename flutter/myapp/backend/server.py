from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Allow cross-origin requests (important for Flutter)

# Define CARS categories
CARS_CATEGORIES = [
    "Relationship with others", "Imitation skills", "Emotional responses", "Body usage",
    "Object usage", "Adaptation to change", "Visual response", "Auditory response",
    "Taste, smell, and tactile response", "Anxiety and fear", "Verbal communication",
    "Non-verbal communication", "Activity level", "Intellectual response", "General impressions"
]

# # Learning materials recommendation
# LEARNING_MATERIALS = {
#     "Relationship with others": ["Social interaction games", "Role-playing activities"],
#     "Imitation skills": ["Mirror exercises", "Mimicry-based video lessons"],
#     "Emotional responses": ["Emotion recognition exercises", "Story-based learning"],
#     "Body usage": ["Motor skill games", "Dance therapy activities"],
#     "Object usage": ["Building block games", "Sorting and categorization tasks"],
#     "Adaptation to change": ["Routine change exercises", "Flexibility training games"],
#     "Visual response": ["Pattern recognition games", "Memory matching games"],
#     "Auditory response": ["Sound identification exercises", "Music therapy"],
#     "Taste, smell, and tactile response": ["Sensory play activities", "Texture recognition"],
#     "Anxiety and fear": ["Relaxation techniques", "Breathing exercises"],
#     "Verbal communication": ["Speech therapy apps", "Vocabulary-building games"],
#     "Non-verbal communication": ["Sign language training", "Expression-based activities"],
#     "Activity level": ["Energy regulation techniques", "Mindfulness exercises"],
#     "Intellectual response": ["Problem-solving puzzles", "Cognitive skill games"],
#     "General impressions": ["Comprehensive therapy", "Personalized learning plan"]
# }


@app.route('/')
def home():
    return "Flask API is running! Use /assess_autism for assessments."

@app.route('/assess_autism', methods=['POST'])
def assess_autism():
    data = request.json
    scores = data.get("scores", [])  # Expecting a list of 15 scores

    if len(scores) != 15:
        return jsonify({"error": "Invalid input, 15 scores required"}), 400

    total_score = sum(scores)

    # Determine severity level
    severity = "Severe Autism" if total_score >= 36 else "Moderate Autism" if 30 <= total_score < 36 else "No Autism or Mild Developmental Delay"

    # Identify deficient areas (scores 3 and 4)
    deficient_areas = [CARS_CATEGORIES[i] for i, score in enumerate(scores) if score >= 3]

    # Suggest learning materials
    # recommendations = {area: LEARNING_MATERIALS[area] for area in deficient_areas}

    return jsonify({
        "total_score": total_score,
        "severity": severity,
        # "deficient_areas": deficient_areas,
        # "recommendations": recommendations
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000, debug=True)
