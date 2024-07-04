## This sample demonstrates how to implement a dynamic DSL workflow with temporal

1. Download golang package `go mod download`

2. Bootstrap temporal stack with `make up`

3. Start worker `go run worker/main.go`

4. Start new workflow with dsl config `go run starter/main.go -dslConfig=workflow1.yaml`

5. Access temporal UI at `localhost:8080`
