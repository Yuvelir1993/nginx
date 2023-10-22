FROM golang:1.21.3

WORKDIR /app

COPY . .

RUN go build

EXPOSE 3333
EXPOSE 4444

CMD ["./main"]
