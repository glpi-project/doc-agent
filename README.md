# GLPI Agent documentation

[![Documentation Status](https://readthedocs.org/projects/glpi-agent/badge/?version=latest)](https://glpi-agent.readthedocs.io/en/latest/?badge=latest)

Current documentation is built on top of [Sphinx documentation generator](http://sphinx-doc.org/). 

Documentation is released under the terms of the Creative Commons License Attribution-ShareAlike 4.0 [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/).

## View it online!

[GLPI Agent documentation is currently visible on ReadTheDocs](http://glpi-agent.rtfd.io/).

## Run it!

You'll have to install [Python Sphinx](http://sphinx-doc.org/) 1.3 minimum.

If your distribution does not provide this version, you could use a `virtualenv`:
```
$ virtualenv /path/to/virtualenv
$ source /path/to/virtualenv/bin/activate
$ pip install -r requirements.txt
```

Once all has been successfully installed, just run the following to build the documentation:
```
$ make html
```

Results will be avaiable in the `build/html` directory :)

Note that it actually uses the readthedocs theme installed in your virtual environment and it can differ locally from the one on readthedocs system.

## Autobuild

Autobuild automatically rebuild and refresh the current page on edit.
To use it, you need the `sphinx-autobuild` module:
```
$ pip install sphinx-autobuild
```

You can then use the `sphinx-autobuild` command:
```
$ sphinx-autobuild source build/html
```

And access your documentation on the proposed link: `http://127.0.0.1:8000`

<a rel="license" href="https://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://licensebuttons.net/l/by-sa/4.0/80x15.png" /></a>
