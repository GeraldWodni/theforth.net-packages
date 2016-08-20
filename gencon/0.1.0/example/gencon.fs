#include <sys/epoll.h>
#include <linux/limits.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

c EPOLL_CTL_ADD
c PATH_MAX
c O_DIRECTORY

code: /* index of UID within the stat struct */
code: con(&((struct stat *)0)->st_uid, ST_UID);

code: /* size in bytes of the UID - emitted as a comment */
code: printf("\\ st_uid size: %d\n", sizeof(((struct stat *)0)->st_uid));

code: /* size of the stat struct */
code: con(sizeof(struct stat), STAT_SIZE);

