#include "fitz-internal.h"

void *
fz_malloc(fz_context *ctx, unsigned int size)
{
	void *p;

	if (size == 0)
		return NULL;

	p = malloc(size);
	if (!p)
		fz_throw(ctx,"malloc of bytes failed");
	return p;
}

void *
fz_malloc_no_throw(fz_context *ctx, unsigned int size)
{
	return malloc(size);
}

void *
fz_malloc_array(fz_context *ctx, unsigned int count, unsigned int size)
{
	void *p;

	if (count == 0 || size == 0)
		return 0;

	if (count > UINT_MAX / size)
		fz_throw(ctx, "malloc of array failed (integer overflow)");
	    

	p = malloc(count * size);
	if (!p)
		fz_throw(ctx, "malloc of array failed");
	return p;
}

void *
fz_malloc_array_no_throw(fz_context *ctx, unsigned int count, unsigned int size)
{
	if (count == 0 || size == 0)
		return 0;

	if (count > UINT_MAX / size)
	{
		fprintf(stderr, "error: malloc of array (%d x %d bytes) failed (integer overflow)", count, size);
		return NULL;
	}

	return malloc(count * size);
}

void *
fz_calloc(fz_context *ctx, unsigned int count, unsigned int size)
{
	void *p;

	if (count == 0 || size == 0)
		return 0;

	if (count > UINT_MAX / size)
	{
		fz_throw(ctx, "calloc failed (integer overflow)");
	}

	p = malloc(count * size);
	if (!p)
	{
		fz_throw(ctx, "calloc (%d x %d bytes) failed");
	}
	memset(p, 0, count*size);
	return p;
}

void *
fz_calloc_no_throw(fz_context *ctx, unsigned int count, unsigned int size)
{
	void *p;

	if (count == 0 || size == 0)
		return 0;

	if (count > UINT_MAX / size)
	{
		fprintf(stderr, "error: calloc (%d x %d bytes) failed (integer overflow)\n", count, size);
		return NULL;
	}

	p = malloc(count * size);
	if (p)
	{
		memset(p, 0, count*size);
	}
	return p;
}

void *
fz_resize_array(fz_context *ctx, void *p, unsigned int count, unsigned int size)
{
	void *np;

	if (count == 0 || size == 0)
	{
		fz_free(ctx, p);
		return 0;
	}

	if (count > UINT_MAX / size)
		fz_throw(ctx, "resize array failed (integer overflow)");

	np = realloc(p, count * size);
	if (!np)
		fz_throw(ctx, "resize array failed");
	return np;
}

void *
fz_resize_array_no_throw(fz_context *ctx, void *p, unsigned int count, unsigned int size)
{
	if (count == 0 || size == 0)
	{
		fz_free(ctx, p);
		return 0;
	}

	if (count > UINT_MAX / size)
	{
		fprintf(stderr, "error: resize array (%d x %d bytes) failed (integer overflow)\n", count, size);
		return NULL;
	}

	return realloc( p, count * size);
}

void
fz_free(fz_context *ctx, void *p)
{
	free(p);
}

char *
fz_strdup(fz_context *ctx, char *s)
{
	int len = strlen(s) + 1;
	char *ns = (char*)fz_malloc(ctx, len);
	memcpy(ns, s, len);
	return ns;
}

char *
fz_strdup_no_throw(fz_context *ctx, char *s)
{
	int len = strlen(s) + 1;
	char *ns = (char*)fz_malloc_no_throw(ctx, len);
	if (ns)
		memcpy(ns, s, len);
	return ns;
}

