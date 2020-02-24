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
  python3-dev \
  perl-app-cpanminus \
  perl
  
RUN apk add --no-cache -t .build \
  gcc \
  make \
  wget \
  git \
  sed\
  gcc \
  bash \
  automake \
  && cpanm Parse::Win32Registry --force
    
#rr download, mod & installation
RUN git clone https://github.com/keydet89/RegRipper2.8.git \ 
  && cd RegRipper2.8 \
  && tail -n +2 rip.pl > rip \
  && perl -pi -e 'tr[\r][]d' rip \
  && sed -i "1i #\!$(which perl)" rip \
  && sed -i 's/\#my\ \$plugindir/\my\ \$plugindir/g' rip \
  && sed -i 's/\#push/push/' rip \
  && sed -i 's/\"plugins\/\"\;/\"\/usr\/share\/regripper\/plugins\/\"\;/' rip \
  && sed -i 's/(\"plugins\")\;/(\"\/usr\/share\/regripper\/plugins\")\;/' rip \
  && mkdir -p /usr/share/regripper/ \
  && cp -r plugins/ /usr/share/regripper/ \
  && mv rip /usr/local/bin/rip.pl \
  && chmod +x /usr/local/bin/rip.pl \
  && cd / 
  
  #volatility3
  RUN git clone https://github.com/volatilityfoundation/volatility3.git \
  && cd volatility3 \
  && python3 setup.py install \
  && cd / \

  && echo "Various tools install" \
    
  #oletools
  && pip3 install -U https://github.com/decalage2/oletools/archive/master.zip \
  
  #ntfs parser, vsc_mount
  && pip3 install https://github.com/msuhanov/dfir_ntfs/archive/1.0.0.tar.gz \
  
  #peframe
  && git clone https://github.com/guelfoweb/peframe.git \
  && cd peframe \
  && python3 setup.py install \
  && cd / \
  && rm -rf /peframe \
  
  #libvshadow
  && wget https://github.com/libyal/libvshadow/releases/download/20191221/libvshadow-alpha-20191221.tar.gz \
  && tar xfv libvshadow-alpha* \
  && cd libvshadow* \
  && ./configure \
  && make \
  && make install \
  && cd / \
  && rm libvshadow-alpha-20191221.tar.gz \
  && rm -rf libvshadow-* \
  && rm -rf /volatility3 \
  && rm -rf /RegRipper2.8 \
  && apk del --purge .build 
 

WORKDIR /cases
