FROM alpine:latest
LABEL maintainer = "November (novemb3r@protonmail.ch)"

RUN apk add --no-cache libc-dev \
  pcre-dev \
  swig \
  libmagic\
  libffi-dev \
  openssl-dev\
  libtool \
  fuse-dev \
  ca-certificates \
  tzdata \
  python3-dev 
  
RUN apk add --no-cache -t .build \
  gcc \
  make \
  wget \
  git \
  sed\
  gcc \
  bash \
  automake 
    
  #prepare perl
  RUN cd /tmp \
  && wget http://www.cpan.org/src/5.0/perl-5.24.0.tar.gz \
  && tar xvzf perl-5.24.0.tar.gz \
  && cd perl-5.24.0 \
  && ./Configure -des && make && make install \
  && cd /tmp && rm -rf perl-5.24.0* \
  && cd /usr/local/bin \
  && wget https://cpanmin.us/ -O cpanm \
  && chmod +x cpanm \
  && cd / \
  && mkdir /usr/local/lib/rip-lib \
  && cpanm -l /usr/local/lib/rip-lib Parse::Win32Registry \
 
  #rr download, mod & installation
  && git clone https://github.com/keydet89/RegRipper2.8.git \ 
  && cd RegRipper2.8 \
  && tail -n +2 rip.pl > rip \
  && perl -pi -e 'tr[\r][]d' rip \
  && sed -i "1i #!`which perl`" rip \
  && sed -i '2i use lib qw(/usr/local/lib/rip-lib/lib/perl5/);' rip \
  && cp rip /usr/local/bin/rip \
  && chmod +x /usr/local/bin/rip \
  && mkdir /usr/share/regripper \
  && cp -R ./plugins/ /usr/share/regripper \
  && chmod -R 644 /usr/share/regripper/* \
  && cd / 
  
  
  #volatility3
  RUN git clone https://github.com/volatilityfoundation/volatility3.git \
  && cd volatility3 \
  && python3 setup.py install \
  && cd / \

  && echo "Various tools install" \
    
  #oletools
  && pip install -U https://github.com/decalage2/oletools/archive/master.zip \
  
  #ntfs parser, vsc_mount
  && pip3 install https://github.com/msuhanov/dfir_ntfs/archive/1.0.0.tar.gz \
  
  #peframe
  && git clone https://github.com/guelfoweb/peframe.git \
  && cd peframe \
  && python3 setup.py install \
  && cd / \
  && rm -rf /peframe \
  
  #libvshadow
  && wget https://github.com/libyal/libvshadow/releases/download/20191103/libvshadow-alpha-20191103.tar.gz \
  && tar xfv libvshadow-alpha* \
  && cd libvshadow* \
  && ./configure \
  && make \
  && make install \
  && cd / \
  && rm -rf /libvshadow-20191103 \
  && rm libvshadow* \
   
  #flarestrings/rank_strings
  #&& git clone https://github.com/fireeye/stringsifter.git \
  #&& cd stringsifter \
  #&& pip3 install -e . \
  #&& cd / \
  #&& rm -rf /stringsifter \
  #&& chmod 755 /usr/local/bin/* \
   
  && echo "---- Cleaning up ----" \
  && rm -rf /volatility3 \
  && rm -rf /RegRipper2.8 \
  && apk del --purge .build 

WORKDIR /cases
