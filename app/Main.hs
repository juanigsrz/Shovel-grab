module Main (main) where

import Parsing
import Text.Megaparsec

main :: IO ()
main = do
  input <- getContents
  parseTest parser input
