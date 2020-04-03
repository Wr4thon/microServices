package v0

import (
	"github.com/Wr4thon/microServices/pkg/api"
	"github.com/labstack/echo/v4"
)

type apiV0 struct {
}

// NewAPIv0 returns a new foo
func NewAPIv0() api.API {
	return &apiV0{}
}

func (a *apiV0) Register(g *echo.Group) error {
	g.GET("", a.handler)
	return nil
}

func (a *apiV0) handler(c echo.Context) error {

	return c.String(200, "Hello World!")
}
