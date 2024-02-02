FROM debian

RUN apt-get update && apt-get install -y \
    rsync \
    openssh-client \
    python3 \
    python3-pip \
    texlive

RUN python3 -m venv /venv

CMD ["/bin/bash"]