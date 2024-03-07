# Run example
run:
	cd example && flutter run

run-release:
	cd example && flutter run --release

# Cleanup
clean:
	flutter clean
	flutter pub get

# Format & Lint
format:
	dart format .
lint:
	dart analyze

# Generate API with Pigeon
generate:
	dart run pigeon --input pigeons/help_scout_api.dart

# Release to pub.dev
release-check:
	dart pub publish --dry-run
	pana .
release:
	dart pub publish