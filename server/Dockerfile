FROM node:24-bookworm-slim
EXPOSE 8765
WORKDIR /server

COPY server.js .
RUN npm install ws colors moment

USER node
ENTRYPOINT ["node", "server.js"]
