#include "fitz-internal.h"

fz_stream *
fz_new_stream(fz_context *ctx, void *state,
	int(*read)(fz_stream *stm, unsigned char *buf, int len),
	void(*close)(fz_context *ctx, void *state))
{
	fz_stream *stm;

	try
	{
		stm = (fz_stream*)fz_malloc_struct(ctx, fz_stream);
	}
	catch(...)
	{
		close(ctx, state);
		throw(21);
	}

	stm->refs = 1;
	stm->error = 0;
	stm->eof = 0;
	stm->pos = 0;

	stm->bits = 0;
	stm->avail = 0;
	stm->locked = 0;

	stm->bp = stm->buf;
	stm->rp = stm->bp;
	stm->wp = stm->bp;
	stm->ep = stm->buf + sizeof stm->buf;

	stm->state = state;
	stm->read = read;
	stm->close = close;
	stm->seek = NULL;
	stm->ctx = ctx;

	return stm;
}

void
fz_lock_stream(fz_stream *stm)
{

}

fz_stream *
fz_keep_stream(fz_stream *stm)
{
	stm->refs ++;
	return stm;
}

void
fz_close(fz_stream *stm)
{
	//return;

	if (!stm)
		return;
	stm->refs --;
	if (stm->refs == 0)
	{
		if (stm->close)
			stm->close(stm->ctx, stm->state);
		if (stm->locked)
//			fz_unlock(stm->ctx, FZ_LOCK_FILE);
		fz_free(stm->ctx, stm);
	}
}

/* File stream */

 int read_file(fz_stream *stm, unsigned char *buf, int len)
{
	int n = read(*(int*)stm->state, buf, len);
//	fz_assert_lock_held(stm->ctx, FZ_LOCK_FILE);
	if (n < 0)
		printf("read error: %s", strerror(errno));
	return n;
}

 void seek_file(fz_stream *stm, int offset, int whence)
{
	int n = lseek(*(int*)stm->state, offset, whence);
//	fz_assert_lock_held(stm->ctx, FZ_LOCK_FILE);
	if (n < 0)
		printf("cannot lseek: %s", strerror(errno));
	stm->pos = n;
	stm->rp = stm->bp;
	stm->wp = stm->bp;
}

 void close_file(fz_context *ctx, void *state)
{
	int n = close(*(int*)state);
	if (n < 0)
		printf("close error: %s", strerror(errno));
	fz_free(ctx, state);
}

fz_stream *
fz_open_fd(fz_context *ctx, int fd)
{
	fz_stream *stm;
	int *state;

	state = (int*)fz_malloc_struct(ctx, int);
	*state = fd;

	try
	{
		stm = fz_new_stream(ctx, state, read_file, close_file);
	}
	catch(...)
	{
		fz_free(ctx, state);
		throw(21);
	}
	stm->seek = seek_file;

	return stm;
}

fz_stream *
fz_open_file(fz_context *ctx, const char *name)
{
	int fd;
	fd = (int)fopen(name, "rb");
	if (fd == -1){
		printf("cannot open %s", name);
	}
		
	return fz_open_fd(ctx, fd);
}


/* Memory stream */

int read_buffer(fz_stream *stm, unsigned char *buf, int len)
{
	return 0;
}

void seek_buffer(fz_stream *stm, int offset, int whence)
{
	if (whence == 0)
		stm->rp = stm->bp + offset;
	if (whence == 1)
		stm->rp += offset;
	if (whence == 2)
		stm->rp = stm->ep - offset;
	stm->rp = CLAMP(stm->rp, stm->bp, stm->ep);
	stm->wp = stm->ep;
}

void close_buffer(fz_context *ctx, void *state_)
{
	fz_buffer *state = (fz_buffer *)state_;
	if (state)
		fz_drop_buffer(ctx, state);
}

fz_stream *
fz_open_buffer(fz_context *ctx, fz_buffer *buf)
{
	fz_stream *stm;

	fz_keep_buffer(ctx, buf);
	stm = fz_new_stream(ctx, buf, read_buffer, close_buffer);
	stm->seek = seek_buffer;

	stm->bp = buf->data;
	stm->rp = buf->data;
	stm->wp = buf->data + buf->len;
	stm->ep = buf->data + buf->len;

	stm->pos = buf->len;

	return stm;
}

fz_stream *
fz_open_memory(fz_context *ctx, unsigned char *data, int len)
{
	fz_stream *stm;

	stm = fz_new_stream(ctx, NULL, read_buffer, close_buffer);
	stm->seek = seek_buffer;

	stm->bp = data;
	stm->rp = data;
	stm->wp = data + len;
	stm->ep = data + len;

	stm->pos = len;

	return stm;
}
