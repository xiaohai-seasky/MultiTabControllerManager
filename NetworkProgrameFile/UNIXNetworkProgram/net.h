#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <errno.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#include "TCP_ToolsFunction.c"
#include <unistd.h>

#include "my_error.h"

////////////////////////////////////////////////////////
#define SERV_PORT 9877

// #define MAXLINE 1    // ** 已经在 my_error.h 中定义 **

#define LISTENQ 5



