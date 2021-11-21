# DemoVapor_TILApp

**Reset DB**

```
docker stop postgres
docker rm postgres
docker run --name postgres 
  -e POSTGRES_DB=vapor_database \
  -e POSTGRES_USER=vapor_username \
  -e POSTGRES_PASSWORD=vapor_password \
  -p 5432:5432 -d postgres
```

for test

```
docker run --name postgres-test \
  -e POSTGRES_DB=vapor-test \
  -e POSTGRES_USER=vapor_username \
  -e POSTGRES_PASSWORD=vapor_password \
  -p 5433:5432 -d postgres
```

## cURL sample

```
curl -s -X POST http://localhost:8080/api/acronyms \
  -H "Content-Type: application/json" \
  -d @- << EOS
{
  "long": "Oh My God",
  "short": "OMG",
  "userID": "1BB31054-9ECD-4258-80CF-BB754E1CA0DD"
}
EOS
```

```
curl -s -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d @- << EOS
{
  "name": "Yoki",
  "username": "yyokii"
}
EOS
```

```
curl -s -X PUT http://localhost:8080/api/acronyms/EA20038C-DF32-4D33-8346-3F6C42D3BE46 \
  -H "Content-Type: application/json" \
  -d @- << EOS
{
  "long": "Oh My God",
  "short": "OMG"
}
EOS
```

```
curl -s -X DELETE http://localhost:8080/api/acronyms/740B5762-661E-40C9-B2B9-B4601B2D10E1
```
