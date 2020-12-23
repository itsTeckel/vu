FROM itsteckel/wine:latest

WORKDIR /vu

#Vu installation
RUN mkdir -p /vu/client && mkdir -p /vu/instance && mkdir -p /vu/bf3 && mkdir -p /vu/wine

EXPOSE 7948
EXPOSE 25200
EXPOSE 47200

ENV LISTEN 0.0.0.0:25200
ENV HARMONYPORT 7948
ENV RCONPORT 0.0.0.0:47200
ENV TICK "-high120"

ADD entrypoint.sh /vu/client/entrypoint.sh
RUN chmod +x /vu/client/entrypoint.sh

CMD /vu/client/entrypoint.sh