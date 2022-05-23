FROM node:18.1.0-alpine3.15

WORKDIR /usr/share/watchwolf

COPY *.json ./
RUN npm ci
COPY src/ src/

RUN npm run build
RUN rm -rf src
RUN rm *.json

CMD ["node", "dist/main"]
