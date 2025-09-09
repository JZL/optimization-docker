FROM quay.io/jupyter/minimal-notebook:python-3.13

LABEL maintainer="Bartolomeo Stellato <bartolomeo.stellato@gmail.com>"

# Install C/C++ build + latex packages for correct fonts
USER root
RUN apt-get update && \
    apt-get install -y cm-super dvipng build-essential cmake libopenblas-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


USER ${NB_UID}

RUN curl -fsSL https://install.julialang.org > /tmp/julia.sh && \
    sh /tmp/julia.sh --yes

# Install from the requirements.txt file
# add JuMP, DataFrames, Plots, HiGHS
COPY --chown=${NB_UID}:${NB_GID} Manifest.toml /home/${NB_USER}
COPY --chown=${NB_UID}:${NB_GID} Project.toml  /home/${NB_USER}

RUN bash -c ". ~/.profile; julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.precompile()'"

RUN sed -i "s,@[.],/home/jovyan," /home/jovyan/.local/share/jupyter/kernels/julia-*/kernel.json

COPY --chown=${NB_UID}:${NB_GID} 01_Test_Julia.ipynb  /home/${NB_USER}

CMD ["start-notebook.py", "--IdentityProvider.token=''"]



# RUN pip install --no-cache-dir --requirement /tmp/requirements.txt && \
#     fix-permissions "${CONDA_DIR}" && \
#     fix-permissions "/home/${NB_USER}"

# # Switch back to jovyan to avoid accidental container runs as root
# USER ${NB_UID}

# CMD ["start-notebook.py", "--IdentityProvider.token=''"]
