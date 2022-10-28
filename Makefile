GODOT ?= bin/godot-headless
EXPORT_FLAG ?= --export

GAME := escapebot9k

# TODO: When https://github.com/cirruslabs/cirrus-ci-docs/issues/305 is
#       resolved, switch to CIRRUS_TASK_NUMBER.

# TODO: Include BUILD_ID and BUILD_HASH in the actual builds, somehow.

BUILD_HASH != git rev-parse --short HEAD
VERSION != ./bin/get-version.sh

all: debug

build_info:
	printf "${VERSION}" > src/version.txt
	echo "{\"version\": \"${VERSION}\", \"build_hash\": \"${BUILD_HASH}\", \"cirrus_task_id\": \""${CIRRUS_TASK_ID}"\"}" > src/build_info.json

linux: build_info
	mkdir -p build/linux
	${GODOT} src/project.godot ${EXPORT_FLAG} linux ../build/linux/${GAME}.x86_64

mac: build_info
	mkdir -p build/mac
	${GODOT} src/project.godot ${EXPORT_FLAG} macos ../build/mac/${GAME}_macos.zp
	mv build/mac/${GAME}_macos.zp build/mac/${GAME}_macos.zip
	cd build/mac && unzip ${GAME}_macos.zip
	rm build/mac/${GAME}_macos.zip

windows: build_info
	mkdir -p build/windows
	${GODOT} src/project.godot ${EXPORT_FLAG} windows ../build/windows/${GAME}.exe

release:
	$(MAKE) EXPORT_FLAG=--export linux windows #mac

debug-linux:
	$(MAKE) EXPORT_FLAG=--export-debug linux

debug-windows:
	$(MAKE) EXPORT_FLAG=--export-debug windows

debug-mac:
	$(MAKE) EXPORT_FLAG=--export-debug mac

debug: debug-linux debug-windows #debug-mac

ci-setup:
	test "${CIRRUS_CI}" = "true" && cp src/export_presets.cfg.cirrus-ci src/export_presets.cfg

test: debug-linux
	@echo "No tests to run. :("

clean:
	rm -rf build/

.PHONY: all build_info linux mac windows release debug-linux debug-windows debug-mac debug ci-setup test clean
