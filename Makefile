MINICONDA ?= "Miniconda-latest-Linux-x86_64.sh"

build-odes:
	conda config --add channels logicabrity 
	conda config --add channels cyclus
	conda config --add channels anaconda
	conda build odes

install-conda:
	wget https://repo.continuum.io/miniconda/$(MINICONDA) -O miniconda.sh;
	bash ./miniconda.sh -b -p $$HOME/miniconda
	conda install --yes conda-build
	conda upgrade --yes conda conda-build

install-odes:
	conda install --yes --use-local odes

install-python-2-compability:
	pip install enum34

.PHONY: build-odes install-conda install-odes install-python-2-compability
