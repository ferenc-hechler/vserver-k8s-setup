# Conjur Open Source

## Install Helm Charts

* https://github.com/cyberark/conjur-oss-helm-chart/tree/main/conjur-oss

```
CONJUR_NAMESPACE=conjur
kubectl create namespace "$CONJUR_NAMESPACE"
DATA_KEY="$(docker run --rm cyberark/conjur data-key generate)"
HELM_RELEASE=conjur
VERSION=2.0.6
helm upgrade --install -n "$CONJUR_NAMESPACE" --values values.yaml --set dataKey="$DATA_KEY" "$HELM_RELEASE" https://github.com/cyberark/conjur-oss-helm-chart/releases/download/v$VERSION/conjur-oss-$VERSION.tgz
```

output:

```
NAME: conjur
LAST DEPLOYED: Tue Jun  6 20:13:43 2023
NAMESPACE: conjur
STATUS: deployed
REVISION: 1
NOTES:

1. Get the application URLs. These should match the configured SSL values:
  - https://conjur.k8s.cluster-4.de

  It may take 1-10 minutes for the LoadBalancer IP to be available. You can watch
  the status of the progress by running:

      kubectl get svc \
          --namespace conjur \
          -w conjur-conjur-oss-ingress

  and waiting until you have a value in "EXTERNAL-IP" column.

  If you are running MiniKube, you can run:

      minikube service conjur-conjur-oss-ingress --url

  to see the external IP and port. If using MiniKube, also make sure to use "https"
  scheme instead of the "http" that MiniKube will print out.

  Once the external ingress is available, you can get the service endpoint by running:

      export SERVICE_IP=$(kubectl get svc --namespace conjur \
                                          conjur-conjur-oss-ingress \
                                          -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
      echo -e " Service is exposed at ${SERVICE_IP}:443\n" \
              "Ensure that domain "conjur.myorg.com" has an A record to ${SERVICE_IP}\n" \
              "and only use the DNS endpoint https://conjur.myorg.com:443 to connect.\n"

  Note: You must have a DNS name matching the SSL hostname (or otherwise one of the SSL
        alternate names) rather that the raw IP when connecting to the service with Conjur
        CLI tool or SSL verification will fail on logging in. If you are just locally testing
        things, you can work around the DNS mapping by adding the following entry to your
        /etc/hosts file: "$SERVICE_IP  conjur.myorg.com"


2. Configure Conjur Account

  To create an initial account and login, follow the instructions here:
  https://www.conjur.org/get-started/install-conjur.html#install-and-configure

      export POD_NAME=$(kubectl get pods --namespace conjur \
                                         -l "app=conjur-oss,release=conjur" \
                                         -o jsonpath="{.items[0].metadata.name}")
      kubectl exec --namespace conjur \
                   $POD_NAME \
                   --container=conjur-oss \
                   -- conjurctl account create "default" | tail -1

  Note that the conjurctl account create command gives you the
  public key and admin API key for the account administrator you created.
  Back them up in a safe location.

3. Connect to Conjur

  Start a container with Conjur CLI and authenticate with the new user:

      docker run --rm -it --entrypoint bash cyberark/conjur-cli:8
      # Or if using MiniKube, use the following command from the host:
      # docker run --rm -it --network host --entrypoint bash cyberark/conjur-cli:8

      # Here ENDPOINT is the DNS name https endpoint for your Conjur service.
      # NOTE: Ensure that the target endpoint matches at least one of the expected server
      #       SSL certificate names otherwise SSL verification will fail and you will not
      #       be able to log in.
      # NOTE: Also ensure that the URL does not contain a slash (`/`) at the end of the URL
      conjur init -u <ENDPOINT> -a "default" --self-signed

      # API key here is the key that creation of the account provided you in step #2
      conjur login -i admin -p <API_KEY>

      # Check that you are identified as the admin user
      conjur whoami

4. Next Steps
  - Go through the Conjur Tutorials: https://www.conjur.org/tutorials/
  - View Conjur's API Documentation: https://www.conjur.org/api.html
```

## install ingress

```
kubectl apply -f conjur-service.yaml
kubectl apply -f conjur-ing.yaml
```


## create an initial account 

* https://www.conjur.org/get-started/install-conjur.html#install-and-configure
  
```
kubectl exec -it -c conjur-oss conjur-conjur-oss-755997cdf7-72k5q -- /bin/bash
```

in container:

```
conjurctl account create "default"

Created new account 'default'
Token-Signing Public Key: -----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAm+CwkxQY5zuxBsFXM/dS
................................................................
GQIDAQAB
-----END PUBLIC KEY-----
API key for admin: 3eqa.....1j41
```


```
sudo docker run --rm -it --entrypoint /bin/sh cyberark/conjur-cli:8
```

in docker container:

```
conjur init -u https://conjur.k8s.cluster-4.de -a "default"       # --self-signed

  Warning: Using self-signed certificates is not recommended and could lead to exposure of sensitive data

  The server's certificate fingerprint is 02:35:28:04:C8:DC:AC:9A:99:30:94:EF:81:88:35:FB:EC:07:D8:96.
  Please verify this certificate on the appliance using command:
  openssl x509 -fingerprint -noout -in ~conjur/etc/ssl/conjur.pem

  ? Trust this certificate? Yes
  Wrote certificate to /root/conjur-server.pem
  Wrote configuration to /root/.conjurrc

conjur login -i admin -p 3eqa........1j41
  Logged in

conjur whoami

  {
    "client_ip": "10.244.0.225",
    "user_agent": "Go-http-client/1.1",
    "account": "default",
    "username": "admin",
    "token_issued_at": "2023-06-06T19:06:35.000+00:00"
  }
```

# Download Conjur CLI Windows 

* https://github.com/cyberark/cyberark-conjur-cli/releases
* https://github.com/cyberark/cyberark-conjur-cli/releases/download/v7.1.0/conjur-cli-windows.zip

