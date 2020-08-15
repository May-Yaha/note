# nginx

## 1 使用 nginx 配置 https

### 1.1 设定虚拟主机配置

```bash
server {
    listen              443 ssl;
    server_name         flyaha.top;

    ssl_certificate xxx.pem;
    ssl_certificate_key xxx.key;
    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
    ssl_prefer_server_ciphers on;

    location ~ ^/test$ {
        default_type application/json;
        return 200 '{"errNo":0,"errstr":"success","data":{"messages":[]}}';
    }
}
```

### 1.2 使用