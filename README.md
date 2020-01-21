# hashmd5

http://www.cnblogs.com/yuxc/archive/2012/06/22/2558312.html

深入云存储系统Swift核心组件：Ring实现原理剖析


# protobuf
https://www.cnblogs.com/Binhua-Liu/p/5577622.html  
Protobuf3 + Netty4: 在socket上传输多种类型的protobuf数据  
nesty  
  
https://github.com/netty/netty/blob/0cde4d9cb4d19ddc0ecafc5be7c5f7c781a1f6e9/codec/src/main/java/io/netty/handler/codec/protobuf/ProtobufDecoder.java  

```java
Message.Builder builder =SomeProto.newBuilder();
String jsonFormat = _load json document from a source_;
JsonFormat.merge(jsonFormat, builder);
```

# Druid
https://blog.csdn.net/matrix_google/article/details/82878214   
时序数据库技术体系 – Druid 多维查询之Bitmap索引   

# docker
docker pull centos:7.4.1708  

在本机执行  
sudo docker save -o ubuntu.tar ubuntu  
  
由此得到了 ubuntu.tar 文件，将其拷贝到远程机器，执行  
  
sudo docker load < ubuntu.tar  

### 启动docker
sudo docker run --privileged --cap-add SYS_ADMIN -e container=docker -it --name my_centos -p 80:80  -d  --restart=always centos /usr/sbin/init    
--privileged 指定容器是否是特权容器。这里开启特权模式。  
--cap-add SYS_ADMIN 添加系统的权限。否则系统很多功能都用不了的。  
-e container=docker 设置容器的类型。  
-it 启动互动模式。  
--name 取别名 my_centos  
-p 端口映射,把80端口映射到容器的80端口。  
-d 放入后台  
--restart=always 在启动时指定自动重启  
/usr/sbin/init 初始容器里的centos。  
以上的参数是必需的。否则建立的centos容器不能正常使用和互动  
如果没有-it参数，容器会不停启动。  
如果没有初始化和特权等等的开关，就不能使用systemctl。所以，以上的开关和设置是一样不能少的。  
  
docker run --privileged --cap-add SYS_ADMIN -it --name my_centos -p 8888:8888 -d --restart=always centos:7.4.1708 /usr/sbin/init
### 进入容器  
docker exec -it my_centos /bin/bash   

