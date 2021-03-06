
# Protobuf mapping
* json schema和protobuf的定义之间有隐含的一一映射关系，包括基本的数据类型，对象，数组，枚举；protobuf不包含oneof anyof，在某些情况下json字段转protobuf需要改变类型和格式。  
* 定义基本的转换描述如下,默认转换规则的不需要定义，只列出来需要转换的字段列表，json中需要转换的key，可以使用json schema中的路径格式(#/properties/abc)，也可以使用jsonpath的路径格式($.abc)。
```json
{
    "type":"jsontoprotobuf",
    "title":"",
    "source":"test.json", #字段值唯一指向某个json即可；可以通过json中的title来确定json对象的名称，或者文件名都可以。

    "package":"www.kedacom.pb",
    "mappings":[
        {
            "$ref":"$.abc.cdef",
            "type":"object",
            "properites":{
                "newdata":{
                    "type":"integer",
                }
            }
        },
        ......
    ]
}
```
* mappings 定义了字段之间的映射，默认情况下类型明确的json schema定义可以固定转为protobuf，特殊字段需要进行映射时可以单独定义。
* 可以进行单个字段类型的转换，或者字段到对象，对象到字段等转换；$ref指向原数据，其他字段表示转换后的数据类型。
* 暂时只单独定义类型格式的转换，用于protobuf文件生成；如果有些数据转换简单，可以扩展transform的字段，进一步生成 json对象到protobuf对象之间的转换代码。
* 更多protobuf需要的信息，可以在格式中扩展。

# Database mapping
* 数据库的映射格式和pb不同，因为json schema和database的定义之间没有任何隐含的的映射关系。
* mappings 定义了数据库字段的类型和protobuf中的数据对应关系，$ref指向protobuf中的字段，其余字段描述数据库列信息。
```json
{
    "type":"protobuftodatabase",
    "source":"test.proto", #字段值指向唯一proto对象即可
    "database":"mydb",
    "table":"mytable",
    "mappings":[
        {
            "colname":"tablecolumn1",
            "type":"interger",
            "primarykey":2, #cdb中通过数值决定主key顺序
            "$ref":"$.abc.cdef"
        },
        {
            "colname":"tablecolumn2",
            "type":"interger",
            "primarykey":1,
            "$ref":"$.abc.cdef2"
        },
        {
            "colname":"tablecolumn3",
            "type":"string",
            "$ref":"$.abc2"
        }
    ]
}
```
* 主要定义protobuf字段和数据库表字段之间的一一映射，当出现 $ref 指向的类型是个数组的某个字段时，需要对数组进行遍历，生成多个写入数据库的记录。
* 更多数据库字段的特定需求，需要进行扩展

# HTTP services
* http微服务定义了 元数据和微服务之间的映射
  
``` json
{
    "type":"jsontohttp",
    "netty":{
        "port":8080,
        "workerthreads":3,
        "listenthreads":1,
        ......
    },
    "mappings":[
        {
            "source":"test.json",  #字段值唯一指向某个json对象即可
            "url":"/somepath/someurl",
            "method":"get"
        },
        {
            "source":"test2.json",
            "url":"/somepath/someurl2",
            "method":"post"
        },
        ......
    ]
}
```

# JsonSchema

## 支持的类型
### type
type类型定义支持单个类型和类型数组，数组谨慎使用
#### string
``` json
{
    "type" : "string",
    "minLength" : 2,
    "maxLength" : 3,
    "pattern" : "^(\\([0-9]{3}\\))?[0-9]{3}-[0-9]{4}$",
    "format" : "date"
} 
Json Schema支持的format包括"date", "time", "date-time", "email", "hostname"等
```
#### number
``` json
{
    "type" : "number",
    "multipleOf" : 10,
    "minimum":20,
    "maximum":40,
    "exclusiveMinimum":50,
    "exclusiveMaximum":60
}
```
#### array
原则上items列表类型定义时，不支持多种类型定义。
``` json
{
    "type": "array",
    "items": {
        "type": "number"
    },
    "additionalItems":true,
    "minItems" : 5,
    "maxItems" : 10,
    "uniqueItems" : true
}
```
#### object
patternProperties 不建议使用
``` json
{ 
    "type": "object",     
    "properties": {      
        "name": {"type" : "string"},
        "age" : {"type" : "integer"},
    },
     "required":["name"],
     "dependencies": {
        "age": ["name"]
    },
    "additionalProperties":true,
    "minProperties": 2,
    "maxProperties": 3
}
```

#### boolean
``` json
 {
     "tyep":"boolean"
 }
```

#### allOf, anyOf, oneOf, not
``` json
{
	"type": "object",
	"properties": {
		"count": {
			"allOf": [{
			  "type": "number"
			},
			{
			  "minimum": 90
			}]
		}
	}
}
allof 所有条件满足时，校验才会通过;anyof 只要有一个，oneof有且只有一个，not 不满足指定schema条件。
```

#### enum
可以在任何json schema中出现，其value是一个list，表示json数据的取值只能是list中的某个。
``` json
{
    "type": "string",
    "enum": ["red", "amber", "green"]
}
```
#### metadata
``` json
{
    "title" : "Match anything",
    "description" : "This is a schema that matches anything.",
    "default" : "Default value",
    "examples" : [
        "Anything",
        4035
    ]
}
```
### $ref $id
* 关键字$ref可以用在任何需要使用json schema的地方,支持http，file跨文件。
* 可以在上面的定义中加入id属性，这样可以通过id属性，这样可以通过id属性的值对该schema进行引用，而不需要完整的路径。

### 扩展
``` json
{
    "updatedDate" : {
            "type" : "string",
            "format" : "date-time",
            "customDateTimePattern" : "yyyy-MM-dd'T'HH:mm:ssZ",
            "customTimezone": "PDT"
        }
}
```

1. 扩展时区和时间格式  
2. object扩展 "javaType" : "com.other.package.CustomTypeName"  
3. 全局扩展：“package” : “com.kedacom" 默认类名按照json文件名  
可以参考 http://www.jsonschema2pojo.org

  
