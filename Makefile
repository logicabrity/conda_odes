MINICONDA ?= "Miniconda-latest-Linux-x86_64.sh"

build-odes:
	conda config --add channels logicabrity 
	conda config --add channels cyclus
	conda config --add channels anaconda
	conda build odes

install-conda:
	wget https://repo.continuum.io/miniconda/$(MINICONDA) -O miniconda.sh;
	bash ./miniconda.sh -b -p $$HOME/miniconda
	conda install --quiet --yes conda-build
	conda upgrade --quiet --yes conda conda-build

install-odes:
	conda install --yes --use-local odes

workaround-enum34:
	# We don't need to install the package enum34 for python >= 3.4.
	# However, we can't express that in the conda recipe itself.
	sed -i 's/\- enum34/\# enum34 \# deactivated for python \>\= 3\.4/g' odes/meta.yaml

.PHONY: build-odes install-conda install-odes workaround-enum34
