cd /D %~dp0
set POD_NAME=nginx-c6b697b49-dmkwv
cd html
tar cvzf ..\html.zip .
cd ..
kubectl cp -n nginx html.zip %POD_NAME%:usr/share/nginx/html/html.zip
kubectl exec -it -n nginx %POD_NAME% -- tar -C /usr/share/nginx/html -xvzf /usr/share/nginx/html/html.zip
