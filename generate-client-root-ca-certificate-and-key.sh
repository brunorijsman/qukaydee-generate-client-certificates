#! /bin/bash

set -e  # Stop script on error

openssl req -x509 \
            -sha256 \
            -days 356 \
            -nodes \
            -newkey rsa:2048 \
            -subj "/CN=client-root-ca" \
            -keyout client-root-ca.key \
            -out client-root-ca.crt \
            >/dev/null \
            2>/dev/null
