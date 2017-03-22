module Quoter.ParseHelpers where

import Text.Regex
import Quoter.Types

delimBy :: String -> String -> [String]
delimBy d = splitRegex $ mkRegex ("["++d++"]+")

deepDelimBy :: String -> String -> [String]
deepDelimBy d = splitRegex $ mkRegex d

enclosedBy :: String -> String -> String -> String
enclosedBy a b s = match
  where match :: String
        match = case matchRegex (mkRegex $ a++"((.*?\n?)*)"++b) s of
          Just (m:ms) -> m
          _ -> ""
        dropped = drop $ length a
        tail' ss = take (length ss - length b) ss
