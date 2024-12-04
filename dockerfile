FROM golang:1.23.4-bookworm
# docker run -dit --name wechat -v C:\Users\zen\git\aiwechat-vercel:/app golang:1.23.4-bookworm bash
RUN go env -w GO111MODULE=on
#RUN go env -w GOPROXY=https://goproxy.cn,direct
RUN go env -w GOBIN=/go/bin
RUN go env -w CGO_ENABLED=1

# 设置非交互模式
ENV DEBIAN_FRONTEND=noninteractive

# 更换完整源
COPY debian.sources /etc/apt/sources.list.d/debian.sources

# 更新软件包并安装依赖
RUN apt update && \
    apt install -y --no-install-recommends \
    build-essential  && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

RUN go mod tidy
RUN go build -ldflags "-s -w" -o wchatLLM ./api