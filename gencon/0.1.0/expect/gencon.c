#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <linux/limits.h>
#include <sys/epoll.h>
#include <stdio.h>
#include <stdlib.h>

#define _con(c,f) printf("%6d CONSTANT " f "\n", c)
#define con(c,f) _con(c,#f)
#define c(k) _con(k,#k)

int main (void) {
  con(sizeof(struct stat), STAT_SIZE);
  /* size of the stat struct */
  printf("\\ st_uid size: %d\n", sizeof(((struct stat *)0)->st_uid));
  /* size in bytes of the UID - emitted as a comment */
  con(&((struct stat *)0)->st_uid, ST_UID);
  /* index of UID within the stat struct */
  c(O_DIRECTORY);
  c(PATH_MAX);
  c(EPOLL_CTL_ADD);
  return 0;
}
