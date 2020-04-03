package main

import (
	v0 "github.com/Wr4thon/microServices/pkg/api/v0"
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func main() {
	e := echo.New()
	apiV0 := v0.NewAPIv0()

	e.Use(middleware.Recover())
	e.Use(middleware.Logger())

	authenticate := e.Group("authenticate/")
	e.GET("alive", isAlive)
	apiV0.Register(authenticate)

	e.Logger.Fatal(e.Start(":8080"))
}

func isAlive(c echo.Context) error {
	return c.JSON(200, struct {
		Message string `json:"message"`
	}{Message: "ok"})
}
