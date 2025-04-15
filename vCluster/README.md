# get started with vCluster

https://www.vcluster.com/docs/get-started

```
md -Force "$Env:APPDATA\vcluster"; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12';
Invoke-WebRequest -URI "https://github.com/loft-sh/vcluster/releases/download/v0.24.1/vcluster-windows-amd64.exe" -o $Env:APPDATA\vcluster\vcluster.exe;
$env:Path += ";" + $Env:APPDATA + "\vcluster";
[Environment]::SetEnvironmentVariable("Path", $env:Path, [System.EnvironmentVariableTarget]::User);
```

```
vcluster create my-vcluster --namespace team-x
```

## start my-vcluster

```
vcluster start my-vcluster
```

## delete my-vcluster

```
vcluster delete my-vcluster --namespace team-x
````
