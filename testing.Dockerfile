# todo: change to 5.5?
FROM  --platform=linux/amd64 swift:5.5

WORKDIR /package

COPY . ./

CMD ["swift", "test", "--enable-test-discovery"]
