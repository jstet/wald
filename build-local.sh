#!/bin/bash

IMAGE_NAME="jstet/wald"
VERSION="test"

echo "Building local image for testing (single architecture)..."

# Check if using buildx builder, if so switch to default
CURRENT_BUILDER=$(docker buildx inspect 2>/dev/null | grep -m1 "Name:" | awk '{print $2}' || echo "")
if [ "$CURRENT_BUILDER" = "multiarch-builder" ]; then
    echo "Switching from buildx to default builder for local builds..."
    docker buildx use default
fi

docker build --no-cache --tag "$IMAGE_NAME:$VERSION" --tag "$IMAGE_NAME:latest" .

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Local build completed successfully!"
    echo "Image: $IMAGE_NAME:$VERSION"
    echo ""
    echo "💡 Tip: Run tests with:"
    echo "   make setup-test && uv run pytest test/ -v && make teardown-test"
    echo ""
    echo "Or use the shorthand:"
    echo "   make clean && docker compose -f docker-compose.test.yml build && make setup-test && uv run pytest test/ -v"
else
    echo "❌ Build failed"
    exit 1
fi
