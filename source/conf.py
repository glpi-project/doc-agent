# Configuration file for the Sphinx documentation builder.
#
# This file only contains a selection of the most common options. For a full
# list see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Path setup --------------------------------------------------------------
import datetime
import sphinx_rtd_theme

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use os.path.abspath to make it absolute, like shown here.
#
# import os
# import sys
# sys.path.insert(0, os.path.abspath('.'))


# -- Project information -----------------------------------------------------

# The version info for the project you're documenting, acts as replacement for
# |version| and |release|, also used in various other places throughout the
# built documents.
#
# The short X.Y version.
version = u'1.5'
# The full version, including alpha/beta/rc tags.
release = u'1.5'

project = 'GLPI Agent'
thisyear = datetime.datetime.now().year
copyright = u'2016-%s, GLPI Project, Teclib\'' % thisyear
author = u'GLPI Project, Teclib\''

rst_prolog = """
.. |version| replace:: %s
""" % version

# -- General configuration ---------------------------------------------------

# Add any Sphinx extension module names here, as strings. They can be
# extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
# ones.
extensions = [
    'sphinx_rtd_theme',
    'sphinx-prompt',
    'sphinx_substitution_extensions',
    'sphinx.ext.todo',
    'sphinx.ext.ifconfig',
    'sphinxcontrib.mermaid',
]

todo_include_todos = True

# Add any paths that contain templates here, relative to this directory.
templates_path = ['_templates']

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = []


# -- Options for HTML output -------------------------------------------------

# The theme to use for HTML and HTML Help pages.  See the documentation for
# a list of builtin themes.
#
html_theme = "sphinx_rtd_theme"

# html_logo = None
html_logo = '_static/images/glpi-agent.png'

# Add any paths that contain custom static files (such as style sheets) here,
# relative to this directory. They are copied after the builtin static files,
# so a file named "default.css" will overwrite the builtin "default.css".
html_static_path = ['_static']

# If true, links to the reST sources are added to the pages.
#
# html_show_sourcelink = True
html_show_sourcelink = False

html_theme_options = {
    #'style_nav_header_background': 'white',
    'logo_only': False,
    # Toc options
    'collapse_navigation': True,
    'sticky_navigation': True,
    'navigation_depth': 6,
    'includehidden': True,
    'titles_only': False,
    # Misc options
    'prev_next_buttons_location': 'both',
}

html_favicon = '_static/images/favicon.ico'

# Disable smartquotes to avoid dash concatenation on man pages
smartquotes = False
