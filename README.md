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

#### centos 防火墙

```bash
firewall-cmd --permanent --zone=public --add-service=https --add-service=http
firewall-cmd --reload
```

#### mongo 数据备份

```bash
mongodump -h 127.0.0.1:27017 -d <dbname> -o <dbdirectory>
```

#### mongo 数据恢复

```bash
mongorestore -h 127.0.0.1:27017 -d <dbname> <path>
```

#### scp

```bash
scp -r /home/a.js root@192.168.1.8:/home
```
