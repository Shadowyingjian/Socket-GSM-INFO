    //串口相关的头文件  
    #include<stdio.h>      /*标准输入输出定义*/  
    #include<stdlib.h>     /*标准函数库定义*/  
    #include<unistd.h>     /*Unix 标准函数定义*/  
    #include<sys/types.h>   
    #include<sys/stat.h>     
    #include<fcntl.h>      /*文件控制定义*/  
    #include<termios.h>    /*PPSIX 终端控制定义*/  
    #include<errno.h>      /*错误号定义*/  
    #include<string.h>  
    #include <time.h>      
    //宏定义  
    #define FALSE  -1  
    #define TRUE   0  

  int err_count = 0;
  char *f_name = "test.txt";
	
typedef struct GSM_INFO{
	char Main_Info[100];
	char Serving_Cell[200];
	char LTE_Intra[100];
	char LTE_Intra_Cell1[100];
	char LTE_Inter[100];
	char GSM_Info[200];
	char WCDMA_Info[200];
	char CDMA1x_Info[100];
	char CDMAprpd_Info[100];
	char CDrx_Cfg[100];
	char Cqi_Cfg[100];
	char Ant_Cfg[100];
	char Idle_Drx_Cfg[100];
};   


    /******************************************************************* 
    * 名称：                  UART0_Open 
    * 功能：                打开串口并返回串口设备文件描述 
    * 入口参数：        fd    :文件描述符     port :串口号(ttyS0,ttyS1,ttyS2) 
    * 出口参数：        正确返回为1，错误返回为0 
    *******************************************************************/  
    int UART0_Open(int fd,char* port)  
    {  
         
    	fd = open( port, O_RDWR|O_NOCTTY|O_NDELAY);  
    	if (FALSE == fd)  
    	{  
    		perror("Can't Open Serial Port");  
    		return(FALSE);  
    	}  
    	//恢复串口为阻塞状态                                 
    	if(fcntl(fd, F_SETFL, 0) < 0)  
    	{  
    		printf("fcntl failed!\n");  
    		return(FALSE);  
    	}       
    	else  
    	{  
    		printf("fcntl=%d\n",fcntl(fd, F_SETFL,0));  
    	}  
    	//测试是否为终端设备      
    	if(0 == isatty(STDIN_FILENO))  
    	{  
    		printf("standard input is not a terminal device\n");  
    		return(FALSE);  
    	}  
    	else  
    	{  
    		printf("isatty success!\n");  
    	}                
    	printf("fd->open=%d\n",fd);  
    	return fd;  
    }  
    /******************************************************************* 
    * 名称：                UART0_Close 
    * 功能：                关闭串口并返回串口设备文件描述 
    * 入口参数：        fd    :文件描述符     port :串口号(ttyS0,ttyS1,ttyS2) 
    * 出口参数：        void 
    *******************************************************************/  
       
    void UART0_Close(int fd)  
    {  
    	close(fd);  
    }  
       
    /******************************************************************* 
    * 名称：                UART0_Set 
    * 功能：                设置串口数据位，停止位和效验位 
    * 入口参数：        fd        串口文件描述符 
    *                              speed     串口速度 
    *                              flow_ctrl   数据流控制 
    *                           databits   数据位   取值为 7 或者8 
    *                           stopbits   停止位   取值为 1 或者2 
    *                           parity     效验类型 取值为N,E,O,,S 
    *出口参数：          正确返回为1，错误返回为0 
    *******************************************************************/  
    int UART0_Set(int fd,int speed,int flow_ctrl,int databits,int stopbits,int parity)  
    {  
         
    	int   i;  
    	int   status;  
    	int   speed_arr[] = { B115200, B19200, B9600, B4800, B2400, B1200, B300};  
    	int   name_arr[] = {115200,  19200,  9600,  4800,  2400,  1200,  300};  
               
    	struct termios options;  
         
    	/*tcgetattr(fd,&options)得到与fd指向对象的相关参数，并将它们保存于options,该函数还可以测试配置是否正确，该串口是否可用等。若调用成功，函数返回值为0，若调用失败，函数返回值为1. 
        */  
    	if( tcgetattr( fd,&options)  !=  0)  
    	{  
    		perror("SetupSerial 1");      
    		return(FALSE);   
    	}  
        
        //设置串口输入波特率和输出波特率  
    	for ( i= 0;  i < sizeof(speed_arr) / sizeof(int);  i++)  
    	{  
    		if  (speed == name_arr[i])  
    		{               
    			cfsetispeed(&options, speed_arr[i]);   
    			cfsetospeed(&options, speed_arr[i]);    
    		}  
    	}       
         
        //修改控制模式，保证程序不会占用串口  
        options.c_cflag |= CLOCAL;  
        //修改控制模式，使得能够从串口中读取输入数据  
        options.c_cflag |= CREAD;  
        
        //设置数据流控制  
        switch(flow_ctrl)  
        {  
            
    		case 0 ://不使用流控制  
                  options.c_cflag &= ~CRTSCTS;  
                  break;     
            
    		case 1 ://使用硬件流控制  
                  options.c_cflag |= CRTSCTS;  
                  break;  
    		case 2 ://使用软件流控制  
                  options.c_cflag |= IXON | IXOFF | IXANY;  
                  break;  
        }  
        //设置数据位  
        //屏蔽其他标志位  
        options.c_cflag &= ~CSIZE;  
        switch (databits)  
        {    
    		case 5    :  
                         options.c_cflag |= CS5;  
                         break;  
    		case 6    :  
                         options.c_cflag |= CS6;  
                         break;  
    		case 7    :      
                     options.c_cflag |= CS7;  
                     break;  
    		case 8:      
                     options.c_cflag |= CS8;  
                     break;    
    		default:     
                     fprintf(stderr,"Unsupported data size\n");  
                     return (FALSE);   
        }  
        //设置校验位  
        switch (parity)  
        {    
    		case 'n':  
    		case 'N': //无奇偶校验位。  
                     options.c_cflag &= ~PARENB;   
                     options.c_iflag &= ~INPCK;      
                     break;   
    		case 'o':  
    		case 'O'://设置为奇校验      
                     options.c_cflag |= (PARODD | PARENB);   
                     options.c_iflag |= INPCK;               
                     break;   
    		case 'e':   
    		case 'E'://设置为偶校验    
                     options.c_cflag |= PARENB;         
                     options.c_cflag &= ~PARODD;         
                     options.c_iflag |= INPCK;        
                     break;  
    		case 's':  
    		case 'S': //设置为空格   
                     options.c_cflag &= ~PARENB;  
                     options.c_cflag &= ~CSTOPB;  
                     break;   
            default:    
                     fprintf(stderr,"Unsupported parity\n");      
                     return (FALSE);   
        }   
        // 设置停止位   
        switch (stopbits)  
        {    
    		case 1:     
                     options.c_cflag &= ~CSTOPB; break;   
    		case 2:     
                     options.c_cflag |= CSTOPB; break;  
    		default:     
                           fprintf(stderr,"Unsupported stop bits\n");   
                           return (FALSE);  
        }  
         
    	//修改输出模式，原始数据输出  
    	options.c_oflag &= ~OPOST;  
        
    	options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);  
    	//options.c_lflag &= ~(ISIG | ICANON);  
         
        //设置等待时间和最小接收字符  
        options.c_cc[VTIME] = 1; /* 读取一个字符等待1*(1/10)s */    
        options.c_cc[VMIN] = 1; /* 读取字符的最少个数为1 */  
         
        //如果发生数据溢出，接收数据，但是不再读取 刷新收到的数据但是不读  
        tcflush(fd,TCIFLUSH);  
         
        //激活配置 (将修改后的termios数据设置到串口中）  
        if (tcsetattr(fd,TCSANOW,&options) != 0)    
    	{  
    		perror("com set error!\n");    
    		return (FALSE);   
    	}  
        return (TRUE);   
    }  
    /******************************************************************* 
    * 名称：                UART0_Init() 
    * 功能：                串口初始化 
    * 入口参数：        fd       :  文件描述符    
    *               speed  :  串口速度 
    *                              flow_ctrl  数据流控制 
    *               databits   数据位   取值为 7 或者8 
    *                           stopbits   停止位   取值为 1 或者2 
    *                           parity     效验类型 取值为N,E,O,,S 
    *                       
    * 出口参数：        正确返回为1，错误返回为0 
    *******************************************************************/  
    int UART0_Init(int fd, int speed,int flow_ctrl,int databits,int stopbits,int parity)  
    {  
        int err;  
        //设置串口数据帧格式  
        if (UART0_Set(fd,115200,0,8,1,'N') == FALSE)  
    	{                                                           
    		return FALSE;  
    	}  
        else  
    	{  
    		return  TRUE;  
    	}  
    }  
       
    /******************************************************************* 
    * 名称：                  UART0_Recv 
    * 功能：                接收串口数据 
    * 入口参数：        fd                  :文件描述符     
    *                              rcv_buf     :接收串口中数据存入rcv_buf缓冲区中 
    *                              data_len    :一帧数据的长度 
    * 出口参数：        正确返回为1，错误返回为0 
    *******************************************************************/  
    int UART0_Recv(int fd, char *rcv_buf,int data_len)  
    {  
    	int len,fs_sel;  
        fd_set fs_read;  
         
        struct timeval time;  
         
        FD_ZERO(&fs_read);  
        FD_SET(fd,&fs_read);  
         
        time.tv_sec = 10;  
        time.tv_usec = 0;  
         
        //使用select实现串口的多路通信  
        fs_sel = select(fd+1,&fs_read,NULL,NULL,&time);  
        printf("fs_sel = %d\n",fs_sel);  
        if(fs_sel)  
    	{  
    		len = read(fd,rcv_buf,data_len);  
    		printf("I am right!(version1.2) len = %d fs_sel = %d\n",len,fs_sel);  
    		return len;  
    	}  
        else  
    	{  
    		printf("Sorry,I am wrong!");  
    		return FALSE;  
    	}       
    }  
    /******************************************************************** 
    * 名称：                  UART0_Send 
    * 功能：                发送数据 
    * 入口参数：        fd                  :文件描述符     
    *                              send_buf    :存放串口发送数据 
    *                              data_len    :一帧数据的个数 
    * 出口参数：        正确返回为1，错误返回为0 
    *******************************************************************/  
    int UART0_Send(int fd, char *send_buf,int data_len)  
    {  
        int len = 0;  
         
        len = write(fd,send_buf,data_len);  
        if (len == data_len )  
    	{  
    		printf("send data is %s\n",send_buf);
    		return len;  
    	}       
        else     
    	{  
                     
    		tcflush(fd,TCOFLUSH);  
    		return FALSE;  
    	}  
         
    }  

    
     /***************************************************************
      * 名称：  Send_AT_Command
      * 功能：  发送AT指令到模块并获取返回结果
      * 入口参数:           fd: 设备描述符
      *                          s_command:  要发送的AT指令
      *                          r_command:   接收到的返回数据判断是否执行AT指令成功
      *                          err_command: 接收到返回的数据错误 
      *                          err_step : 接收到错误的指令需要的跳向的流程计数
      *                          err_count : 在控制流程中错误次数累计值 超过10次就返回第一步或者跳向设备重启的指令流程
      *                          read_len:  读取串口接收多少的数据
      *                         step: 控制流程的计数
      *                         data:传入的数据接收需要的数据
      *                         n_start:从返回的数据中的第几位开始提取数据
      *                         n_len: 提取多长的数据
      *                         get_flag:是否需要提取数据
      * 出口参数： 返回执行AT指令的流程控制计数的值 执行AT指令成功就控制计数加一  执行AT指令失败就控制计数减一
      * **************************************************************/  
int Send_AT_Command(int fd,char *s_command,char * r_command,char *err_command,int err_step,int l_err_count,int read_len,int  step,char data[1024] , int n_start,int n_len,int  get_flag)
{
   char l_rcv_buf[1024]={0};
    int  l_s_len = 0;
    int  l_r_len = 0;
    memset(l_rcv_buf,0,sizeof(l_rcv_buf));
    memset(data,0,sizeof(data));
    l_s_len =  UART0_Send(fd,s_command,strlen(s_command));  
    if(l_s_len > 0)
    {
        printf("%d step send %d data successful\n",step,l_s_len);
    }
    else {
        printf("%d step send data failed!\n",step);
    }
    sleep(2);
  
   l_r_len = UART0_Recv(fd, l_rcv_buf,read_len);
   if(l_r_len > 0)
   {
       char *c1 = strstr(l_rcv_buf,r_command);
       if(c1 != NULL)
       {
           if(get_flag == 1)
           {
			  if(strlen(c1)>n_len)
				{
					n_len = strlen(c1);
				}
               memcpy(data,l_rcv_buf+n_start,strlen(l_rcv_buf));
           }
            err_count = 0;
           step++;
           printf("step %d  get answer is %s\n",step-1,l_rcv_buf);
       }
       
       char *c2 =strstr(l_rcv_buf,err_command);
       if(c2 != NULL)
       {
           err_count++;
           if(err_count >=10)
           {
               step = 18;
           }
           else{
                step = err_step;

           }
         
           printf("step %d get ERROR;err_count = %d \n",step+1,err_count);
       }

       l_rcv_buf[l_r_len] = '\0';
       printf("receive data is %s \n",l_rcv_buf);
      printf("len = %d \n",l_r_len);
   }  
   else{
       printf("cannot receive data \n");
   }
   sleep(2);
  return step;
}
/*****************************************************
 *   名称： Send_TCPDATA_Command
 *    功能： 在AT指令发送TCP数据时由于需要发送结束符，需要独立使用，主要实现发送数据和确定发送完成。
 *    人口参数： fd:设备描述符
 *                      s_data: 要发送的数据
 *                      r_data:接收发送AT指令发送数据的返回值确定是否发送成功
 *                      read_len: 读取串口接收的数据长度
 *                      step: 指令控制流程
 *     出口参数： step ：返回执行AT指令后的控制流程计数 若发送成功就计数加一 否则计数值不变
 * ****************************************************/
int Send_TCPDATA_Command(int fd,char *s_data,char *r_data,int read_len,int step)
{
    char l_rcv_buf[1024]={0};
    int l_s_len = 0;
    int l_r_len = 0;
    char send_end[1]={0x1a};
    memset(l_rcv_buf,0,sizeof(l_rcv_buf));
    l_s_len =  UART0_Send(fd,s_data,strlen(s_data));  
    if(l_s_len > 0)
    {
        printf("%d step send %d data successful\n",step,l_s_len);
    }
    else {
        printf("%d step send data failed!\n",step);
    }
    sleep(2);

    l_s_len =  write(fd,send_end,sizeof(send_end));  
    if(l_s_len > 0)
    {
        printf("%d step send %d data successful\n",step,l_s_len);
    }
    else {
        printf("%d step send data failed!\n",step);
    }
     sleep(2);  

     l_r_len = UART0_Recv(fd, l_rcv_buf,read_len);
     if(l_r_len > 0)
     {
         char* c10 = strstr(l_rcv_buf,r_data);
         if(c10 != NULL)
         {
             step ++;
             printf("Send tcp data %s\n",c10);
         }
         l_rcv_buf[l_r_len] = '\0';
            printf("receive data is %s \n",l_rcv_buf);
            printf("len = %d \n",l_r_len);
     }
     else
     {
         printf("can not receive data\n");
     }
     sleep(2);
     return step;
}

/*****************************************************
 *   名称： Find_Space
 *   功能： The enter a newline character in the string are replaced with specified characters.
 *    人口参数： fd:设备描述符
 *                      data: The input string.
 *                      f_data1: The first want to find the character.
 *                      f_data2: The second want to find the character.
 *                      r_data:  Replaced of the characters.
 *     出口参数： NOne
 * ****************************************************/
void Find_Space(char *data,char f_data1,char f_data2,char r_data)
{
	int len = strlen(data);
	for(int i=0; i <len;i++)
	{
		if((data[i] == f_data1)|| data[i] == f_data2)
		{
			data[i] = r_data;
		}
	}
	
}

/******************************************************
+CMGRMI: Main_Info,4,1,1,0,3,22871,0,2
+CMGRMI: Serving_Cell,38950,460,00,9540,2,182870787,40,5,5,18,163,-64,-1081,-818,0
+CMGRMI: LTE_Intra,1,38950,163,1
+CMGRMI: LTE_Intra_Cell1,163,-64,-1081,-818,0
+CMGRMI: LTE_Inter,2,Freq1,38400,0,0,0,0,Freq2,38544,0,0,0,0
+CMGRMI: GSM_Info,0,Freq_Group1,0,0,0,0,0,Freq_Group2,0,0,0,0,0
+CMGRMI: WCDMA_Info,0,Freq1,0,0,0,0,0,Freq2,0,0,0,0,0
+CMGRMI: CDMA1x_Info,0,Freq1,0,0,0,Freq2,0,0,0
+CMGRMI: CDMAprpd_Info,0,Freq1,0,0,0,Freq2,0,0,0
+CMGRMI: CDrx_Cfg,1,8,60,4,160,154,1,20,2
+CMGRMI: Cqi_Cfg,1,1,3,0,1,1,24,18,0,0,1,644,0,0,0,0
+CMGRMI: Ant_Cfg,3,0x0000000000000003,0,0
+CMGRMI: Idle_Drx_Cfg,640,2,110

struct GSM_INFO{
	char Main_Info[100];
	char Serving_Cell[200];
	char LTE_Intra[100];
	char LTE_Intra_Cell1[100];
	char LTE_Inter[100];
	char GSM_Info[200];
	char WCDMA_Info[200];
	char CDMA1x_Info[100];
	char CDMAprpd_Info[100];
	char CDrx_Cfg[100];
	char Cqi_Cfg[100];
	char Ant_Cfg[100];
	char Idle_Drx_Cfg[100];

}
*****************************************************/


/******************************************************
*  Name :Get_Data
*  Function: Fing the real data we want in the strings.
*  Input:	o_data: orignal data
*			w_data: want data
*			w2_data: want data2---->the next data will be
*			r_data:	return data
*  Output:	result :success the len of data we want ; fail :return 0
*
******************************************************/
int Get_Data(char *o_data,char *w_data,char *w2_data,char r_data[1024])
{
     int result = 0;
	 int len = 0;
	 char *g1 = strstr(o_data,w_data);
       if(g1 != NULL)
       {  
        //memcpy(r_data,g1,strlen(g1));  
		//printf("g1:%s \n",g1);
		//result = strlen(g1);
		char *g2 = strstr(o_data,w2_data);
		if(g2 != NULL)
			{
			len = strlen(g1)-strlen(g2);
			memcpy(r_data,g1,len-13);
			printf("len = %d \n",len);
			result = len;
			}
       }
		
	
	return result;	

}

/************************************************
*
*
*
struct GSM_INFO{
	char Main_Info[100];
	char Serving_Cell[200];
	char LTE_Intra[100];
	char LTE_Intra_Cell1[100];
	char LTE_Inter[100];
	char GSM_Info[200];
	char WCDMA_Info[200];
	char CDMA1x_Info[100];
	char CDMAprpd_Info[100];
	char CDrx_Cfg[100];
	char Cqi_Cfg[100];
	char Ant_Cfg[100];
	char Idle_Drx_Cfg[100];

}
************************************************/
int Get_AllData(char *o_data,struct GSM_INFO *g2_info)
{
	int result = 0;
	Get_Data(o_data,"Main_Info","Serving_Cell",g2_info->Main_Info);
	result=1;
	Get_Data(o_data,"Serving_Cell","LTE_Intra",g2_info->Serving_Cell);
	result=2;
	Get_Data(o_data,"LTE_Intra","LTE_Intra_Cell1",g2_info->LTE_Intra);
	result=3;
	Get_Data(o_data,"LTE_Intra_Cell1","LTE_Inter",g2_info->LTE_Intra_Cell1);
	result=4;
	Get_Data(o_data,"LTE_Inter","GSM_Info",g2_info->LTE_Inter);
	result=5;
	Get_Data(o_data,"GSM_Info","WCDMA_Info",g2_info->GSM_Info);
	result=6;
	Get_Data(o_data,"WCDMA_Info","CDMA1x_Info",g2_info->WCDMA_Info);
	result=7;
	Get_Data(o_data,"CDMA1x_Info","CDMAprpd_Info",g2_info->CDMA1x_Info);
	result=8;
	Get_Data(o_data,"CDMAprpd_Info","CDrx_Cfg",g2_info->CDMAprpd_Info);
	result=9;
	Get_Data(o_data,"CDrx_Cfg","Cqi_Cfg",g2_info->CDrx_Cfg);
	result=10;
	Get_Data(o_data,"Cqi_Cfg","Ant_Cfg",g2_info->Cqi_Cfg);
	result=11;
	Get_Data(o_data,"Ant_Cfg","Idle_Drx_Cfg",g2_info->Ant_Cfg);
	result=12;
	Get_Data(o_data,"Idle_Drx_Cfg","OK",g2_info->Idle_Drx_Cfg);
	result=13;
	return result;
    
}

void M_err(const char *err_string,int line)
{
    fprintf(stderr,"line:%d",line);
    perror(err_string);
    exit(1);
}

//define read data function 
int M_Read(int fd)
{
    int len;
    int ret;
    int i;
    char read_buf[64];
    
    //get length of file and start with pos 
    if(lseek(fd,0,SEEK_END)==-1)  //Take the start postion to the end of file ,get error return -1
    {
        M_err("lseek",__LINE__);  //Use the err function to get err postion
    }

    if((len=lseek(fd,0,SEEK_CUR))==-1)  //Get current postion of file to write
    {
        M_err("lseek",__LINE__);    //__LINE__ is 
    }
    
    if(lseek(fd,0,SEEK_SET)==-1)   //Take the postion of file to read and write to the start of file.
    {
        M_err("lseek",__LINE__);
    }

    printf("len:%d \n",len);    //to print the len of file.
    
    //read data
    if((ret=read(fd,read_buf,len))<0)
    {
       M_err("read",__LINE__);
    }

    //to print data 
    for(i=0;i<len;i++)
    {   
        printf("%c",read_buf[i]);    
    }

    printf("\n");
    return ret;   //
   
}

//define Write data Function
int M_Write(char *file_name,char* data)
{
    int result = 0;
	int fd;
	time_t now;
	struct tm *timenow;
	char a_data[2048];
	if((fd=open(file_name,O_RDWR|O_CREAT|O_TRUNC,S_IRWXU)) ==-1)
    {
       M_err("open",__LINE__);
    }
    else
    {
        printf("create file success \n");
    }
	time(&now);
    timenow = localtime(&now);  
	sprintf(a_data,"DATA:%s-Time:%s",data,asctime(timenow));  
    printf("Local time is %s \n",asctime(timenow)); 

    if(write(fd,a_data,strlen(a_data))!=strlen(a_data))
    {
        M_err("write",__LINE__);
        result = 0;
    }
    else
    {
        result = strlen(a_data);
    }
	close(fd);
    return result;

}




    int main(int argc, char **argv)  
    {  
        int fd;                            //文件描述符  
        int err;                           //返回调用函数的状态  
        int len;                          
        int s_len;
        int i;  
        int step=0;
        char rcv_buf[100];         
        char test_data[1024];
        char gsm_info[1024];
        char gsm_ccid[1024];
        char gsm_name[1024];
        char gsm_data[2048];
		//char Main_Info[1024];
		//char Serving_Cell[1024];
		struct GSM_INFO g_info;

  
        //char send_buf[20]="tiger john";  
        char send_buf[20]="AT\r\n";
		

		

        if(argc != 3)  
    	{  
    		printf("Usage: %s /dev/ttySn 0(send data)/1 (receive data) \n",argv[0]);  
    		return FALSE;  
    	}  
        fd = UART0_Open(fd,argv[1]); //打开串口，返回文件描述符  
        do
    	{  
    		err = UART0_Init(fd,115200,0,8,1,'N');  
    		printf("Set Port Exactly!\n");  
    	}while(FALSE == err || FALSE == fd);  
         
        if(0 == strcmp(argv[2],"0"))  
    	{  
    		for(i = 0;i < 10;i++)  
    		{  
     			len = UART0_Send(fd,send_buf,10);  
    			if(len > 0)  
    				printf(" %d time send %d data successful\n",i,len);  
    			else  
    				printf("send data failed!\n");  
                                
    			sleep(2);  
    		}  
    		UART0_Close(fd);               
    	}  
        else  
    	{                                        
    		while (1) //循环读取数据  
    		{   

                switch(step)
                {
                    //int Send_AT_Command(int fd,char *s_command,char * r_command,int read_len,int  step)
                    case 0:  memset(gsm_name,0,sizeof(gsm_name));memset(gsm_ccid,0,sizeof(gsm_ccid));memset(gsm_info,0,sizeof(gsm_info));memset(gsm_data,0,sizeof(gsm_data));memset(&g_info,0,sizeof(g_info));step = Send_AT_Command(fd,"AT\r\n","OK","ERROR",0,err_count,99,0,test_data,0,0,0); break;
                    case 1:  step = Send_AT_Command(fd,"AT+CREG?\r\n","+CREG:","ERROR",step,err_count,99,1,test_data,0,0,0); break;
                    case 2: step = Send_AT_Command(fd,"AT+CREG=1\r\n","OK","ERROR",step,err_count,99,2,test_data,0,0,0);   break;
                    case 3:  step = Send_AT_Command(fd,"AT+CNLSA=1\r\n","OK","ERROR",step,err_count,99,3,test_data,0,0,0);  break;
                    case 4: step = Send_AT_Command(fd,"AT+CNSMOD?\r\n","+CNSMOD:","ERROR",step,err_count,99,4,test_data,0,0,0); break;
                    case 5: step = Send_AT_Command(fd,"AT+CNMP=13\r\n","OK","ERROR",step,err_count,99,5,test_data,0,0,0);  break;
                    case 6: step = Send_AT_Command(fd,"AT+CNSMOD?\r\n","+CNSMOD:","ERROR",step,err_count,99,6,test_data,0,0,0); break;
                    case 7: step = Send_AT_Command(fd,"AT+MONI?\r\n","OK","ERROR",step,err_count,1023,7,gsm_name,0,1023,1); Find_Space(gsm_name,'\r','\n','-');printf("Get gsm-name: %s \n",gsm_name); break;
                    case 8: step = Send_AT_Command(fd,"AT+CNMP=38\r\n","OK","ERROR",step,err_count,99,8,test_data,0,0,0); break;
                    case 9: step = Send_AT_Command(fd,"AT+CMGSI=4\r\n","OK","ERROR",step,err_count,1023,9,gsm_ccid,0,1023,1); Find_Space(gsm_ccid,'\r','\n','-');  printf("Get gsm-ccid : %s err_count = %d \n",gsm_ccid,err_count);break;
                    case 10:  step = Send_AT_Command(fd,"AT+CMGRMI=4\r\n","OK","ERROR",step,err_count,1023,10,gsm_info,0,1023,1);Get_AllData(gsm_info,&g_info);printf("Main_Info:%s -Serving_Cell:%s\n",g_info.Main_Info,g_info.Serving_Cell);sprintf(gsm_data,"%s %s %s %s %s",g_info.Main_Info,g_info.Serving_Cell,g_info.LTE_Intra,g_info.LTE_Intra_Cell1,g_info.LTE_Inter);Find_Space(gsm_info,'\r','\n','*');M_Write(f_name,gsm_data);printf("Get gsm-info: %s\n %s \n",gsm_info,gsm_data);break;
                    case 11:  step = Send_AT_Command(fd,"AT+CPSI?\r\n","+CPSI:","ERROR",step,err_count,99,11,test_data,0,0,0);  break;
					case 12:  step = Send_AT_Command(fd,"AT+NETOPEN\r\n","OK","ERROR",step,err_count,99,12,test_data,0,0,0);  break;
					case 13:	step = Send_AT_Command(fd,"AT+CIPOPEN=0,\"TCP\",\"120.27.155.49\",5000\r\n","OK","ERROR",step,err_count,99,13,test_data,0,0,0);  break;
					case 14:    step = Send_AT_Command(fd,"AT+CIPSEND=0,\r\n",">","ERROR",step,err_count,99,14,test_data,0,0,0);	break;
					case 15:    step = Send_TCPDATA_Command(fd,gsm_info,"OK",1023,step); break;
					case 16:    step = Send_AT_Command(fd,"AT+CIPCLOSE=0\r\n","OK","ERROR",step,err_count,99,16,test_data,0,0,0);  break;
					case 17:    step = Send_AT_Command(fd,"AT+NETCLOSE\r\n","OK","ERROR",step,err_count,99,17,test_data,0,0,0);   break;
					//case 18:    step = Send_AT_Command(fd,"AT+CRESET\r\n","OK","ERROR",step,err_count,99,18,test_data,0,0,0);   break;
                    default:  memset(gsm_name,0,sizeof(gsm_name));memset(gsm_ccid,0,sizeof(gsm_ccid));memset(gsm_info,0,sizeof(gsm_info));memset(gsm_data,0,sizeof(gsm_data));memset(&g_info,0,sizeof(g_info));step = Send_AT_Command(fd,"AT\r\n","OK","ERROR",0,err_count,99,0,test_data,0,0,0); break;
                }
            }       
    		UART0_Close(fd);  
			
    	}  
    }  
