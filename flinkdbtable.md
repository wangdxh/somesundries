#### overview
get /overview
``` json
{
    "runningjobs":0,    统计用户添加的job，cron的历史不统计
    "finishedjobs":1,
    "failedjobs":2,
    "totaljobs":3,
    "alletltotalnums":5000,  所有job的值统计在一起
    "alletlfailednums“:500
}
```

post /trend/etl  
```json
{
    "starttime":"",
    "endtime":"“
}
{
    [
        {
            统计趋势表的条目
        }
    ]
}
```
get /trend/jobs

mysql talbe overviewtrend 统计趋势表：  
collecttime，runningjobs，finishedjobs，failedjobs，totaljobs，alletltotalnums，alletlfailednums  
统计趋势已经是总统计值了，按照固定间隔进行统计，查询时，指定开始和结束时间。

统计趋势表2:
collecttime，jobid，etltotalnums，etlfailednums  
根据jobid，开始和结束时间来查询，按照固定时间间隔，进行统计， cron的job 统计时，计算所有的cron产生的job的结果


#### job

job 表
| 字段        | 描述    |
| -------- | --------  |
| jobid | job的唯一id|
| jobname | job名称 |
| mode |  执行模式 enum：once，cron <br> |
|startnow  | 立即开始|
|cron | 表达式  |
|startlimittime |允许job运行的时间区间，cron的任务，调度时，如果超过这个区间，则不进行调度|
|endlimittime  |区间的结束点|
|sourcetype | 源的类型： file， db|
|sourcesubtype| 源的子类型： csv， mysql，oracle等|
|sinktype | 目的类型 同源类型|
|sinksubtype|目的子类型|
|runingstatus|job运行状态： running，waiting，failed，finished，canceled|
|status | job的状态，默认创建的job 时暂停状态  enum：started,paused,stopped|
|parallelnum |并发数|
|maxattempts |最大重试次数|
|curattempts |当前重试次数|
|etltotalnums | 所有cron产生的任务，累计处理的结果|
|etlfailednums  | 所有cron产生的任务，累计失败的条目|
|maxfailednums|cron时，单个任务的错误数，超过这个值时，主动关闭任务|
|jobconfig| 生成的jobconfig配置|
|createtime|job创建时间|
|author|创建人，暂时只支持一个用户 admin|
|lasttaskstarttime|任务的最后启动时间|
| nextschedutime|下一次的调度时间|
|curtaskid|job 对应的task的id|
|webconfig|来自web的配置|

增删改查， 根据任务名，创建时间段，状态进行过滤

webconfig的定义
``` json
{
    "source":{
        "sourcetype":"file, db",
        "sourcesubtype":"csv, mysql",
        "datasourcename":"xxx", 原封不动，给前端保存

        "csv":{
            "filepath":"/mnt/sbc*.csv",
            "charset":"utf8",  字符集
            "skipheader":true, 是否跳过头
            "splitstr":"," 分隔符
            "columns":[
                {
                    "colname":"col1",  列名等价于mysql的列名，给出所有的列名和列类型信息，没有类型的话，就是string
                    "type": ["STRING", "LONG", "INTEGER", "FLOAT"]
                }
            ]
        }
        "db":{
            得到总数： select count（*） from a where ();
            合成一个sql的查询语句 
            第一次 select * from a where () order by col1 limit 500;
            根据col1，将col1的值保存到state中；
            之后
            select * from a where () and col2 > ? order by col1 limit 500
            "databasename"："", 或者写成一个jdbc的url
            "username":"",
            "passwd":"",
            "tablename":"table2",
            "colunamenmae":"col2",
            "where":"a>b or ..",
            "incremental":true, 是否增量, 增量时没有数据时，sleep 500毫秒，再次查询，非增量，没有数据直接退出。

            #忽略了 jdbc url中 字符集和时区选择等


        }
    },
    "sink":{
        "sinktype":"db",
        "sinksubtype":"mysql",
        "datasourcename":"",数据源的名称 原封不动，给前端保存
        "db":{
            INSERT INTO table_name (column1,column2,column3)VALUES (?,?,?) ON DUPLICATE KEY UPDATE column1 = VALUES(column1)，......; 需要提取出 需要插入的列名。一定要可以重复插入， 也是批量1000条

            "databasename"："", 或者写成一个jdbc的url
            "username":"",
            "passwd":"",
            "tablename":"table2",
        }
    },
    "etl":[
        {
            sourceitem:["col1", "col2"],
            sinkitem:"sincol1",
            transform:"func1($col1, $col2)"
        },
        {
            sourceitem:["col3"],
            sinkitem:"sinkcol2",
            transform:"func2($col3)"
        },
        根据列表顺序，推导出mysql的sink item的列名和顺序，用于生成insert语句，根据transform生成groovy文件
    ]
}
```

task
|字段|描述|
|-----|------|
|taskid|执行任务id|
|jobid|对应的jobid|
|flinkjobid|对应的flinkid|
|starttime|开始时间|
|endtime|结束时间|
|etltotalnums| 单个task的统计信息，当cron 或者单次job运行时，etl的总数，由job中的统计总数 加上 当前task的统计，当task结束时，job中的总数更新为加上task上的统计数据，curtaskid 清空|
|etlfailednums||
|flinkstatistics|flink的统计，需要根据source，sink的类型，去判断应该取什么样的字段，去生成etl的统计条目|
|exceptmsg|task执行，异常的信息|
|runningstate|和job里面的状态值，保持相同|

flinkstatistics  
文件处理 FileoffsetAccumulator
``` json
[ 
    {
        "filename" : "/opt/flinkdata/flinkjob/filesystemsource/data/fruits.csv",
        "fileoffset" : 1008665,
        "processednum" : 39443, 
        "filesize" : 1008665, 
        "isover" : true, 
        "errormsg" : "" 
    }
    ...
]
```
csv处理：
TransAccumulator
```
{ 
    "processedNum" : 180086, 
    "failNum" : 0, 
    "excepMap" : { } 
}
```
groovy处理：
TransAccumulator
```
{ 
    "processedNum" : 210097, 
    "failNum" : 30011, 
    "excepMap" : { 
        "For input string: \"yield\"" : 30011 
    } 
}
```
数据库源处理：
后续增加
```
{
    "processedNum":2000,
    "totalNum":30000
}
```


