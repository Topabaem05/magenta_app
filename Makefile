SHELL := /bin/bash

.PHONY: bootstrap generate pods test lint format validate-assets validate-repo verify clean

bootstrap: generate pods

generate:
	command -v xcodegen >/dev/null || { echo "Install XcodeGen: brew install xcodegen"; exit 1; }
	xcodegen generate

pods:
	command -v bundle >/dev/null || { echo "Install Bundler first"; exit 1; }
	bundle install
	bundle exec pod install

test:
	swift test

lint:
	swift-format lint --recursive --strict Sources Tests

format:
	swift-format format --recursive --in-place Sources Tests

validate-assets:
	python3 scripts/validate_model_assets.py --manifest Resources/Models/model-assets.json --root Resources/Models

validate-repo:
	python3 scripts/check_scaffold.py
	python3 scripts/check_repository.py

verify: test lint validate-repo
	python3 -m unittest discover -s tests -p 'test_*.py' -v

clean:
	rm -rf .build build DerivedData MotifGrid.xcodeproj MotifGrid.xcworkspace Pods
