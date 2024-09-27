import os
import boto3
import base64
from kubernetes import client, config
from kubernetes.client import ApiException

REGION = os.environ["REGION"]
ENVIRONMENT = os.environ["ENV"]
cert_prefix = os.environ["CERT_PREFIX"]
key_prefix = os.environ["KEY_PREFIX"]
secret_name_to_set = os.environ["SECRET_NAME"]

# Load Kubernetes config
config.load_kube_config()


def get_secret(region, prefix):
    # Create a Secrets Manager client
    secrets_client = boto3.client('secretsmanager', region_name=region)

    try:
        # Initialize an empty list to hold matching secrets
        matching_secrets = []

        # List all secrets with pagination
        paginator = secrets_client.get_paginator('list_secrets')
        for page in paginator.paginate():
            for secret in page['SecretList']:
                if secret['Name'].startswith(prefix):
                    matching_secrets.append(secret['Name'])

        # If any matching secrets are found, retrieve and return the first one
        if matching_secrets:
            secret_name = matching_secrets[0]
            secret_value = secrets_client.get_secret_value(SecretId=secret_name)
            return secret_value['SecretString']
        else:
            print(f"No secrets found with prefix {prefix}")
            return None
    except Exception as e:
        print(f"Error retrieving secrets: {str(e)}")
        return None


def create_tls_secret(secret_name, private_key, certificate, namespace):
    try:
        # Base64 encode the private key and certificate as required by Kubernetes
        private_key_b64 = base64.b64encode(private_key.encode('utf-8')).decode('utf-8')
        certificate_b64 = base64.b64encode(certificate.encode('utf-8')).decode('utf-8')

        # Create the TLS secret body
        secret = client.V1Secret(
            metadata=client.V1ObjectMeta(name=secret_name),
            data={
                'tls.key': private_key_b64,
                'tls.crt': certificate_b64,
            },
            type='kubernetes.io/tls'
        )

        # Create the secret in the specified namespace
        api_instance = client.CoreV1Api()
        api_instance.create_namespaced_secret(namespace=namespace, body=secret)
        print(f"Secret '{secret_name}' created successfully in namespace '{namespace}'")
    except ApiException as e:
        print(f"Exception when creating secret: {e}")


if __name__ == "__main__":
    PRIVATE_KEY = get_secret(REGION, key_prefix)
    CERTIFICATE = get_secret(REGION, cert_prefix)

    if PRIVATE_KEY and CERTIFICATE:
        create_tls_secret(secret_name_to_set, PRIVATE_KEY, CERTIFICATE, ENVIRONMENT)