FROM debian

RUN apt-get update && apt-get install -y \
    rsync \
    openssh-client \
    python3 \
    python3-pip \
    python3-venv \
    texlive

# Create and activate a virtual environment
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Install virtualenv inside the virtual environment
RUN /venv/bin/pip install virtualenv

CMD ["/bin/bash"]