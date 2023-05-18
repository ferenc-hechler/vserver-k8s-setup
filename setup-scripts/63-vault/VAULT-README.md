# Hashicorp Vault

## Install Helm Charts

* https://developer.hashicorp.com/vault/docs/platform/k8s/helm

```
helm repo add hashicorp https://helm.releases.hashicorp.com

# helm search repo hashicorp/vault

helm upgrade --install vault  -n vault --create-namespace hashicorp/vault --version 0.24.0
```

## Initialize and unseal

* https://developer.hashicorp.com/vault/tutorials/kubernetes
* https://github.com/hashicorp/vault-helm/issues/17

```
echo "kubectl exec -it -n vault vault-0 -- vault operator init"
#  Unseal Key 1: UPdx...dw8ED
#  Unseal Key 2: bhav...r4Vf
#  Unseal Key 3: kv8O...z6xq
#  Unseal Key 4: liOP...7MjQ
#  Unseal Key 5: omuv...6/1n
#  Initial Root Token: hvs.GJOd...Ekjp
```

!remember Root Token!

### unseal

```
echo "unseal with 3 of 5 keys"
  
kubectl exec -it -n vault vault-0 -- vault operator unseal
#  Unseal Key (will be hidden): UPdx...w8ED

kubectl exec -it -n vault vault-0 -- vault operator unseal
#  Unseal Key (will be hidden): bhav...r4Vf

kubectl exec -it -n vault vault-0 -- vault operator unseal
#  Unseal Key (will be hidden): kv8O...z6xq
```

## add ingress for vault.k8s.feri.ai

```
kubectl apply -f vault-ing.yaml
```


## videos

* https://developer.hashicorp.com/vault/tutorials/getting-started-ui/getting-started-intro-ui
* https://developer.hashicorp.com/vault/tutorials/getting-started-ui/getting-started-policies-ui

## test cli agent

* https://developer.hashicorp.com/vault/tutorials/vault-agent/agent-quick-start

Download vault binary from [here](https://releases.hashicorp.com/vault/1.13.2/)

```
export VAULT_ADDR=https://vault.k8s.feri.ai

$ vault login -method=userpass username=webapp

Password (will be hidden):
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  hvs.CAESICPcjurHZeWibSBqrvw8b6ocyGT7JJcTgWE2rUPQamdiGh4KHGh2cy5ETk9JWm1XdDZEaEZERWRxcUw0dHUxVnQ
token_accessor         4w4zcPMEwah2CfMWUhmPBxtd
token_duration         768h
token_renewable        true
token_policies         ["default" "webapp"]
identity_policies      []
policies               ["default" "webapp"]
token_meta_username    webapp

$ vault login -agent-address=https://vault.k8s.feri.ai -method=userpass username=webapp

$ cat .vault-token
hvs.CAESIK7dLavQPYaNITYnbTu7NXxaJVVhtZFTOAfbTJiCjADyGh4KHGh2cy5VdzdHek04Tlg1NldqS3F1aWt5R2NlcmU

$ cd vault-test
$ vault kv put secret/customers/acme @data.json


```
