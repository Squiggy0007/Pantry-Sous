#!/bin/bash
# Run this once: bash setup_secrets.sh
# Creates ~/secrets.xcconfig outside the repo so keys are never committed
#
# Fill in your own API keys below before running:
#   SPOONACULAR: https://spoonacular.com/food-api/console
#   USDA:        https://fdc.nal.usda.gov/api-guide.html

SECRETS_FILE="$HOME/secrets.xcconfig"

if [ -f "$SECRETS_FILE" ]; then
    echo "✅ ~/secrets.xcconfig already exists — skipping."
else
    cat > "$SECRETS_FILE" << 'EOF'
// secrets.xcconfig — NEVER commit this file
SPOONACULAR_API_KEY = YOUR_SPOONACULAR_KEY_HERE
USDA_API_KEY = YOUR_USDA_KEY_HERE
EOF
    echo "✅ Created ~/secrets.xcconfig"
    echo "⚠️  Open ~/secrets.xcconfig and replace the placeholder values with your real keys."
fi
echo "Done."
