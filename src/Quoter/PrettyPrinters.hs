module Quoter.PrettyPrinters where

import Quoter.Utils
import Quoter.Types

showMD :: Int -> TestCase -> MDoutput
showMD i (TestCase desc proc outp date res note) =
  "|" ++ "TC" ++ show i
  ++ "|" ++ br desc
  ++ "|<ol>" ++ concatMap (\p -> "<li>" ++ br p ++ "</li>") proc ++ "</ol>"
  ++ "|" ++ br outp
  ++ "|" ++ show res
  ++ "|" ++ show date
  ++ "|" ++ showNote note
  ++ "|"
  where showNote (Just n) = br n
        showNote Nothing = ""
        br = insertEvery 20 "<br/>"

showMDtable :: [TestCase] -> MDoutput
showMDtable = (pref ++) . concat . map (++"\n") . zipWith showMD [1..]
  where pref =  "| Id | Description | Steps | Output | Result | Date | Notes |\n"
              ++"|----|-------------|-------|--------|--------|------|-------|\n"
