#!/bin/bash
# Run this once: bash setup_secrets.sh
# Creates Stocker/secrets.xcconfig, which is ignored by git
#
# Fill in your own API keys below before running:
#   SPOONACULAR: https://spoonacular.com/food-api/console
#   USDA:        https://fdc.nal.usda.gov/api-guide.html

SECRETS_FILE="Stocker/secrets.xcconfig"
LEGACY_SECRETS_FILE="$HOME/secrets.xcconfig"

if [ -f "$SECRETS_FILE" ]; then
    echo "✅ $SECRETS_FILE already exists — skipping."
elif [ -f "$LEGACY_SECRETS_FILE" ]; then
    mkdir -p Stocker
    cp "$LEGACY_SECRETS_FILE" "$SECRETS_FILE"
    echo "✅ Copied existing ~/secrets.xcconfig to $SECRETS_FILE"
else
    mkdir -p Stocker
    cat > "$SECRETS_FILE" << 'EOF'
// secrets.xcconfig — NEVER commit this file
SPOONACULAR_API_KEY = YOUR_SPOONACULAR_KEY_HERE
USDA_API_KEY = YOUR_USDA_KEY_HERE
EOF
    echo "✅ Created $SECRETS_FILE"
    echo "⚠️  Open $SECRETS_FILE and replace the placeholder values with your real keys."
fi
echo "Done."
