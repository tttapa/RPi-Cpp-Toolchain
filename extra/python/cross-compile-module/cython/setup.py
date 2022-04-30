from setuptools import setup
from Cython.Build import cythonize

setup(
    name='hello',
    version='0.0.1',
    ext_modules=cythonize("hello.pyx", language_level=3),
    zip_safe=False,
)