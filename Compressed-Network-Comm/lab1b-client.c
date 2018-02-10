//NAME: Robert Griffith
//EMAIL: rwgriffithv@gmail.com
//ID: XXXXXXXXX
//lab1b-client.c

#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <poll.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <termios.h>
#include <unistd.h>

// socket includes
#include <arpa/inet.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>

// zlib setup
#include <zlib.h>
#if defined(MSDOS) || defined(OS2) || defined(WIN32) || defined(__CYGWIN__)
#include <io.h>
#define SET_BINARY_MODE(file) setmode(fileno(file), O_BINARY)
#else
#define SET_BINARY_MODE(file)
#endif


#define READ_BYTES 256
#define CHUNK 256

// def inf return codes
#define ZLIB_FAIL -1

// log_write parameters
#define LOG_RCVD 1
#define LOG_SENT 0

// log_write return codes
#define LW_ALLOC_FAIL -1
#define LW_WRITE_FAIL -2

// read_write return codes
#define EOF_FROM_TERMINAL 4
#define EOF_FROM_SERVER 2
#define TERMINAL_INTERRUPT 1
#define SYSCALL_FAIL -1

struct termios backup_terminal;
char sigpipe_received = 0;

void print_error(char* msg) {
  fprintf(stderr, "%s: %s\n", msg, strerror(errno));
  exit(1);
}

void correct_usage_error(void) {
  fprintf(stderr, "Invalid argument. Correct usage with valid options:\n");
  fprintf(stderr, "--port option is mandatory\n");
  fprintf(stderr, "Connect to socket with specified port numer: --port=number\n");
  fprintf(stderr, "Maintain a record of data sent over the socket: --log=filename\n");
  fprintf(stderr, "Compress data sent between client and server: --compress\n");
  exit(1);
}

void sighandler(int signum) {
  if (signum == SIGPIPE)
    sigpipe_received = 1;
}

void restore_terminal(int fd) {
  if (tcsetattr(fd, TCSANOW, &backup_terminal)) {
    fprintf(stderr, "Failed to restore terminal settings: %s\n", strerror(errno));
    exit(1);
  }
}


// inflate compressed (deflated) data
char inf(char** buffer, int* buf_size) {
  unsigned char inf_buf[CHUNK];

  // initialize z_stream
  z_stream strm;
  strm.zalloc = Z_NULL;
  strm.zfree = Z_NULL;
  strm.opaque = Z_NULL;
  int inf_ret = inflateInit(&strm);
  if (inf_ret != Z_OK)
    return ZLIB_FAIL;

  // set input and output buffers
  strm.avail_in = (unsigned int) *buf_size;
  strm.next_in = (unsigned char*) *buffer;
  strm.avail_out = CHUNK;
  strm.next_out = inf_buf;

  // inflate
  do {
    inf_ret = inflate(&strm, Z_SYNC_FLUSH);
    if ((inf_ret == Z_STREAM_ERROR) || (inf_ret == Z_BUF_ERROR)) {
      (void)inflateEnd(&strm);
      return ZLIB_FAIL;
    }
  } while (strm.avail_in > 0);

  // change buffer and buf_size
  *buf_size = CHUNK - strm.avail_out;
  free(*buffer);
  *buffer = malloc(*buf_size);
  int i;
  for (i = 0; i < (*buf_size); i++)
    (*buffer)[i] = (char)inf_buf[i];

  // cleanup
  (void)inflateEnd(&strm);
  return 0;
} // end inf()


// deflate uncompressed data
char def(char** buffer, int* buf_size) {
  unsigned char def_buf[CHUNK];

  // initialize z_stream
  z_stream strm;
  strm.zalloc = Z_NULL;
  strm.zfree = Z_NULL;
  strm.opaque = Z_NULL;
  int def_ret = deflateInit(&strm, Z_DEFAULT_COMPRESSION);
  if (def_ret != Z_OK)
    return ZLIB_FAIL;

  // set input and output buffers
  strm.avail_in = *buf_size;
  strm.next_in = (unsigned char*) *buffer;
  strm.avail_out = CHUNK;
  strm.next_out = def_buf;

  // deflate
  do {
    def_ret = deflate(&strm, Z_SYNC_FLUSH);
    if ((def_ret == Z_STREAM_ERROR) || (def_ret == Z_BUF_ERROR)) {
      (void)deflateEnd(&strm);
      return ZLIB_FAIL;
    }
  } while (strm.avail_in > 0);

  // change buffer and buf_size
  *buf_size = CHUNK - strm.avail_out;
  free(*buffer);
  *buffer = malloc(*buf_size);
  int i;
  for (i = 0; i < (*buf_size); i++) {
    (*buffer)[i] = (char)def_buf[i];
  }

  // cleanup
  (void)deflateEnd(&strm);
  return 0;
} // end def()


// write in_buf to log file in format specifying direction of communication and size of transimission
char log_write(int fd_log, char mode, char* in_buf, int num_bytes_in_buf) {
  int log_size = (mode == LOG_RCVD) ? 18 : 14; // 13 letters, 3 spaces, colon, nullbyte
  char* log_buf = malloc(log_size);
  if (log_buf == NULL)
    return LW_ALLOC_FAIL;

  if (mode == LOG_RCVD) {
    log_buf[0] = 'R';
    log_buf[1] = 'E';
    log_buf[2] = 'C';    
    log_buf[3] = 'E';
    log_buf[4] = 'I';
    log_buf[5] = 'V';
    log_buf[6] = 'E';
    log_buf[7] = 'D';
    log_buf[8] = ' ';
  }
  else if (mode == LOG_SENT) {
    log_buf[0] = 'S';
    log_buf[1] = 'E';
    log_buf[2] = 'N';    
    log_buf[3] = 'T';
    log_buf[4] = ' ';
  }

  // can't have more than 256 bytes, so buffer only needs to hold 3 characters (null terminated)
  char byte_buf[4] = {0}; 
  snprintf(byte_buf, 4, "%d", num_bytes_in_buf);
  int i;
  const int num_write_pos = (mode == LOG_RCVD) ? 9 : 5; //position after RECEIEVED or SENT
  for (i = 0; (byte_buf[i] != 0) && (i < 4); i++) {
    log_size++;
    char* test_buf1 = realloc(log_buf, log_size);
    if (test_buf1 == NULL) {
      free(log_buf);
      return LW_ALLOC_FAIL;
    }
    log_buf = test_buf1;
    log_buf[num_write_pos+i] = byte_buf[i]; 
  }

  log_buf[log_size-9] = ' ';
  log_buf[log_size-8] = 'b';
  log_buf[log_size-7] = 'y';
  log_buf[log_size-6] = 't';
  log_buf[log_size-5] = 'e';
  log_buf[log_size-4] = 's';
  log_buf[log_size-3] = ':';
  log_buf[log_size-2] = ' ';
  log_buf[log_size-1] = 0;

  // concat with read_buf
  int append_index = log_size - 1;
  log_size += (num_bytes_in_buf + 1);
  char* test_buf2 = realloc(log_buf, log_size);
  if (test_buf2 == NULL) {
    free(log_buf);
    return LW_ALLOC_FAIL;
  }
  log_buf = test_buf2;

  for (i = 0; i < num_bytes_in_buf; i++, append_index++) {
    log_buf[append_index] = in_buf[i];
  }

  log_buf[log_size-2] = '\n'; // add newline
  log_buf[log_size-1] = 0; // terminating null byte

  // write to log file
  if (write(fd_log, log_buf, log_size - 1) == -1) {
    return LW_WRITE_FAIL;
  }

  free(log_buf);
  return 0;
}

// read_write function that governs all client io
char read_write(int fd_read, int fd_write, int fd_socket, char send_to_socket,
		 char compression_on, int fd_log) {
  // default return 0
  char return_code = 0;

  char* read_buf = malloc(READ_BYTES);
  if (read_buf == NULL) {
    restore_terminal(0);
    fprintf(stderr, "Failed to allocate memory for the read buffer: %s\n", strerror(errno));
    return SYSCALL_FAIL;
  }
  char* write_buf;
  char* sckt_buf;
  int num_bytes_read, num_bytes_write, num_bytes_sckt;
  num_bytes_read = 1;
  int read_index, write_index;

  // read
  if (!send_to_socket) // if from socket
    memset(read_buf, 0, READ_BYTES); // must zero buffer
  num_bytes_read = read(fd_read, read_buf, READ_BYTES);
  if (num_bytes_read == -1) {
    free(read_buf);
    restore_terminal(0);
    fprintf(stderr, "Error reading from input: %s\n", strerror(errno));
    return SYSCALL_FAIL;
  }

  // log receieved data from nonzero file descriptor
  // checks for nozero fd_log to see if --log option was used
  if (fd_read && num_bytes_read) {
    if (fd_log) {
      char log_return = log_write(fd_log, LOG_RCVD, read_buf, num_bytes_read);
      if (log_return < 0) {
	free(read_buf);
	restore_terminal(0);
	if (log_return == -1)
	  fprintf(stderr, "\nError allocating memory for log buffer: %s\n", strerror(errno));
	else
	  fprintf(stderr, "\nError writing to log file: %s\n", strerror(errno));
	return SYSCALL_FAIL;
      }
    }
    if (compression_on) {
      char inf_ret = inf(&read_buf, &num_bytes_read);
      if (inf_ret == ZLIB_FAIL) {
	free(read_buf);
	restore_terminal(0);
	fprintf(stderr, "\nError inflating data from server: %s\n", strerror(errno));
	return SYSCALL_FAIL;
      }
    }
  } // end received log

  // allocate space for write buffer, which will be at least as large as what was read
  num_bytes_write = num_bytes_read;
  write_buf = malloc(num_bytes_write);
  if (write_buf == NULL) {
    free(read_buf);
    restore_terminal(0);
    fprintf(stderr, "Failed to allocate memory for the write buffer: %s\n", strerror(errno));
    return SYSCALL_FAIL;
  }

  // buffer for writing to socket will be separate
  if (send_to_socket) {
    sckt_buf = malloc(num_bytes_write);
    if (sckt_buf == NULL) {
      restore_terminal(0);
      free(read_buf);
      free(write_buf);
      fprintf(stderr, "Failed to allocate memory for the pipe buffer: %s\n", strerror(errno));
      return SYSCALL_FAIL;
    }
  }

  // process characters
  for (read_index = 0, write_index = 0; read_index < num_bytes_read; read_index++) {
    // check for carriage return or line feed
    if (read_buf[read_index] == '\r' || read_buf[read_index] == '\n') {
      num_bytes_write += 1;
      char* test_buf = realloc(write_buf, num_bytes_write);
      if (test_buf == NULL) {
	free(read_buf);
	free(write_buf);
	restore_terminal(0);
	fprintf(stderr, "\nFailed to reallocate memory for the write buffer: %s\n", strerror(errno));
	if (send_to_socket)
	  free(sckt_buf);
	return SYSCALL_FAIL;
      }
      write_buf = test_buf;
      write_buf[write_index] = '\r';
      write_buf[write_index + 1] = '\n';
      write_index += 2;

      if (send_to_socket) {
	sckt_buf[read_index] = '\n';
      }
    } // end if \r \n
    // check for ^C from terminal
    else if (!fd_read && (read_buf[read_index] == 3)) {
      if (send_to_socket) {
	sckt_buf[read_index] = read_buf[read_index];
	return_code |= TERMINAL_INTERRUPT;
      }
	
      num_bytes_write += 1;
      char* test_buf = realloc(write_buf, num_bytes_write);
      if (test_buf == NULL) {
	free(read_buf);
	free(write_buf);
	restore_terminal(0);
	fprintf(stderr, "\nFailed to reallocate memory for the write buffer: %s\n", strerror(errno));
	if (send_to_socket)
	  free(sckt_buf);
	return SYSCALL_FAIL;
      }
      write_buf = test_buf;
      write_buf[write_index] = '^';
      write_buf[write_index + 1] = 'C';
      write_index += 2;
    }
    // check for ^D
    else if (read_buf[read_index] == 4) {
      if (send_to_socket)
	sckt_buf[read_index] = read_buf[read_index];

      if (fd_read) { // this checks that the input didn't come from stdin
	return_code |= EOF_FROM_SERVER;
	num_bytes_write = write_index;
	break;
      }
      else {
	num_bytes_write += 1;
	char* test_buf = realloc(write_buf, num_bytes_write);
	if (test_buf == NULL) {
	  free(read_buf);
	  free(write_buf);
	  restore_terminal(0);
	  fprintf(stderr, "\nFailed to reallocate memory for the write buffer: %s\n", strerror(errno));
	  if (send_to_socket)
	    free(sckt_buf);
	  return SYSCALL_FAIL;
	}
	write_buf = test_buf;
	write_buf[write_index] = '^';
	write_buf[write_index + 1] = 'D';
	write_index += 2;

	return_code |= EOF_FROM_TERMINAL;
      }
    } // end if ^D

    else {
      if (send_to_socket)
	sckt_buf[read_index] = read_buf[read_index];
      write_buf[write_index] = read_buf[read_index];
      write_index++;
    }
  } // end for (character processing)
  free(read_buf);

  // write to fd_write
  if (write(fd_write, write_buf, num_bytes_write) == -1) {
    restore_terminal(0);
    fprintf(stderr, "\nError writing to output: %s\n", strerror(errno));
    return_code = SYSCALL_FAIL;
  }
  free(write_buf);

  // write to socket
  if (send_to_socket) {
    num_bytes_sckt = num_bytes_read;

    if (compression_on) {
      char def_ret = def(&sckt_buf, &num_bytes_sckt);

      if (def_ret == ZLIB_FAIL) {
	free(sckt_buf);
	restore_terminal(0);
	fprintf(stderr, "\nError compression output to server: %s\n", strerror(errno));
	return SYSCALL_FAIL;
      }
    }

    if (write(fd_socket, sckt_buf, num_bytes_sckt) == -1) {
      restore_terminal(0);
      fprintf(stderr, "\nError writing to child process: %s\n", strerror(errno));
      return SYSCALL_FAIL;
    }

    // fd_log is zero unless a log file file descriptor is passed, signifying to write to a log
    if (fd_log && num_bytes_sckt) {
      char log_return = log_write(fd_log, LOG_SENT, sckt_buf, num_bytes_sckt);
      if (log_return < 0) {
	restore_terminal(0);
	if (log_return == -1)
	  fprintf(stderr, "\nError allocating memory for log buffer: %s\n", strerror(errno));
	else
	  fprintf(stderr, "\nError writing to log file: %s\n", strerror(errno));
	return SYSCALL_FAIL;
      }
    } // end sent log

    free(sckt_buf);
  }

  return return_code;
} // end read_write()

int main(int argc, char** argv) {
  int port_number = -1;
  char* log_file_name;
  char optflag_port = 0;
  char optflag_log = 0;
  char optflag_compress = 0;
  int fd_log = 0;

  const struct option opt_array[] = {
    {"port", required_argument, 0, 'p'},
    {"log", required_argument, 0, 'l'},
    {"compress", no_argument, 0, 'c'},
    {0, 0, 0, 0}
  };

  int opt_return;
  int opt_index = 0;
  opterr = 0;
  while ( (opt_return = getopt_long(argc, argv, "", opt_array, &opt_index)) != -1 ) {
    switch (opt_return) {
    case 'p':
      optflag_port = 1;
      port_number = atoi(optarg);
      break;
    case 'l':
      optflag_log = 1;
      log_file_name = optarg;
      break;
    case 'c':
      optflag_compress = 1;
      break;
    case '?':
    default:
      correct_usage_error();
    }
  }

  if (!optflag_port || (port_number < 0))
    correct_usage_error();

  if (optflag_log) {
    fd_log = creat(log_file_name, 0666);
    if (fd_log < 0)
      print_error("Failed to create log file");
  }


  // socket setup
  int fd_socket = socket(AF_INET, SOCK_STREAM, 0);
  if (fd_socket < 0)
    print_error("Failed to open socket");

  struct sockaddr_in server;
  server.sin_addr.s_addr = inet_addr("127.0.0.1");
  server.sin_family = AF_INET;
  server.sin_port = htons(port_number);

  if (connect(fd_socket, (struct sockaddr*) &server, sizeof(server)) < 0)
    print_error("Failed to connect to socket");


  // terminal setup
  struct termios NCINE_terminal;

  if (tcgetattr(0, &backup_terminal))
    print_error("Failed to retrieve terminal settings");

  NCINE_terminal = backup_terminal;
  NCINE_terminal.c_iflag = ISTRIP;
  NCINE_terminal.c_oflag = 0;
  NCINE_terminal.c_lflag = 0;

  if (tcsetattr(0, TCSANOW, &NCINE_terminal))
    print_error("Failed to change terminal settings");

  // handle SIGPIPE
  signal(SIGPIPE, sighandler);

  // poll setup
  struct pollfd pollfds[2];
  pollfds[0].fd = 0;  // stdin
  pollfds[0].events = POLLIN | POLLPRI | POLLHUP | POLLERR;
  pollfds[1].fd = fd_socket;  // server
  pollfds[1].events = POLLIN | POLLPRI | POLLHUP | POLLERR;

  // begin polling
  char socket_open = 1;
  int poll_return;
  while ((poll_return = poll(pollfds, 2, 0)) >= 0) {

    int fd_index;
    for (fd_index = 0; poll_return && fd_index < 2; fd_index++) {

      char read_ret = 0;
      // if can read
      if (pollfds[fd_index].revents & (POLLIN | POLLPRI)) {
	char write_to_sckt = socket_open && !fd_index;
	read_ret = read_write(pollfds[fd_index].fd, 0, fd_socket, write_to_sckt,
			      optflag_compress, fd_log);

	if (read_ret)
	  restore_terminal(0);

	// handle syscall failure
	if (read_ret == SYSCALL_FAIL) {
	  if (close(fd_socket) == -1)
	    print_error("Failed to close socket");
	  exit(1);
	}

	// handle ^C interrupt and ^D or eof from terminal
	if (read_ret & (TERMINAL_INTERRUPT | EOF_FROM_TERMINAL))
	  socket_open = 0;

      } // end if can read

      // close socket and exit after ^D or ^C
      if ((read_ret & EOF_FROM_SERVER) || (pollfds[fd_index].revents & POLLHUP) ||
	  (pollfds[fd_index].revents & POLLERR) || sigpipe_received) {
	restore_terminal(0);

	if (shutdown(fd_socket, SHUT_RDWR) == -1)
	  print_error("Failed to shut down communication socket");

	if (close(fd_socket) == -1)
	  print_error("Failed to close socket");
	  
	exit(0);
      } // end status
    } // end for
  } // end while

    return 0;
} // end main
