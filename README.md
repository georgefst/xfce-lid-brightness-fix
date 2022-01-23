See [XFCE issue](https://gitlab.xfce.org/xfce/xfce4-power-manager/-/issues/100) for background.

Note that, without package overrides, this currently only builds with GHC 8.10 (and possibly 9.0). An [update to `rawfilepath`](https://github.com/xtendo-org/rawfilepath/pull/5) is required for 9.2. When that lands, we can use `{-# LANGUAGE GHC2021 #-}` to avoid most of the existing pragmas. And I should add version bounds for dependencies.
