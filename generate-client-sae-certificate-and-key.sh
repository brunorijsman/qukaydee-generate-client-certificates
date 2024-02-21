#! /bin/bash

# Stop script on error
set -e

# Parse command line
if [[ "$#" -ne 1 ]]; then
    echo "Usage: create-client-sae-certificate-and-key.sh <certified-client-host-name>"
    exit 1
fi
client_name="$1"

# Root CA private key file must exist
if [[ ! -f client-root-ca.key ]]; then
    echo "Client root CA key file 'client-root-ca.key' not found in current directory."
    echo "Run create-client-root-ca-certificate-and-key.sh first"
    exit 1
fi

# Generate client private key
openssl genrsa \
    -out ${client_name}.key 2048 \
    >/dev/null \
    2>/dev/null

# Generate client certificate signing request configuration
cat > ${client_name}.csr.conf <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn
[dn]
CN = ${client_name}
[req_ext]
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${client_name}
EOF

# Generate client certificate signing request
openssl req \
    -new \
    -key ${client_name}.key \
    -out ${client_name}.csr \
    -config ${client_name}.csr.conf \
    >/dev/null \
    2>/dev/null


# Generate client certificate configuration
cat > ${client_name}.cert.conf <<EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = ${client_name}
EOF

# Generate client certificate
openssl x509 -req \
             -in ${client_name}.csr \
             -CA client-root-ca.crt \
             -CAkey client-root-ca.key \
             -CAcreateserial \
             -out ${client_name}.crt \
             -days 365 \
             -sha256 \
             -extfile ${client_name}.cert.conf \
             >/dev/null \
             2>/dev/null

# Create the client PEM file (combined private key and certificate chain)
cat ${client_name}.key ${client_name}.crt client-root-ca.crt > ${client_name}.pem

# Cleanup all intermediate files, except key and certificate
# Curl wants .pem file
# Postman wants .crt and .key file
rm ${client_name}.csr.conf
rm ${client_name}.csr
rm ${client_name}.cert.conf
