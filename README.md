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

### Local Development Build

For faster local testing (single architecture only):

```bash
chmod +x build-local.sh
./build-local.sh
```

This builds only for your native architecture and tags as `jstet/wald:test`. Much faster than multi-arch builds for development and testing.

### Using the Image

```yaml
services:
  postgres:
    image: jstet/wald:latest
    # ... rest of configuration
```

---

## 🧪 Testing

This project includes integration tests that verify WAL-G backup functionality with PostgreSQL.

### Prerequisites

- Python 3.12+
- [uv](https://github.com/astral-sh/uv) (recommended) or pip
- Docker and Docker Compose

### Running Tests

1. **Build the test image:**
   ```bash
   ./build-local.sh
   ```

2. **Install dependencies:**
   ```bash
   uv sync
   ```

3. **Run all tests:**
   ```bash
   make setup-test
   uv run pytest test/
   make teardown-test
   ```

   Or run tests directly (services are managed by pytest fixtures):
   ```bash
   uv run pytest test/
   ```

**Note:** Tests use the `jstet/wald:test` image built by `build-local.sh`. Always rebuild before testing when you make changes to scripts or the Dockerfile.

3. **Run only integration tests:**
   ```bash
   uv run pytest test/ -m integration
   ```

4. **Clean up test environment:**
   ```bash
   make clean
   ```

### Test Environment

Tests use [docker-compose.test.yml](docker-compose.test.yml) which spins up:
- PostgreSQL with WAL-G (`jstet/wald` image)
- MinIO as S3-compatible storage
- Test databases (`testdb1`, `testdb2`)

The test suite verifies:
- Database discovery
- Container status checks
- WAL-G backup manager initialization
- Database creation/deletion operations

---

📚 **For complete usage documentation, configuration options, and examples, see the original repository:**
**https://github.com/lafayettegabe/wald**