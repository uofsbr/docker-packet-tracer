FROM ubuntu:18.04

MAINTAINER uofs uofs.br@gmail.com 

RUN apt-get update && apt-get install -y tar xauth libqt5webkit5 libqt5xml5 libqt5multimedia5 libqt5script5 libqt5scripttools5 qt-at-spi sudo libnss3 libxss1 libasound2 less
COPY PacketTracer_730_amd64.deb /PacketTracer_730_amd64.deb

RUN export uid=1000 gid=1000 \
  && mkdir -p /home/pt \
  && echo "pt:x:${uid}:${gid}:pt,,,:/home/pt:/bin/bash" >> /etc/passwd \
  && echo "pt:x:${uid}:" >> /etc/group \
  && mkdir /home/pt/storage \
  && chown ${uid}:${gid} -Rv /home/pt \
  && mkdir -p pt_package/DEBIAN \
  && dpkg-deb -x /PacketTracer_730_amd64.deb /pt_package/ \
  && dpkg-deb -e /PacketTracer_730_amd64.deb /pt_package/DEBIAN/ \
  && rm -f /pt_package/DEBIAN/preinst \
  && dpkg-deb -Z xz -b /pt_package/ . \
  && dpkg -i /packettracer_7.3.0_amd64.deb \
  && rm -f /*.deb \
  && rm -f /*packetTracer_730_amd64.deb \
  && rm -rf /pt_package \
  && chown ${uid}:${gid} -Rv /opt/pt

COPY packettracer /usr/local/bin/packettracer
RUN chmod +x /usr/local/bin/packettracer

USER pt
ENV HOME /home/pt
CMD /usr/local/bin/packettracer
