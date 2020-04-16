from setuptools import setup
from Cython.Build import cythonize

setup(
    name='hello',
    version='0.0.1',
    ext_modules=cythonize("hello.pyx"),
    zip_safe=False,
)