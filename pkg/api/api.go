package api

import "github.com/labstack/echo/v4"

// API is the base api interface
type API interface {
	Register(*echo.Group) error
}
