#! /bin/bash

: ${SRCPATH:=../glpi-agent}

IDXPAGE="source/man/index.rst"
cat <<INDEX >$IDXPAGE
Man pages
=========

.. toctree::
   :maxdepth: 3

INDEX

for PAGE in glpi-agent glpi-inventory glpi-netdiscovery glpi-netinventory      \
    glpi-esx glpi-injector glpi-remote glpi-win32-service
do
    SRCPAGE="$SRCPATH/bin/$PAGE"
    DSTPAGE="source/man/$PAGE.rst"

    echo "   $PAGE"   >> $IDXPAGE

    echo $PAGE        >  $DSTPAGE
    echo ${PAGE//?/=} >> $DSTPAGE
    echo              >> $DSTPAGE

    if [ -e "${DSTPAGE%.rst}.inc" ]; then
        echo ".. include:: $PAGE.inc" >> $DSTPAGE
        echo                          >> $DSTPAGE
    fi

    perldoc -ohtml $SRCPAGE | \
        pandoc -f html -t rst --shift-heading-level-by=1 | \
        sed -e 's/^::$/.. code-block:: text/' >> $DSTPAGE
done
