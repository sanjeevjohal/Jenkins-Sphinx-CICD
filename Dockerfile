FROM debian

RUN apt-get update && apt-get install -y \
    rsync \
    openssh-client \
    python3 \
    python3-pip \
    texlive

RUN pip install virtualenv

CMD ["/bin/bash"]