# 🐘 PostgreSQL + WAL-G Docker Image (Fork)

> **This is a fork of [lafayettegabe/wald](https://github.com/lafayettegabe/wald)**
> For complete documentation, usage instructions, and configuration details, please visit the original repository.

## 🚀 Building and Pushing

This fork is configured to build and push to Docker Hub repository `jstet/wald`.

### Prerequisites

- Docker with Buildx support
- Docker Hub account access

### Build Process

1. **Login to Docker Hub:**
   ```bash
   docker login
   ```

2. **Build and push multi-architecture image:**
   ```bash
   chmod +x build.sh
   ./build.sh
   ```

3. **Verify the build:**
   ```bash
   docker buildx imagetools inspect jstet/wald:latest
   ```

### Build Configuration

- **Image name:** `jstet/wald`
- **Version:** `1.0.1`
- **Platforms:** `linux/amd64`, `linux/arm64`
- **Tags:** `jstet/wald:1.0.1`, `jstet/wald:latest`

The build script automatically:
- Creates a multi-architecture builder if needed
- Builds for both AMD64 and ARM64 platforms
- Pushes directly to Docker Hub

### Using the Image

```yaml
services:
  postgres:
    image: jstet/wald:latest
    # ... rest of configuration
```

---

📚 **For complete usage documentation, configuration options, and examples, see the original repository:**
**https://github.com/lafayettegabe/wald**