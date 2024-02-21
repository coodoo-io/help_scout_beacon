# Run example
run:
	cd example && flutter run

# Cleanup
clean:
	flutter clean
	flutter pub get

# Format & Lint
format:
	dart format . --line-length 120
lint:
	dart analyze

# Generate API with Pigeon
generate:
	dart run pigeon --input pigeons/help_scout_api.dart

# Release to pub.dev
release-check:
	dart pub publish --dry-run
release:
	dart pub publish