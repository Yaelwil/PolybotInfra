import os
from get_secret import get_secret, create_tls_secret

REGION = os.environ["REGION"]

cert_prefix_dev = os.environ["CERT_PREFIX_DEV"]
key_prefix_dev = os.environ["KEY_PREFIX_DEV"]
secret_name_dev = "tls-secret-dev"

cert_prefix_prod = os.environ["CERT_PREFIX_PROD"]
key_prefix_prod = os.environ["KEY_PREFIX_PROD"]
secret_name_prod = "tls-secret-prod"


PRIVATE_KEY_DEV = get_secret(REGION, key_prefix_dev)
CERTIFICATE_DEV = get_secret(REGION, cert_prefix_dev)

PRIVATE_KEY_PROD = get_secret(REGION, key_prefix_prod)
CERTIFICATE_PROD = get_secret(REGION, cert_prefix_prod)

create_tls_secret(secret_name_dev, key_prefix_dev, cert_prefix_dev, "dev")
create_tls_secret(secret_name_prod, key_prefix_prod, cert_prefix_prod, "prod")
