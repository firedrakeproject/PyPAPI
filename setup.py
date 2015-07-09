from Cython.Distutils import build_ext
from distutils.core import setup
from distutils.extension import Extension
import numpy

src = "pypapi/papi.pyx"

papi_dir = "/usr/local"

includes = [numpy.get_include(), "%s/include" % papi_dir]
libraries = ["papi"]
link_args = ["-L%s/lib" % papi_dir, "-Wl,-rpath,%s/lib" % papi_dir]

setup(name="PyPAPI",
      version="alpha",
      description="Bindings for PAPI",
      cmdclass={"build_ext": build_ext},
      ext_modules=[Extension("pypapi.papi", [src],
                             include_dirs=includes,
                             libraries=libraries,
                             extra_link_args=link_args)])
