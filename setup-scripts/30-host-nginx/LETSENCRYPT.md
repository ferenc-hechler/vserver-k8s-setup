# LEGO

https://community.letsencrypt.org/t/dns-providers-who-easily-integrate-with-lets-encrypt-dns-validation/86438

https://go-acme.github.io/lego/dns/

https://go-acme.github.io/lego/dns/hostingde/



```
HOSTINGDE_API_KEY='xxxxxxxx'
lego --email ferenc.hechler@gmail.com --dns hostingde --domains 'cluster-4.de' run
lego --email ferenc.hechler@gmail.com --dns hostingde --domains '*.cluster-4.de' run
lego --email ferenc.hechler@gmail.com --dns hostingde --domains '*.k8s.cluster-4.de' run

lego --email ferenc.hechler@gmail.com --dns hostingde -d 'cluster-4.de' renew
lego --email ferenc.hechler@gmail.com --dns hostingde -d '*.cluster-4.de' renew
lego --email ferenc.hechler@gmail.com --dns hostingde -d '*.k8s.cluster-4.de' renew

kubectl create secret -n istio-ingress tls wc-k8s-cluster-4-de-tls2 --key=.lego/certificates/_.k8s.cluster-4.de.key --cert=.lego/certificates/_.k8s.cluster-4.de.crt
```


https://github.com/go-acme/lego/releases/download/v4.16.1/lego_v4.16.1_linux_amd64.tar.gz

# Cert Manager

https://cert-manager.io/docs/configuration/acme/dns01/#supported-dns01-providers