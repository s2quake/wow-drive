#!/bin/bash
pwsh -executionpolicy remotesigned -File $(dirname $0)/zip-addons.ps1 "$@"