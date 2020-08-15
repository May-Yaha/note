FROM node as note-bulid
WORKDIR /app
COPY . /app
RUN npm install ydoc -g --registry=https://registry.npm.taobao.org
RUN ydoc build

FROM nginx as note-route
COPY --from=note-bulid /app/_site/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]