#!/bin/bash
pwsh -executionpolicy remotesigned -File $(dirname $0)/unzip-addons.ps1 "$@"