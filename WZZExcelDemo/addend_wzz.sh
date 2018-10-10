#!/bin/bash
for var in *.$2; do mv "$var" "${var%.$2}$1.$2"; done
