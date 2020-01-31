瞎JB写的一些脚本，用于 VPS 迁移

## Usage

安装我的所有服务

```bash
chmod +x ./install.sh && sudo ./install.sh
```

安装某一个服务

```bash
chmod +x ./scripts/how-old.sh && sudo ./scripts/how-old.sh
```

## others

nginx 防火墙

```bash
firewall-cmd --permanent --zone=public --add-service=https --add-service=http
firewall-cmd --reload
```
