FROM alpine:latest
LABEL maintainer = "November (novemb3r@protonmail.ch)"

RUN apk add --no-cache -t .build \
  make \
  gcc \
  libc-dev \
  wget \
  ca-certificates \
  tzdata \
  git \
  sed\
  gcc \
  bash \
  
  #prepare perl
  && cd /tmp \
  && wget http://www.cpan.org/src/5.0/perl-5.24.0.tar.gz \
  && tar xvzf perl-5.24.0.tar.gz \
  && cd perl-5.24.0 \
  && ./Configure -des && make && make install \
  && cd /tmp && rm -rf perl-5.24.0* \
  && cd /usr/local/bin \
  && wget https://cpanmin.us/ -O cpanm \
  && chmod +x cpanm \
  
  #prepare reg
  && mkdir /usr/local/lib/rip-lib \
  && cpanm -l /usr/local/lib/rip-lib Parse::Win32Registry \
  
  #rr download, mod & installation
  && git clone https://github.com/keydet89/RegRipper2.8.git \ 
  && cd RegRipper2.8 \
  && tail -n +2 rip.pl > rip \
  && perl -pi -e 'tr[\r][]d' rip \
  && sed -i "1i #!`which perl`" rip \
  && sed -i '2i use lib qw(/usr/local/lib/rip-lib/lib/perl5/);' rip \
  && cp rip /usr/local/bin/rip.pl \
  && chmod +x /usr/local/bin/rip.pl \
  && mkdir /usr/local/bin/plugins \
  && cp plugins/* /usr/local/bin/plugins \
  && cd \

  #volatility3
  && git clone https://github.com/volatilityfoundation/volatility3.git
  && cd volatility3 \
  && python3 setup.py install \
  && cd / \
  && chmod 644 /sift-files/volatility/*.py \
  && mkdir /plugins \
  && cp /sift-files/volatility/*.py /plugins \

  && echo "---- Cleaning up ----" \
  && rm -rf /RegRipper2.8
  && apk del --purge .build 
  
  && echo "---- Cleaning up ----" \
  && rm -rf /volatility3 \
  && rm -rf /RegRipper2.8 \
  && apk del --purge .build 

WORKDIR /cases
