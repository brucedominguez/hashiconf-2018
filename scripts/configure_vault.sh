#!/bin/bash

# Run this script using root Vault token

# OTP users
echo "Configure the ssh secrets engine for SSH OTP"
vault secrets enable ssh
vault policy write vampires ./policies/vampires.hcl

echo "Configure the auth backend for SSH OTP"
vault auth enable userpass
vault write auth/userpass/users/bob password="password" policies=vampires
vault write ssh/roles/vampires @./roles/vampires.json

# CA users
echo "Configure the ssh secrets engine for SSH CA"
vault write ssh/config/ca generate_signing_key=true
vault policy write zombies ./policies/zombies.hcl

echo "Configure the auth backend for SSH CA"
vault write auth/userpass/users/suzy password="password" policies=zombies
vault write ssh/roles/zombies @./roles/zombies.json

echo "Enable auditing"
vault audit enable file file_path=/tmp/vault_audit.log
