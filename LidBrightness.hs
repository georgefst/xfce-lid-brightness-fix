#!/usr/bin/env cabal

{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}
{-# OPTIONS_GHC -Wall #-}

{- cabal:
build-depends:
    base,
    evdev-streamly,
    evdev,
    process,
    streamly,
-}

module Main (main) where

import Evdev
import Evdev.Codes (SwitchEvent (SwLid))
import Evdev.Stream
import Streamly.Prelude qualified as S
import System.Process

main :: IO ()
main = do
    d <- newDevice "/dev/input/event0"
    S.drain $ S.scanlM' f getBrightness $ readEvents d
  where
    f b e = case eventData e of
        SwitchEvent SwLid (EventValue 0) -> do
            setBrightness b
            pure b
        SwitchEvent SwLid (EventValue 1) -> do
            b' <- getBrightness
            setBrightness 0
            pure b'
        _ -> pure b
    setBrightness s = callProcess "brightnessctl" ["s", show @Int s]
    getBrightness = read <$> readProcess "brightnessctl" ["g"] ""
