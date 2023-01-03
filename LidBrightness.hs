#!/usr/bin/env cabal

{-# LANGUAGE GHC2021 #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wall #-}

{- cabal:
build-depends:
    base >= 4.16,
    evdev >= 2.1,
    evdev-streamly >= 0.0.2,
    process >= 1.6,
    streamly >= 0.8,
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
