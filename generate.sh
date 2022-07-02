#!/bin/bash

set -e

OUTPUT_BASE=gen
OUTPUT_GOLANG=$OUTPUT_BASE/go

# remove all generated files
rm -rf $OUTPUT_BASE
mkdir -p $OUTPUT_GOLANG

# For golang
# make sure tools are installed
go mod tidy
go install \
    google.golang.org/protobuf/cmd/protoc-gen-go \
    google.golang.org/grpc/cmd/protoc-gen-go-grpc


ROOT_PATH=$(cd .. && pwd)
GO_PROTOBUf_PATH=$(go list -f '{{ .Dir }}' -m google.golang.org/protobuf)

echo "-----------------------------"
echo "ROOT_PATH:         $ROOT_PATH"
echo "GO_PROTOBUf_PATH:  $GO_PROTOBUf_PATH"
echo "using protoc     : $(protoc --version)"
echo "-----------------------------"

IMPORT_BASE_PATH=`pwd`


# generate golang codes
GOLANG_OUTPUT=gen/go/pb
proto_files=$(find ./proto -iname "*.proto")
for proto_file in $proto_files
do
    echo $proto_file
    protoc \
        -I=".:$IMPORT_BASE_PATH:$ROOT_PATH:$GO_PROTOBUf_PATH" \
        --go_out $OUTPUT_GOLANG --go_opt paths=source_relative \
        --go-grpc_out $OUTPUT_GOLANG --go-grpc_opt paths=source_relative \
        $proto_file
done

go mod tidy
echo "done"
