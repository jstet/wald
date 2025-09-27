.PHONY: setup-test teardown-test clean test-integration commit bump-patch bump-minor bump-major release

setup-test:
	docker compose -f docker-compose.test.yml up -d
	sleep 30

teardown-test:
	docker compose -f docker-compose.test.yml down -v

clean:
	docker compose -f docker-compose.test.yml down -v
	docker system prune -f

