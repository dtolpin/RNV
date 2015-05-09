/* $Id: rnvmodule.c,v 1.5 2006/11/07 10:24:54 dvd Exp $ */

#include <Python.h>
#include <er.h>
#include <rn.h>
#include <rnl.h>
#include <rnv.h>

/* error messages go to static buffer */
#define ERBUFLEN 1024
static char erbuf[ERBUFLEN];

int
ervprintf(char *format, va_list ap)
{
  int len = strlen(erbuf);
  return vsnprintf(erbuf+len, ERBUFLEN-len, format, ap);
}

static PyObject *
error(PyObject *self, PyObject *args)
{
  if(!PyArg_ParseTuple(args,"")) return NULL;

  return Py_BuildValue("s", erbuf);
}

static PyObject *
load(PyObject *self, PyObject *args)
{
  char *name;
  int start = 0;

  *erbuf = 0;
  if(!PyArg_ParseTuple(args, "s", &name)) return NULL;
  start = rnl_fn(name);
  
  return Py_BuildValue("(ii)", !!start, start);
}

static PyObject *
text(PyObject *self, PyObject *args)
{
  char *text; int len, mixed;
  int prevp = rn_notAllowed, curp;
  int ok;

  *erbuf = 0;
  if(!PyArg_ParseTuple(args, "is#i", &curp, &text, &len, &mixed)) return NULL;
  ok = rnv_text(&curp, &prevp, text, len, mixed);

  return Py_BuildValue("(ii)", ok, curp);
}

static PyObject *
start_tag_open(PyObject *self, PyObject *args)
{
  char *name;
  int prevp = rn_notAllowed, curp;
  int ok;

  *erbuf = 0;
  if(!PyArg_ParseTuple(args,"is",&curp,&name)) return NULL;
  ok = rnv_start_tag_open(&curp, &prevp, name);

  return Py_BuildValue("(ii)", ok, curp);
}

static PyObject *
attribute(PyObject *self, PyObject *args)
{
  char *name, *val;
  int prevp = rn_notAllowed, curp;
  int ok;

  *erbuf = 0;
  if(!PyArg_ParseTuple(args,"iss",&curp,&name,&val)) return NULL;
  ok = rnv_attribute(&curp,&prevp,name,val);

  return Py_BuildValue("(ii)", ok, curp);
}

static PyObject *
start_tag_close(PyObject *self, PyObject *args)
{
  char *name;
  int prevp = rn_notAllowed, curp;
  int ok;

  *erbuf = 0;
  if(!PyArg_ParseTuple(args,"is",&curp,&name)) return NULL;
  ok = rnv_start_tag_close(&curp, &prevp, name);

  return Py_BuildValue("(ii)", ok, curp);
}

static PyObject *
end_tag(PyObject *self, PyObject *args)
{
  char *name;
  int prevp = rn_notAllowed, curp;
  int ok;


  *erbuf = 0;
  if(!PyArg_ParseTuple(args,"is",&curp,&name)) return NULL;
  ok = rnv_end_tag(&curp, &prevp, name);

  return Py_BuildValue("(ii)", ok, curp);
}

static PyMethodDef RnvMethods[] = {
  {"error", error, METH_VARARGS, "Return last error message."},
  {"load", load, METH_VARARGS, "Load Relax NG grammar."},
  {"text", text, METH_VARARGS, "Validate a text element."},
  {"start_tag_open", start_tag_open, METH_VARARGS, "Validate the beginning of a start tag."},
  {"attribute", attribute, METH_VARARGS, "Validate an attribute."},
  {"start_tag_close", start_tag_close, METH_VARARGS, "Validate the end of a start tag."},
  {"end_tag", end_tag, METH_VARARGS, "Validate an end tag."},
  {NULL, NULL, 0, NULL}
};

PyMODINIT_FUNC
initrnv(void)
{
  PyObject *m;

  er_vprintf = &ervprintf;
  rnl_init();
  rnv_init();
  m = Py_InitModule("rnv", RnvMethods);
  PyModule_AddObject(m,"notAllowed",Py_BuildValue("i",rn_notAllowed));
}
