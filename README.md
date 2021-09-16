# GLPI Agent documentation

[![Documentation Status](https://readthedocs.org/projects/glpi-agent/badge/?version=latest)](https://glpi-agent.readthedocs.io/en/latest/?badge=latest)

Current documentation is built on top of [Sphinx documentation generator](http://sphinx-doc.org/). 

Documentation is released under the terms of the Creative Commons License Attribution-ShareAlike 3.0 France [CC BY-SA 3.0 FR](https://creativecommons.org/licenses/by-sa/3.0/fr/deed.en).

## View it online!

[GLPI Agent documentation is currently visible on ReadTheDocs](http://glpi-agent.rtfd.io/).

## Run it!

You'll have to install [Python Sphinx](http://sphinx-doc.org/) 1.3 minimum, and Python Markdown module (`recommonmark`) (until rewrite to restructured text will be complete).

If your distribution does not provide this version, you could use a `virtualenv`:
```
$ virtualenv /path/to/virtualenv/files
$ /path/to/virtualenv/bin/activate
$ pip install -r requirements.txt
```

Once all has been successfully installed, just run the following to build the documentation:
```
$ make html
```

Results will be avaiable in the `build/html` directory :)

Note that it actually uses the default theme, which differs locally and on readthedocs system.

Note also to not use docutils earlier than 0.16 as 0.17.1 still breaks pages as of this writing.

## Autobuild

Autobuild automatically rebuild and refresh the current page on edit.
To use it, you need the `sphinx-autobuild` module:
```
$ pip install sphinx-autobuild
```

You can then use the `livehtml` command:
```
$ make livehtml
```

<a rel="license" href="http://creativecommons.org/licenses/by-sa/3.0/fr/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/3.0/fr/80x15.png" /></a>
