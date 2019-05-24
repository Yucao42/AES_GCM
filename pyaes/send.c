#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>    /* Must precede if*.h */
#include <linux/if.h>
#include <linux/if_ether.h>
#include <linux/if_packet.h>
#include <sys/ioctl.h>
#include <signal.h>
#include <unistd.h>

int running = 1;
union ethframe
{
  struct
  {
    struct ethhdr    header;
    unsigned char    data[ETH_DATA_LEN];
  } field;
  unsigned char    buffer[ETH_FRAME_LEN];
};

void sigint(int signum)
{
    if (!running)
        exit(EXIT_FAILURE);

    running = 0;
}

void sigalarm(int signum)
{
    if (!running)
        exit(EXIT_FAILURE);

    running = 0;
}

typedef struct{
  int a;
  double d;
  char b;
  float c;
}fun_test;

int main(int argc, char **argv) {
  // printf("%d\n", sizeof(fun_test));
  // printf("%d\n", sizeof(double));
  // fun_test test;

  // printf("%d\n", &test.a);
  // printf("%d\n", &test.d);
  // printf("%d\n", &test.b);
  // printf("%d\n", &test.c);
  char *iface = "eth2";
  unsigned char dest[ETH_ALEN]
           = {0x3c, 0xfd, 0xfe, 0xbd, 0x01, 0xa5};
  unsigned short proto = 0x1234;
  unsigned char *data = "hhello worlhello wordhelsdsadadslo woworldhellorlddhello worlhello wordhelsdsadadslo woworldhellorlddhello worlhello wordhelsdsadadslo woworldhellorlddhello worlhello wordhelsdsadadslo woworldhellorlddello worlhello wordhelsdsadadslo woworldhellorlddhello worlhello wordhelsdsadadslo woworldhellorlddhello worlhello wordhelsdsadadslo woworldhellorldd";
  unsigned short data_len = strlen(data);
 
  int s;
  int timeout = 1;
//   printf('%d', ETH_P_ALL);
  //printf('%d', PF_PACKET);
  s = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL)); 
  // if ((s = socket(AF_PACKET, SOCK_RAW, htons(proto))) < 0) {
  if(s < 0){
    printf("Error: could not open socket\n");
    return -1;
  }
 
  struct ifreq buffer;
  int ifindex;
  memset(&buffer, 0x00, sizeof(buffer));
  strncpy(buffer.ifr_name, iface, IFNAMSIZ);
  if (ioctl(s, SIOCGIFINDEX, &buffer) < 0) {
    printf("Error: could not get interface index\n");
    close(s);
    return -1;
  }
  ifindex = buffer.ifr_ifindex;
 
  unsigned char source[ETH_ALEN];
  if (ioctl(s, SIOCGIFHWADDR, &buffer) < 0) {
    printf("Error: could not get interface address\n");
    close(s);
    return -1;
  }
  memcpy((void*)source, (void*)(buffer.ifr_hwaddr.sa_data),
         ETH_ALEN);
 
  union ethframe frame;
  memcpy(frame.field.header.h_dest, dest, ETH_ALEN);
  memcpy(frame.field.header.h_source, source, ETH_ALEN);
  frame.field.header.h_proto = htons(proto);
  memcpy(frame.field.data, data, data_len);
 
  unsigned int frame_len = data_len + ETH_HLEN;
 
  struct sockaddr_ll saddrll;
  memset((void*)&saddrll, 0, sizeof(saddrll));
  saddrll.sll_family = PF_PACKET;   
  saddrll.sll_ifindex = ifindex;
  saddrll.sll_halen = ETH_ALEN;
  memcpy((void*)(saddrll.sll_addr), (void*)dest, ETH_ALEN);

  /* enable signals */
  signal(SIGINT, sigint);
  signal(SIGALRM, sigalarm);
  alarm(timeout);
  printf("%s\n", frame.buffer);
  int ct = 0;
  while(running){
    ++ct;
    sendto(s, frame.buffer, frame_len, 0,
               (struct sockaddr*)&saddrll, sizeof(saddrll)); 
    // if (sendto(s, frame.buffer, frame_len, 0,
              //  (struct sockaddr*)&saddrll, sizeof(saddrll)) > 0)
      // printf("Success!\n");
    // else
      // printf("Error, could not send\n");
    //if (sendto(s, frame.buffer, frame_len, 0,
    //           (struct sockaddr*)&saddrll, sizeof(saddrll)) > 0)
    //  printf("Success!\n");
    //else
    //  printf("Error, could not send\n");
  }

  printf("%d\n", s);
  printf("%s\n", frame.buffer);
  printf("%d\n", frame_len);
  printf("%d\n", ct);
  printf("Throughput for one core %.3f Gbits/sec\n", ct * frame_len * 8 / 1000000000.0);
  close(s);
 
  return 0;
}
