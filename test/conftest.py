import pytest
import time
import subprocess
from duplicaid.local import LocalExecutor
from pathlib import Path

@pytest.fixture(scope="session")
def docker_compose_file():
    return Path(__file__).parent.parent / "docker-compose.test.yml"


@pytest.fixture(scope="session")
def test_services(docker_compose_file):
    subprocess.run(
        ["docker", "compose", "-f", str(docker_compose_file), "down", "-v"],
        capture_output=True,
    )

    result = subprocess.run(
        ["docker", "compose", "-f", str(docker_compose_file), "up", "-d"],
        capture_output=True,
        text=True,
    )

    if result.returncode != 0:
        pytest.fail(f"Failed to start test services: {result.stderr}")

    time.sleep(30)

    yield

    subprocess.run(
        ["docker", "compose", "-f", str(docker_compose_file), "down", "-v"],
        capture_output=True,
    )

@pytest.fixture
def local_executor(test_config):
    return LocalExecutor(test_config)

@pytest.fixture
def postgres_ready(test_services, local_executor):
    max_retries = 30
    for i in range(max_retries):
        if local_executor.check_container_running("postgres_wald"):
            stdout, stderr, exit_code = local_executor.docker_exec(
                "postgres_wald", "pg_isready -U postgres -d postgres"
            )
            if exit_code == 0:
                break
        time.sleep(1)
    else:
        pytest.fail("PostgreSQL not ready after 30 seconds")

    stdout, stderr, exit_code = local_executor.docker_exec(
        "postgres_wald", 'psql -U postgres -c "CREATE DATABASE testdb1;" || true'
    )
    stdout, stderr, exit_code = local_executor.docker_exec(
        "postgres_wald", 'psql -U postgres -c "CREATE DATABASE testdb2;" || true'
    )
