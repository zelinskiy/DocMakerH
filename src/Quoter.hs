{-# LANGUAGE TemplateHaskell, QuasiQuotes, FlexibleContexts, DeriveLift #-}

module Quoter where

import Language.Haskell.TH
import Language.Haskell.TH.Quote
import Language.Haskell.TH.Syntax
import Text.Regex
import Data.List

import Quoter.ParseHelpers
import Quoter.Types

testcases :: QuasiQuoter
testcases = QuasiQuoter {
          quoteExp = quoteExp1,
          quotePat = undefined,
          quoteType = undefined,
          quoteDec = undefined
       }

quoteExp0 :: String -> Q Exp
quoteExp0 = stringE

quoteExp1 :: String -> Q Exp
quoteExp1 = lift . map parseTestCase . drop 1 . deepDelimBy "TESTCASE"

parseTestCase :: String -> TestCase
parseTestCase s = TestCase{
  desc = clear $ enclosedBy "DESC" "PROC" s,
  proc = delimBy "|>" $ clear $ enclosedBy "PROC" "OUTP" s,
  outp = clear $ enclosedBy "OUTP" "DATE" s,
  date = catchDate $ enclosedBy "DATE" "NOTE" s,
  result = checkRes $ enclosedBy "DATE" "NOTE" s,
  note = Nothing
  }
  where checkRes ss =  if      "PASS" `isInfixOf` ss then Pass
                      else if  "FAIL" `isInfixOf` ss then Fail
                      else    Fail
        clear = filter (\c -> c /= '\n' && c /= '\t')
        catchDate ss = case matchRegex (mkRegex "([0-9]{2}.[0-9]{2}.[0-9]{4})") ss of
          Just (m:_) -> mkDate dd mm yyyy where
            dd =    read $ take 2 m
            mm =    read $ take 2 $ drop 3 m
            yyyy =  read $ drop 6 m
          _ -> mkDate 1 2 1
