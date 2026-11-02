// Minimal relative-pointer injector used only by test-chromium-cursor.
#include <errno.h>
#include <fcntl.h>
#include <linux/input.h>
#include <linux/uinput.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <unistd.h>

static int emit(int fd, unsigned short type, unsigned short code, int value) {
  struct input_event event = { .type = type, .code = code, .value = value };
  return write(fd, &event, sizeof(event)) == sizeof(event) ? 0 : -1;
}

int main(int argc, char **argv) {
  if (argc != 3) { fprintf(stderr, "usage: %s DX DY\\n", argv[0]); return 2; }
  int fd = open("/dev/uinput", O_WRONLY | O_NONBLOCK);
  if (fd < 0) { perror("open /dev/uinput"); return 1; }
  if (ioctl(fd, UI_SET_EVBIT, EV_REL) || ioctl(fd, UI_SET_RELBIT, REL_X) ||
      ioctl(fd, UI_SET_RELBIT, REL_Y) || ioctl(fd, UI_SET_EVBIT, EV_KEY) ||
      ioctl(fd, UI_SET_KEYBIT, BTN_LEFT) || ioctl(fd, UI_SET_KEYBIT, BTN_RIGHT)) {
    perror("configure uinput"); close(fd); return 1;
  }
  struct uinput_setup setup = {0};
  snprintf(setup.name, UINPUT_MAX_NAME_SIZE, "chromium-cursor-test-pointer");
  setup.id.bustype = BUS_VIRTUAL;
  if (ioctl(fd, UI_DEV_SETUP, &setup) || ioctl(fd, UI_DEV_CREATE)) { perror("create uinput"); close(fd); return 1; }
  usleep(150000);
  int dx = atoi(argv[1]), dy = atoi(argv[2]);
  int result = emit(fd, EV_REL, REL_X, dx) || emit(fd, EV_REL, REL_Y, dy) || emit(fd, EV_SYN, SYN_REPORT, 0);
  usleep(50000);
  ioctl(fd, UI_DEV_DESTROY);
  close(fd);
  return result ? 1 : 0;
}
