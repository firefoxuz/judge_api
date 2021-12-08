FROM buildpack-deps:buster

ENV GCC_VERSIONS \
      10.1.0 
RUN set -xe && \
    for VERSION in $GCC_VERSIONS; do \
      curl -fSsL "https://ftpmirror.gnu.org/gcc/gcc-$VERSION/gcc-$VERSION.tar.gz" -o /tmp/gcc-$VERSION.tar.gz && \
      mkdir /tmp/gcc-$VERSION && \
      tar -xf /tmp/gcc-$VERSION.tar.gz -C /tmp/gcc-$VERSION --strip-components=1 && \
      rm /tmp/gcc-$VERSION.tar.gz && \
      cd /tmp/gcc-$VERSION && \
      ./contrib/download_prerequisites && \
      { rm *.tar.* || true; } && \
      tmpdir="$(mktemp -d)" && \
      cd "$tmpdir"; \
      if [ $VERSION = "9.2.0" ]; then \
        ENABLE_FORTRAN=",fortran"; \
      else \
        ENABLE_FORTRAN=""; \
      fi; \
      /tmp/gcc-$VERSION/configure \
        --disable-multilib \
        --enable-languages=c,c++$ENABLE_FORTRAN \
        --prefix=/usr/local/gcc-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install-strip && \
      rm -rf /tmp/*; \
    done


# Check for latest version here: https://www.python.org/downloads
ENV PYTHON_VERSIONS \
      2.7.17
RUN set -xe && \
    for VERSION in $PYTHON_VERSIONS; do \
      curl -fSsL "https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tar.xz" -o /tmp/python-$VERSION.tar.xz && \
      mkdir /tmp/python-$VERSION && \
      tar -xf /tmp/python-$VERSION.tar.xz -C /tmp/python-$VERSION --strip-components=1 && \
      rm /tmp/python-$VERSION.tar.xz && \
      cd /tmp/python-$VERSION && \
      ./configure \
        --prefix=/usr/local/python-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done



# Check for latest version here: https://nodejs.org/en
ENV NODE_VERSIONS \
      14.2.0
RUN set -xe && \
    for VERSION in $NODE_VERSIONS; do \
      curl -fSsL "https://nodejs.org/dist/v$VERSION/node-v$VERSION.tar.gz" -o /tmp/node-$VERSION.tar.gz && \
      mkdir /tmp/node-$VERSION && \
      tar -xf /tmp/node-$VERSION.tar.gz -C /tmp/node-$VERSION --strip-components=1 && \
      rm /tmp/node-$VERSION.tar.gz && \
      cd /tmp/node-$VERSION && \
      ./configure \
        --prefix=/usr/local/node-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://golang.org/dl
ENV GO_VERSIONS \
      1.13.5
RUN set -xe && \
    for VERSION in $GO_VERSIONS; do \
      curl -fSsL "https://storage.googleapis.com/golang/go$VERSION.linux-amd64.tar.gz" -o /tmp/go-$VERSION.tar.gz && \
      mkdir /usr/local/go-$VERSION && \
      tar -xf /tmp/go-$VERSION.tar.gz -C /usr/local/go-$VERSION --strip-components=1 && \
      rm -rf /tmp/*; \
    done

# Check for latest version here: https://www.php.net/downloads
ENV PHP_VERSIONS \
      7.4.1
RUN set -xe && \
    apt-get update && \
    apt-get install -y --no-install-recommends bison re2c && \
    rm -rf /var/lib/apt/lists/* && \
    for VERSION in $PHP_VERSIONS; do \
      curl -fSsL "https://codeload.github.com/php/php-src/tar.gz/php-$VERSION" -o /tmp/php-$VERSION.tar.gz && \
      mkdir /tmp/php-$VERSION && \
      tar -xf /tmp/php-$VERSION.tar.gz -C /tmp/php-$VERSION --strip-components=1 && \
      rm /tmp/php-$VERSION.tar.gz && \
      cd /tmp/php-$VERSION && \
      ./buildconf --force && \
      ./configure \
        --prefix=/usr/local/php-$VERSION && \
      make -j$(nproc) && \
      make -j$(nproc) install && \
      rm -rf /tmp/*; \
    done


LABEL maintainer="Sultonov Daler Rustamovich <daler.sultonov.00@gmail.com>"
LABEL version="1.0.0"
