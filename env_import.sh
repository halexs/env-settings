#!/usr/bin/env bash
# Kept for backwards compatibility. The Makefile does the real work now.
cd "$(dirname "$0")" && exec make install "$@"
