用户态与内核态交互通信的方法不止一种，sockopt是比较方便的一个，写法也简单.
缺点就是使用 copy_from_user()/copy_to_user()完成内核和用户的通信， 效率其实不高， 多用在传递控制 选项 信息，不适合做大量的数据传输

用户态函数：
发送：int setsockopt ( int sockfd, int proto, int cmd, void *data, int datelen);
接收：int getsockopt(int sockfd, int proto, int cmd, void *data, int datalen)
第一个参数是socket描述符；
第二个参数proto是sock协议，IP RAW的就用SOL_SOCKET/SOL_IP等，TCP/UDP socket的可用SOL_SOCKET/SOL_IP/SOL_TCP/SOL_UDP等，即高层的socket是都可以使用低层socket的命令字 的，IPPROTO_IP；
第三个参数cmd是操作命令字，由自己定义；
第四个参数是数据缓冲区起始位置指针，set操作时是将缓冲区数据写入内核，get的时候是将内核中的数 据读入该缓冲区；
第五个参数数据长度

内核态函数
注册：nf_register_sockopt(struct nf_sockopt_ops *sockops)
解除：nf_unregister_sockopt(struct nf_sockopt_ops *sockops)

结构体 nf_sockopt_ops test_sockops 

``` 
static struct nf_sockopt_ops nso = {  
 .pf  = PF_INET,       // 协议族  
 .set_optmin = 常数,    // 定义最小set命令字  
 .set_optmax = 常数+N,  // 定义最大set命令字  
 .set  = recv_msg,   // 定义set处理函数  
 .get_optmin = 常数,    // 定义最小get命令字  
 .get_optmax = 常数+N,  // 定义最大get命令字  
 .get  = send_msg,   // 定义set处理函数  
}; 
```


其中命令字不能和内核已有的重复，宜大不宜小。命令字很重要，是用来做标识符的。而且用户态和内核态要定义的相同，
[cpp] view plain copy

 
#define SOCKET_OPS_BASE          128  
#define SOCKET_OPS_SET       (SOCKET_OPS_BASE)  
#define SOCKET_OPS_GET      (SOCKET_OPS_BASE)  
#define SOCKET_OPS_MAX       (SOCKET_OPS_BASE + 1)  

set/get处理函数是直接由用户空间的 set/getsockopt函数调用的。 setsockopt函数向内核写数据，用getsockopt向内核读数据。
另外set和get的处理函数的参数应该是这样的
int recv_msg(struct sock *sk, int cmd, void __user *user, unsigned int len)
int send_msg(struct sock *sk, int cmd, void __user *user, unsigned int *len)
