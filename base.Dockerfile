FROM silentmecha/steamcmd:latest

LABEL maintainer="silent@silentmecha.co.za"

ENV STEAMAPP_ID=294420
ENV STEAMAPP=7DaysToDie
ENV STEAMAPPDIR="${HOME}/${STEAMAPP}-dedicated"
ENV STEAM_SAVEDIR="${HOME}/.local/share/7DaysToDie"
ENV AUTO_UPDATE=True
ENV STEAM_LOGIN=anonymous

USER root

COPY ./src/entry.sh ${HOME}/entry.sh

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		xmlstarlet \
		telnet \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/*

RUN set -x \
	&& mkdir -p "${STEAMAPPDIR}" \
	&& mkdir -p "${STEAM_SAVEDIR}" \
	&& chmod +x "${HOME}/entry.sh" \
	&& chown -R "${USER}:${USER}" "${HOME}/entry.sh" "${STEAMAPPDIR}" "${STEAM_SAVEDIR}" \
	&& chmod -R 744 "${STEAM_SAVEDIR}"

ENV SERVERNAME=ServerName \
	SERVERPORT=26900 \
	SERVERPORT_1=26901 \
	SERVERPORT_2=26902 \
	SERVERVISIBILITY=2 \
	SERVERPASSWORD= \
	SERVERMAXPLAYERCOUNT=8 \
	SERVERRESERVEDSLOTS=0 \
	SERVERADMINSLOTS=0 \
	SERVERDESCRIPTION="A 7 Days to Die server running inside of docker" \
	SERVERWEBSITEURL= \
	EACENABLED=true \
	GAMEWORLD=Navezgane \
	GAMENAME="My Game" \
	WORLDGENSEED="asdf" \
	WORLDGENSIZE=4096 \
	PLAYERKILLINGMODE=3 \
	CONTROLPANELPORT=8080 \
	CONTROLPANELENABLED=true \
	CONTROLPANELPASSWORD="CHANGEME" \
	TELNETENABLED=true \
	TELNETPORT=8081 \
	TELNETPASSWORD= \
	ADDITIONAL_ARGS=

# Switch to user
USER ${USER}

VOLUME ${STEAM_SAVEDIR}

WORKDIR ${HOME}

EXPOSE 8081/tcp \
		8080/tcp \
		26900/tcp \
		26900/udp \
		26901/udp \
		26902/udp

CMD ["bash", "entry.sh"]
