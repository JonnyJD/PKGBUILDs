#!/bin/bash
exec readelf -Ws $1 | awk '{print $8}'
