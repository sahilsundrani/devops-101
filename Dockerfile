FROM node:20-alpine

RUN /bin/sh <<EOF
apk update
apk add --no-cache nano
EOF

WORKDIR /app

COPY ./package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

ENV NODE_ENV=development

# CMD ["npx", "nodemon", "index.js"]
CMD ["npm", "start"]