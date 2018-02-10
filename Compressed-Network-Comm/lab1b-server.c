//NAME: Robert Griffith
//EMAIL: rwgriffithv@gmail.com
//ID: XXXXXXXXX
//lab1b-server.c

#include <errno.h>
#include <getopt.h>
#include <poll.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

// socket includes
#include <arpa/inet.h>
#include <assert.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/types.h>

// zlib setup
#include "zlib.h"
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

// read_write parameter constant
#define READ_CLIENT 0
#define READ_SHELL 1

// read_write return codes
#define EOF_FROM_CLIENT 4
#define EOF_FROM_SHELL 2
#define CLIENT_INTERRUPT 1
#define SYSCALL_FAIL -1

char sigpipe_received = 0;

void print_error(char* msg) {
  fprintf(stderr, "%s: %s\n", msg, strerror(errno));
  exit(1);
}

void correct_usage_error(void) {
  fprintf(stderr, "Invalid argument. Correct usage with valid options:\n");
  fprintf(stderr, "--port option is mandatory\n");
  fprintf(stderr, "Connect to socket with specified port numer: --port=number\n");
  fprintf(stderr, "Compress data sent between client and server: --compress\n");
  exit(1);
}

void sighandler(int signum) {
  if (signum == SIGPIPE)
    sigpipe_received = 1;
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
  for (i = 0; i < *buf_size; i++)
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
  for (i = 0; i < *buf_size; i++)
    (*buffer)[i] = (char)def_buf[i];

  // cleanup
  (void)deflateEnd(&strm);
  return 0;
} // end def()


// read_write function that governs all client io
char read_write(int fd_read, int fd_write, char read_case, char compression_on) {
  // default return 0
  char return_code = 0;

  char* read_buf = malloc(READ_BYTES);
  if (read_buf == NULL) {
    fprintf(stderr, "Failed to allocate memory for the read buffer: %s\n", strerror(errno));
    return SYSCALL_FAIL;
  }
  char* write_buf;
  int num_bytes_read, num_bytes_write;
  int read_index;

  // read
  if (read_case == READ_CLIENT)
    memset(read_buf, 0, READ_BYTES); // zero out the buffer
  num_bytes_read = read(fd_read, read_buf, READ_BYTES);
  if (num_bytes_read < 0) {
    if (read_case == READ_CLIENT)
      return EOF_FROM_CLIENT;
    else {
      fprintf(stderr, "Error reading from input: %s\n", strerror(errno));
      return SYSCALL_FAIL;
    }
  }

  // inflate read_buf if from client and compression is on, and there are bytes to inflate
  if ((read_case == READ_CLIENT) && compression_on && num_bytes_read) {
    char inf_ret = inf(&read_buf, &num_bytes_read);
    if (inf_ret == ZLIB_FAIL) {
      free(read_buf);
      fprintf(stderr, "\nError inflating data from server: %s\n", strerror(errno));
      return SYSCALL_FAIL;
    }
  }

  num_bytes_write = num_bytes_read; // only time they differ is with compression, which is handled
  write_buf = malloc(num_bytes_write);
  if (write_buf == NULL) {
    free(read_buf);
    fprintf(stderr, "Failed to allocate memory for the write buffer: %s\n", strerror(errno));
    return SYSCALL_FAIL;
  }

  // process characters
  for (read_index = 0; read_index < num_bytes_read; read_index++) {
    // check for ^C from client
    if ((read_buf[read_index] == 3) && (read_case == READ_CLIENT)) {
      return_code |= CLIENT_INTERRUPT;
      num_bytes_write = read_index;
      break;
    }

    // check for ^D
    if (read_buf[read_index] == 4) {
      if (read_case == READ_CLIENT) {
	return_code |= EOF_FROM_CLIENT;
	num_bytes_write = read_index;
	break;
      }

      else if (read_case == READ_SHELL)
	return_code |= EOF_FROM_SHELL;
    }
    write_buf[read_index] = read_buf[read_index];
  } // end for (character processing)
  free(read_buf);

  // deflate write_buf
  if ((read_case == READ_SHELL) && compression_on) {
    char def_ret = def(&write_buf, &num_bytes_write);
    if (def_ret == ZLIB_FAIL) {
      free(write_buf);
      fprintf(stderr, "\nError compression output to server: %s\n", strerror(errno));
      return SYSCALL_FAIL;
    }
  }

  // write
  if (write(fd_write, write_buf, num_bytes_write) == -1) {
    fprintf(stderr, "\nError writing to output: %s\n", strerror(errno));
    return_code = SYSCALL_FAIL;
  }
  free(write_buf);

  return return_code;
} // end read_write()

int main(int argc, char** argv) {
  int port_number;

  const struct option opt_array[] = {
    {"port", required_argument, 0, 'p'},
    {"compress", no_argument, 0, 'c'},
    {0, 0, 0, 0}
  };

  char optflag_port = 0;
  char optflag_compress = 0;


  int opt_return;
  int opt_index = 0;
  opterr = 0;
  while ( (opt_return = getopt_long(argc, argv, "", opt_array, &opt_index)) != -1 ) {
    switch (opt_return) {
    case 'p':
      optflag_port = 1;
      port_number = atoi(optarg);
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

  // socket setup
  int fd_listen, fd_comm;
  fd_listen = socket(AF_INET, SOCK_STREAM, 0);
  if (fd_listen < 0)
    print_error("Failed to open socket");


  struct sockaddr_in server;
  server.sin_addr.s_addr = INADDR_ANY;
  server.sin_family = AF_INET;
  server.sin_port = htons(port_number);

  if (bind(fd_listen, (struct sockaddr*) &server, sizeof(server)) < 0)
    print_error("Failed to bind server struct to socket");

  if (listen(fd_listen, 1) < 0)
    print_error("Failed to listen for new connections");

  fd_comm = accept(fd_listen, (struct sockaddr*) NULL, NULL);
  if (fd_comm < 0)
    print_error("Failed to accept incoming connection");


  // shell setup
  // pipe to shell is written to by parent process and read by child
  int p_to_shell[2];
  // pipe from shell is read by parent and written to by child
  int p_from_shell[2];

  if (pipe(p_from_shell) == -1)
    print_error("Pipe creation failed");
  else if (pipe(p_to_shell) == -1)
    print_error("Pipe creation failed");

  pid_t p_id = fork();
  if (p_id < 0)
    print_error("Fork failed");

  // parent process
  else if (p_id > 0) {

    if (close(p_from_shell[1]) == -1)
      print_error("Failed to close pipe from shell");

    if (close(p_to_shell[0]) == -1)
      print_error("Failed to close pipe to shell");
    
    struct pollfd pollfds[2];
    pollfds[0].fd = fd_comm;  // from client
    pollfds[0].events = POLLIN | POLLPRI | POLLHUP | POLLERR;
    pollfds[1].fd = p_from_shell[0];  // shell
    pollfds[1].events = POLLIN | POLLPRI | POLLHUP | POLLERR;

    // handle SIGPIPE
    signal(SIGPIPE, sighandler);

    // begin polling
    char to_shell_open = 1;
    int poll_return;
    while ((poll_return = poll(pollfds, 2, 0)) >= 0) {

      int fd_index;
      for (fd_index = 0; poll_return && fd_index < 2; fd_index++) {

	char read_ret = 0;
	// if can read
	if (pollfds[fd_index].revents & (POLLIN | POLLPRI)) {
	  int fd_write = (fd_index) ? fd_comm : p_to_shell[1];
	  char read_case = (fd_index) ? READ_SHELL : READ_CLIENT;
	  read_ret = read_write(pollfds[fd_index].fd, fd_write, read_case, optflag_compress);

	  // handle syscall failure
	  if (read_ret == SYSCALL_FAIL) {
	    if (kill(p_id, SIGINT) == -1)
	      fprintf(stderr, "Failed to kill child process: %s\n", strerror(errno));
	    exit(1);
	  }

	  // handle ^C interrupt from client
	  if ((read_ret & CLIENT_INTERRUPT) || sigpipe_received) {
	    if (kill(p_id, SIGINT) == -1)
	      print_error("Failed to kill child process");
	    if (to_shell_open) {
	      if (close(p_to_shell[1]) == -1)
		print_error("Failed to close pipe to shell");
	      to_shell_open = 0;
	    }
	  }

	  // handle ^D or eof from client
	  if ((read_ret & EOF_FROM_CLIENT) && to_shell_open) {
	    if (close(p_to_shell[1]) == -1)
	      print_error("Failed to close pipe to shell");
	    to_shell_open = 0;
	  }

	} // end if can read

	// harvest and report termination of shell
	if ((read_ret == EOF_FROM_SHELL) ||
	    (fd_index && ( (pollfds[fd_index].revents & POLLHUP) ||
			   (pollfds[fd_index].revents & POLLERR) ||
			   sigpipe_received ))) {

	  if (close(p_from_shell[0]) == -1)
	    print_error("Failed to close pipe from shell");

	  if (to_shell_open) {
	    if (close(p_to_shell[1]) == -1)
	      print_error("Failed to close pipe to shell");
	  }

	  int status;
	  if (waitpid(p_id, &status, WUNTRACED) == -1) {
	    fprintf(stderr, "waitpid failure: %s\n", strerror(errno));
	    exit(1);
	  }
	  fprintf(stderr, "SHELL EXIT SIGNAL=%d STATUS=%d\n",
		  WTERMSIG(status), WEXITSTATUS(status));

	  // send EOF to client
	  int eof_size = 1;
	  char* eof = malloc(eof_size);
	  eof[0] = 4;
	  if (optflag_compress) // compress if needed
	    def(&eof, &eof_size);
	  if (write(fd_comm, eof, eof_size) == -1) {
	    free(eof);
	    print_error("Failed to send terminate signal to client");
	  }
	  else
	    free(eof);

	  // shutdown and close
	  if (shutdown(fd_comm, SHUT_RDWR) == -1)
	    print_error("Failed to shut down communication socket");

	  if (close(fd_comm) == -1)
	    print_error("Failed to close socket to client");

	  if (shutdown(fd_listen, SHUT_RDWR) == -1)
	    print_error("Failed to shut down listening socket");

	  if (close(fd_listen) == -1)
	    print_error("Failed to close listening socket");

	  exit(0);
	} // end waitpid shell status

      } // end for
    } // end while

    return 0;
  } // end parent process

  // child process
  else {

    if (close(fd_comm) == -1)
      print_error("Failed to close listening socket in child");

    if (close(fd_listen) == -1)
      print_error("Failed to close listening socket in child");


    if (close(p_from_shell[0]) == -1)
      print_error("Failed to close pipe from shell");

    if (close(p_to_shell[1]) == -1)
      print_error("Failed to close pipe to shell");


    if (dup2(p_to_shell[0], 0) == -1) {
      fprintf(stderr, "dup pipe input failed: %s\n", strerror(errno));
      exit(1);
    }
    if (dup2(p_from_shell[1], 1) == -1) {
      fprintf(stderr, "dup pipe output failed: %s\n", strerror(errno));
      exit(1);
    }
    if (dup2(p_from_shell[1], 2) == -1) {
      fprintf(stderr, "dup pipe output failed: %s\n", strerror(errno));
      exit(1);
    }

    close(p_to_shell[0]);
    close(p_from_shell[1]);

    char* exec_args[] = {"/bin/bash", NULL};
    if (execv(exec_args[0], exec_args) == -1) {
      fprintf(stderr, "Failure to execute instance of shell: %s\n", strerror(errno));
      exit(1);
    }
  }

  return 0;
} // end main
