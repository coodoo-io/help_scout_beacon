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
	$(MAKE) github-release

# Tag + GitHub release for the version in pubspec.yaml, with the matching
# CHANGELOG.md section as release notes. Tags are bare versions (no v prefix).
github-release:
	@VERSION=$$(sed -n 's/^version: //p' pubspec.yaml); \
	if gh release view "$$VERSION" >/dev/null 2>&1; then \
		echo "GitHub release $$VERSION already exists, skipping."; \
	else \
		NOTES=$$(mktemp); \
		awk -v v="$$VERSION" '$$0 == "## [" v "]" {flag=1; next} /^## \[/ {flag=0} flag' CHANGELOG.md > "$$NOTES"; \
		gh release create "$$VERSION" --title "$$VERSION" --notes-file "$$NOTES"; \
		rm -f "$$NOTES"; \
	fi