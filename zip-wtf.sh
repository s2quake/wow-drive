#!/bin/bash
pwsh -executionpolicy remotesigned -File $(dirname $0)/zip-wtf.ps1 "$@"