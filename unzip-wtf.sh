#!/bin/bash
pwsh -executionpolicy remotesigned -File $(dirname $0)/unzip-wtf.ps1 "$@"