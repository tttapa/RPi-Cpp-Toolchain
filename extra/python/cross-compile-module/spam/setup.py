from setuptools import setup, Extension

spam_module = Extension('spam', sources = ['spammodule.c'])
description = """This is the standard Spam demo module
https://docs.python.org/3/extending/extending.html"""

setup(name = 'spam',
      version = '0.0.1',
      description = description,
      ext_modules = [spam_module])