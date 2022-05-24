FROM node:18.1.0-alpine3.15

WORKDIR /usr/src/watchwolf-frontend

COPY *.json ./
RUN npm ci
COPY src/ src/

RUN npm run build
# RUN rm -rf src
# RUN rm *.json
RUN npm install lite-server

EXPOSE 4200

# CMD ["node", "dist/web-frontend"]
CMD npx lite-server --baseDir="dist/web-frontend" --host=0.0.0.0 --disable-host-check
