# Conjur Quick Start

* https://www.conjur.org/get-started/quick-start/define-policy/


```
$ conjur policy load -b root -f BotApp.yml
  {
    "created_roles": {
        "default:user:Dave@BotApp": {
            "id": "default:user:Dave@BotApp",
            "api_key": "17m7...h1tz"
        },
        "default:host:BotApp/myDemoApp": {
            "id": "default:host:BotApp/myDemoApp",
            "api_key": "490...qsvz"
        }
    },
    "version": 1
  }
```

logout as admin

```
$ conjur logout
    Successfully logged out from Conjur
```

login as dave

```
$ conjur login -i Dave@BotApp
  Enter your password or API key (this will not be echoed): 17m7...h1tz
  Successfully logged in to Conjur
  
  
$ conjur whoami
  {
    "client_ip": "10.244.0.225",
    "user_agent": "Python/3.10 aiohttp/3.8.1",
    "account": "default",
    "username": "Dave@BotApp",
    "token_issued_at": "2023-06-06T20:43:15.000+00:00"
  }  
```

# create a secret

```
$ secretVal=$(openssl rand -hex 12 | tr -d '\r\n')

$ conjur variable set -i BotApp/secretVar -v ${secretVal}
    Successfully set value for variable 'BotApp/secretVar'
```

# host login

```
$ conjur -d login -i host/BotApp/myDemoApp -p 490v....qsvz

2023-06-06 23:13:50,100 DEBUG: Attempting to fetch 'host/BotApp/myDemoApp' API key from Conjur...
2023-06-06 23:13:50,101 DEBUG: Invoke endpoint. Verb: 'GET', Endpoint: 'LOGIN', Params: '{'url': 'https://conjur.k8s.feri.ai', 'account': 'default'}', Data length: '0', Check errors: 'True', SSL verification metadata: '{'mode': <SslVerificationMode.TRUST_STORE: 0>, 'ca_cert_path': None}', Basic auth user: 'host/BotApp/myDemoApp', using API token: 'False', Query params: 'None', Headers: 'None', Decode token: 'True'
2023-06-06 23:13:50,102 DEBUG: Using selector: SelectSelector
2023-06-06 23:13:50,106 DEBUG: Creating SSLContext from OS TrustStore for 'Windows'
2023-06-06 23:13:50,122 DEBUG: SSLContext created successfully
2023-06-06 23:13:50,293 DEBUG: Invoke endpoint succeeded. Duration: 187ms, Request: GET https://conjur.k8s.feri.ai/authn/default/login, Response: {'status': 200, 'content length': '55'}
2023-06-06 23:13:50,293 DEBUG: API key retrieved from Conjur
2023-06-06 23:13:50,295 DEBUG: Attempting to save credentials to the system's credential store 'Windows WinVaultKeyring'...
2023-06-06 23:13:50,335 DEBUG: Credentials saved to the 'Windows WinVaultKeyring' credential store
Successfully logged in to Conjur
```

# curl secret

create token

```
curl -d "490v....qsvz" -k "https://conjur.k8s.feri.ai/authn/default/host%2FBotApp%2FmyDemoApp/authenticate" > /tmp/conjur_token

{
  "protected": "eyJhbGciOiJjb25qdXIub3JnL3Nsb3NpbG8vdjIiLCJraWQiOiI1ZjJmNWJiNjdmOTU3YmMzMGEzZjE4YTI2YzJkMDMwODU2ZTk4MWFjNTAxNjdiYjRmNDYyMmEyN2NhNmJhNWY0In0=",
  "payload": "eyJzdWIiOiJob3N0L0JvdEFwcC9teURlbW9BcHAiLCJleHAiOjE2ODYwODY2OTQsImlhdCI6MTY4NjA4NjIxNH0=",
  "signature": "PqQ5AMQB2vjM_eg09CKFFkevOZmmCA720yHrvj0d0aBPVM9_LoY7N2Dwd7StD0IWcah614iuxZgrppjBrWwsruoHpa6sCZepUTSPs3oVKNErj0QqHb4lsHzOuU-W4rVhVEZWLjUFU0qgQc87r5NjDtqGqCED8D76zy8DeSOLd2yIXcedDfrgk_OQtXBRTipOrVuBFNuwzlSxgUY2kIMIL6cdBGtFcKQVI40m_y1z5vGSrvb9YEBzRJ_RxtUL3EGqhgVWutv0n579d4bqJc5PLpIK3sZ0E2MMkRT4B8Zx3TYDrCFvLBtggZlHYoUIMnoBXl51Hv_xsQZQyxLoPSKWNCNB-SVNX6MkjMAWLyKeZ1KLL25-EChSQFZNe9H7HEuX"
}

payload(decoded): 
{"sub":"host/BotApp/myDemoApp","exp":1686086694,"iat":1686086214}
```

retrieve value:

```
CONT_SESSION_TOKEN=$(cat /tmp/conjur_token| base64 | tr -d '\r\n')
VAR_VALUE=$(curl -s -k -H "Content-Type: application/json" -H "Authorization: Token token=\"$CONT_SESSION_TOKEN\"" https://conjur.k8s.feri.ai/secrets/default/variable/BotApp%2FsecretVar)
echo $VAR_VALUE
  17ec2d4f48d96b0cb4df3c5f
```

# Interactive Tutorial Kubernetea

* https://www.conjur.org/get-started/interactive/
* https://www.conjur.org/get-started/interactive/secure-kubernetes-secrets/



