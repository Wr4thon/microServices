#!/bin/sh

go fmt ./...
go vet ./...
gofmt -s -d .