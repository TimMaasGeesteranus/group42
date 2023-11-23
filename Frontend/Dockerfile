#FROM cirrusci/flutter:latest AS build

#WORKDIR /app

#COPY pubspec.yaml pubspec.lock ./

#RUN dart pub get

#COPY . .

#RUN dart build web

#EXPOSE 8080

#CMD ["flutter", "run", "-d", "web", "--web-hostname", "0.0.0.0", "--web-port", "8080"]

FROM cirrusci/flutter AS build

RUN flutter upgrade
RUN flutter config --enable-web

RUN mkdir /app/
COPY . /app/
WORKDIR /app/
RUN flutter build web

