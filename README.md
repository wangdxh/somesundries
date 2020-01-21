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
