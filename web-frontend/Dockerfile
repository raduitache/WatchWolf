FROM node:18.1.0-alpine3.15

WORKDIR /usr/src/watchwolf-frontend

COPY *.json ./
RUN npm ci
COPY src/ src/

RUN npm run build
# RUN rm -rf src
# RUN rm *.json

EXPOSE 4200

# CMD ["node", "dist/web-frontend"]
# CMD npm run ng serve --host=0.0.0.0 --disable-host-check
CMD npx ng serve --host=0.0.0.0 --disable-host-check
