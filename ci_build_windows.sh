#!/bin/bash
set -e
set delphi_version=7
want release_norename
setup /verysilent /nocancel
acceptance_tests.py